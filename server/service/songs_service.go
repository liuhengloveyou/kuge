package service

import (
	"fmt"

	"kuge/common"
	"kuge/dao"
)

func GetSongsRand(limit int) ([]dao.Song, error) {
	m := &dao.Song{}

	rr, err := m.FindRand(limit)
	if err != nil {
		logger.Errorf("GetSongsRand db ERR: %v\n", err.Error())
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

func GetSongInfo(id uint, offset, limit int) ([]dao.Song, error) {
	m := &dao.Song{
		ID: id,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("GetSongs db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		picNameLen := len(rr[i].PicName)
		if picNameLen > 6 {
			rr[i].PicName = fmt.Sprintf("%s/album_coverimg/%s", common.ServConfig.ImgServer, rr[i].PicName)
		}

		for k, v := range rr[i].URLs {
			v.URL = fmt.Sprintf("%s/song/%s", common.ServConfig.ImgServer, v.URL)
			rr[i].URLs[k] = v
		}
	}

	return rr, nil
}

func GetSongByDataIDs(ids []string) (dao.SongArray, error) {
	m := &dao.Song{}

	rr, err := m.FindByDataIDs(ids)
	if err != nil {
		logger.Errorf("FindByDataIDs db ERR:", err.Error())
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

func GetSongByIDs(ids []uint64) (dao.SongArray, error) {
	m := &dao.Song{}

	rr, err := m.FindByIDs(ids)
	if err != nil {
		logger.Errorf("GetSongByIDs db ERR:", err.Error())
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

func GetSongBySingerName(singerName string, offset, limit int) (dao.SongArray, error) {
	m := &dao.Song{
		SingerName: singerName,
	}

	rr, err := m.FindBySingerName(offset, limit)
	if err != nil {
		logger.Errorf("GetSongBySingerName db ERR:", err.Error())
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
