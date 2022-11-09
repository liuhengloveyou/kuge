package service

import (
	"fmt"

	"kuge/common"
	"kuge/dao"
)

func Search(t, k string, offset, limit int) (interface{}, error) {
	if t == "" || k == "" {
		return nil, fmt.Errorf("参数错误")
	}

	// A: 歌手；B:单曲；C: 专辑；D: 歌单
	switch t {
	case "A":
		return searchArtist(k, offset, limit)
	case "B":
		return searchSongs(k, offset, limit)
	case "C":
		return searchAlbum(k, offset, limit)
	case "D":
		return searchPlayLists(k, offset, limit)
	default:
		return nil, fmt.Errorf("参数错误")
	}
}

func searchArtist(k string, offset, limit int) ([]dao.Singer, error) {
	m := &dao.Singer{
		Name: k,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("searchArtist db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		avatarNameLen := len(rr[i].AvatarName)
		rr[i].AvatarURL = fmt.Sprintf("%s/avatar/%s/%s", common.ServConfig.ImgServer, rr[i].AvatarName[avatarNameLen-6:avatarNameLen-4], rr[i].AvatarName)
	}

	return rr, nil
}

func searchAlbum(k string, offset, limit int) ([]dao.Album, error) {
	m := &dao.Album{
		Name: k,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("searchAlbum db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		rr[i].ThumbURL = fmt.Sprintf("%s/album_coverimg/%s", common.ServConfig.ImgServer, rr[i].ThumbURL)
	}

	return rr, nil

}

func searchSongs(k string, offset, limit int) ([]dao.Song, error) {
	m := &dao.Song{
		Name: k,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("searchSongs db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		rr[i].PicName = fmt.Sprintf("%s/album_coverimg/%s", common.ServConfig.ImgServer, rr[i].PicName)

		for k, v := range rr[i].URLs {
			v.URL = fmt.Sprintf("%s/song/%s", common.ServConfig.ImgServer, v.URL)
			rr[i].URLs[k] = v
		}
	}

	return rr, nil
}

func searchPlayLists(k string, offset, limit int) ([]dao.Playlist, error) {
	m := &dao.Playlist{
		Name: k,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("searchPlayLists db ERR:", err.Error())
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
