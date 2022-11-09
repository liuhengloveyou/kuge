package service

import (
	"fmt"

	"kuge/common"
	"kuge/dao"
)

func GetAlbums(id uint, singer string, offset, limit int) ([]dao.Album, error) {
	m := &dao.Album{
		ID:     id,
		Singer: singer,
	}

	rr, err := m.LoadPage(offset, limit)
	if err != nil {
		logger.Errorf("GetAlbums db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		rr[i].ThumbURL = fmt.Sprintf("%s/album_coverimg/%s", common.ServConfig.ImgServer, rr[i].ThumbURL)
		rr[i].Songs = loadSongs(rr[i].Songs)
	}

	return rr, nil
}

func GetAlbumsBySingerName(singer string, offset, limit int) ([]dao.Album, error) {
	m := &dao.Album{
		Singer: singer,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("GetAlbums db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		rr[i].ThumbURL = fmt.Sprintf("%s/album_coverimg/%s", common.ServConfig.ImgServer, rr[i].ThumbURL)
	}

	return rr, nil
}

func GetAlbumDetail(id uint) (dao.Album, error) {
	m := &dao.Album{
		ID: id,
	}

	rr, err := m.Find(0, 1)
	if err != nil {
		logger.Errorf("GetAlbums db ERR:", err.Error())
		return *m, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		rr[i].ThumbURL = fmt.Sprintf("%s/album_coverimg/%s", common.ServConfig.ImgServer, rr[i].ThumbURL)
		rr[i].Songs = loadSongs(rr[i].Songs)
	}

	return rr[0], nil
}
