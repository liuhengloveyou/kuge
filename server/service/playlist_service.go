package service

import (
	"fmt"

	"kuge/common"
	"kuge/dao"
)

func GetPlayListRand(limit int) ([]dao.Playlist, error) {
	m := &dao.Playlist{}

	rr, err := m.FindRand(limit)
	if err != nil {
		logger.Errorf("GetPlayListRand db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		CoverImgNameLen := len(rr[i].CoverImgName)
		if CoverImgNameLen > 6 {
			rr[i].CoverImgName = fmt.Sprintf("%s/playlist_coverimg/%s/%s", common.ServConfig.ImgServer, rr[i].CoverImgName[CoverImgNameLen-6:CoverImgNameLen-4], rr[i].CoverImgName)
		}
	}

	return rr, nil
}

func GetPlayList(id uint, tag string, offset, limit int) ([]dao.Playlist, error) {
	m := &dao.Playlist{
		ID:   id,
		Tags: tag,
	}

	logger.Infof("GetPlayList :%v\n", m)
	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("GetPlayList db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		ThumbNameLen := len(rr[i].CoverImgName)
		rr[i].CoverImgName = fmt.Sprintf("%s/playlist_coverimg/%s/%s", common.ServConfig.ImgServer, rr[i].CoverImgName[ThumbNameLen-6:ThumbNameLen-4], rr[i].CoverImgName)

		rr[i].Tracks = loadSongs(rr[i].Tracks)
	}

	return rr, nil
}

func GetPlayList1(id string, offset, limit int) ([]dao.Playlist, error) {
	m := &dao.Playlist{
		DataID: id,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("GetPlayList db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		// rr[i].ThumbURL = fmt.Sprintf("/public/images/playlistthumb-%d.jpg", rr[i].ID)
		rr[i].Tracks = loadSongs(rr[i].Tracks)
	}

	return rr, nil
}

func loadSongs(songs dao.SongArray) dao.SongArray {
	dataIDs := make([]string, len(songs))

	for i, tmpSong := range songs {
		dataIDs[i] = tmpSong.DataID
	}

	songsRst, err := GetSongByDataIDs(dataIDs)
	if err != nil {
		logger.Errorf("GetSongByDataIDs ERR: ", err)
	}

	// 随机加载一些歌
	if len(songsRst) < 3 {
		randSong, err := GetSongsRand(10)
		if err != nil {
			logger.Errorf("GetSongsRand ERR: ", err)
		}
		songsRst = append(songsRst, randSong...)
	}

	return songsRst
}
