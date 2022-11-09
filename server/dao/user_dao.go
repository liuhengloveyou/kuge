package dao

import "encoding/json"

type User struct {
	ID uint64 `json:"id" gorm:"column:uid;primarykey;autoIncrement"`

	SongPlayHistory Uint64Arr `json:"songPlayHistory" gorm:"column:song_play_history"`
	SongCollect     Uint64Arr `json:"songCollect" gorm:"column:song_collect"`
}

func (m *User) LoadByID() (r User, e error) {
	e = db.Table("users").Where("uid = ?", m.ID).Take(&r).Error
	return
}

func (m *User) UpdateSongPlayHistory() error {
	value, _ := json.Marshal(m.SongPlayHistory)
	return db.Table("users").Where("uid = ?", m.ID).UpdateColumn("song_play_history", value).Error
}

func (m *User) UpdateSongCollect() error {
	value, _ := json.Marshal(m.SongCollect)
	return db.Table("users").Where("uid = ?", m.ID).UpdateColumn("song_collect", value).Error
}
