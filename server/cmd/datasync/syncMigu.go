package datasync

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path"
	"strconv"
	"strings"

	mysqldriver "github.com/go-sql-driver/mysql"
	gocommon "github.com/liuhengloveyou/go-common"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"

	"kuge/dao"
)

var (
	miguGorm *gorm.DB
)

func SyncMigu() {
	var err error

	dsn := "root:lhisroot@tcp(127.0.0.1:3306)/migu?charset=utf8mb4&parseTime=true"
	if miguGorm, err = gorm.Open(mysql.Open(dsn), &gorm.Config{}); err != nil {
		panic(err)
	}

	var results []map[string]interface{}
	if err = miguGorm.Table("songs").Order("id desc").Find(&results).Error; err != nil {
		panic(err)
	}

	for i := 0; i < len(results); i++ {
		o := results[i]
		if o["info"] == nil {
			continue
		}

		var info []map[string]interface{}
		if err := json.Unmarshal([]byte(o["info"].(string)), &info); err != nil {
			panic(err)
		}
		if len(info) < 1 {
			continue
		}

		tags, _ := json.Marshal(strings.Fields(o["tags"].(string)))
		song := dao.Song{
			Name:       o["name"].(string),
			SingerName: o["singer"].(string),
			AlbumName:  o["album"].(string),
			Tags:       string(tags),
		}
		if o["words"] != nil {
			song.Words = o["words"].(string)
		}

		song.DataID = fmt.Sprintf("1-%v", info[0]["id"])

		if info[0]["songLength"] != nil {
			ts := strings.Split(info[0]["songLength"].(string), ":")
			if len(ts) == 3 {
				min, _ := strconv.Atoi(ts[1])
				sec, _ := strconv.Atoi(ts[2])
				song.SongLength = min*60 + sec
			} else if len(ts) == 2 {
				min, _ := strconv.Atoi(ts[0])
				sec, _ := strconv.Atoi(ts[1])
				song.SongLength = min*60 + sec
			}
		}

		// 下载图片
		if info[0]["pic"] != nil && info[0]["pic"].(string) != "" {
			song.PicName = downloadAlbumImg("http:" + info[0]["pic"].(string))
		}

		// 专辑信息
		if info[0]["albumInfo"] != nil {
			albumInfos := info[0]["albumInfo"].([]interface{})
			if len(albumInfos) > 0 {
				song.Album = dao.Album{
					DataID: fmt.Sprintf("1-%v", albumInfos[0].(map[string]interface{})["albumId"]),
					Name:   albumInfos[0].(map[string]interface{})["albumName"].(string),
				}
			}
		}

		// 歌手信息
		if info[0]["singerInfo"] != nil {
			singerInfo := info[0]["singerInfo"].([]interface{})
			if len(singerInfo) > 0 {
				song.Arists = dao.SingerArr{
					dao.Singer{
						DataID: fmt.Sprintf("1-%v", singerInfo[0].(map[string]interface{})["artistId"]),
						Name:   singerInfo[0].(map[string]interface{})["artistName"].(string),
					},
				}
			}
		}

		// 文件
		song.URLs = make(dao.SongURL, 3)
		if bqUrl, ok := info[0]["bqUrl"]; ok {
			ext := path.Ext(bqUrl.(string))
			if len(ext) > 2 {
				song.URLs["bq"] = dao.SongFile{
					URL:        fmt.Sprintf("mp3/BQ/%s-BQ%s", o["cid"], ext),
					EncodeType: ext[1:],
				}
				downloadMp3(o["cid"].(string), bqUrl.(string), "BQ")
			}
		}
		if hqUrl, ok := info[0]["hqUrl"]; ok {
			ext := path.Ext(hqUrl.(string))
			if len(ext) > 2 {
				song.URLs["hq"] = dao.SongFile{
					URL:        fmt.Sprintf("mp3/HQ/%s-HQ%s", o["cid"], ext),
					EncodeType: ext[1:],
				}
				downloadMp3(o["cid"].(string), hqUrl.(string), "HQ")
			}
		}
		if sqUrl, ok := info[0]["sqUrl"]; ok {
			ext := path.Ext(sqUrl.(string))
			if len(ext) > 2 {
				song.URLs["sq"] = dao.SongFile{
					URL:        fmt.Sprintf("mp3/SQ/%s-SQ%s", o["cid"], ext),
					EncodeType: ext[1:],
				}
				downloadMp3(o["cid"].(string), sqUrl.(string), "SQ")
			}
		}

		if err = song.Add(); err != nil {
			myerr, ok := err.(*mysqldriver.MySQLError)
			if !ok || myerr.Number != 1062 {
				panic(err)
			}
		}

		fmt.Printf(">>>%d %#v \n", o["id"], song)
	}
}

func downloadMp3(cid, url, q string) error {
	ext := path.Ext(url)
	exists, _ := PathExists(fmt.Sprintf("/Volumes/disk1/music.migu.cn/mp3/%s-%s%s", cid, q, ext))
	exists1, _ := PathExists(fmt.Sprintf("/Volumes/disk1/music.migu.cn/mp3/%s/%s-%s%s", q, cid, q, ext))
	if exists {
		os.Rename(fmt.Sprintf("/Volumes/disk1/music.migu.cn/mp3/%s-%s%s", cid, q, ext), fmt.Sprintf("/Volumes/disk1/music.migu.cn/mp3/%s/%s-%s%s", q, cid, q, ext))
		return nil
	}
	if exists || exists1 {
		return nil
	}

	fmt.Printf("down: /Volumes/disk1/music.migu.cn/mp3/%s/%s-%s%s\n", q, cid, q, ext)

	down := gocommon.Downloader{
		URL:     url,
		DstPath: fmt.Sprintf("/Volumes/disk1/music.migu.cn/mp3/%s/%s-%s%s", q, cid, q, ext),
		TmPath:  "/Volumes/disk1/music.migu.cn/mp3/temp/",
	}

	_, _, err := down.Download(context.Background())
	if err != nil {
		fmt.Println("song.downloadMp3 ERR: ", err)
		return fmt.Errorf("down mp3 error")
	}

	return nil
}

func downloadAlbumImg(url string) string {
	destFn := fmt.Sprintf("/Volumes/disk1/NeteaseCloudMusic/download/album_coverimg/%s/%s", url[len(url)-6:len(url)-4], path.Base(url))

	exists, _ := PathExists(destFn)
	if exists {
		return path.Base(destFn)
	}

	down := gocommon.Downloader{
		URL:     url,
		DstPath: destFn,
		TmPath:  fmt.Sprintf("/Volumes/disk1/NeteaseCloudMusic/download/album_coverimg/temp/"),
	}

	_, fn, err := down.Download(context.Background())
	if err != nil {
		fmt.Println("song.downloadAlbumImg ERR: ", destFn, err)
		return ""
	}

	return path.Base(fn)
}

func PathExists(path string) (bool, error) {
	_, err := os.Stat(path)

	if err == nil {
		return true, nil
	}

	if os.IsNotExist(err) {
		return false, nil
	}

	return false, err
}
