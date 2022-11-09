package service

import (
	"fmt"

	"kuge/dao"
)

func LoadUserInfo(uid uint64) (r dao.User, e error) {
	r, e = (&dao.User{ID: uid}).LoadByID()
	return
}

func UserUpdate(uid uint64, data map[string]interface{}) error {
	m := &dao.User{ID: uid}

	if v, ok := data["song_play_history"]; ok {
		m.SongPlayHistory = make(dao.Uint64Arr, len(v.([]interface{})))
		for i := 0; i < len(v.([]interface{})); i++ {
			m.SongPlayHistory[i] = uint64((v.([]interface{}))[i].(float64))
		}

		return m.UpdateSongPlayHistory()
	}

	if v, ok := data["song_collect"]; ok {
		m.SongCollect = make(dao.Uint64Arr, len(v.([]interface{})))
		for i := 0; i < len(v.([]interface{})); i++ {
			m.SongCollect[i] = uint64((v.([]interface{}))[i].(float64))
		}

		return m.UpdateSongCollect()
	}

	return fmt.Errorf("参数错误")
}
