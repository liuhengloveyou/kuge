package service

import (
	"fmt"

	"kuge/common"
	"kuge/dao"
)

func GetSingers(id uint, lang, category, firstLetter string, offset, limit int) ([]dao.Singer, error) {
	m := &dao.Singer{
		ID:          id,
		Lang:        lang,
		Category:    category,
		FirstLetter: firstLetter,
	}

	rr, err := m.Find(offset, limit)
	if err != nil {
		logger.Errorf("GetSingers db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	for i := 0; i < len(rr); i++ {
		rr[i].AvatarURL = fmt.Sprintf("%s/avatar/%s", common.ServConfig.ImgServer, rr[i].AvatarName)
	}

	return rr, nil
}

func SingerDetail(id uint) (*dao.Singer, error) {
	m := &dao.Singer{
		ID: id,
	}

	rr, err := m.Find(0, 1)
	if err != nil {
		logger.Errorf("SingerDetail db ERR:", err.Error())
		return nil, fmt.Errorf("服务错误")
	}

	if len(rr) != 1 {
		return nil, nil
	}

	avatarNameLen := len(rr[0].AvatarName)
	rr[0].AvatarURL = fmt.Sprintf("%s/avatar/%s/%s", common.ServConfig.ImgServer, rr[0].AvatarName[avatarNameLen-6:avatarNameLen-4], rr[0].AvatarName)

	rr[0].Albums, _ = GetAlbumsBySingerName(rr[0].Name, 0, 20)
	rr[0].HotSongs, _ = GetSongBySingerName(rr[0].Name, 0, 20)

	return &rr[0], nil
}
