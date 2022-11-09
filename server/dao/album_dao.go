package dao

import (
	"database/sql/driver"
	"encoding/json"
	"time"

	null "gopkg.in/guregu/null.v3/zero"
)

type Album struct {
	ID uint `json:"id" db:"id" gorm:"column:id"`
	// DataID      string       `json:"data_id" gorm:"column:data_id;uniqueIndex;type:varchar(1024)" db:"data_id"`
	Name        string       `json:"name" db:"name" gorm:"column:name"`                               // 名称
	Singer      string       `json:"singer" db:"singer" gorm:"column:singer;index:index_singer_name"` // 歌手名称
	ThumbURL    string       `json:"thumb_img" db:"thumb_img" gorm:"column:thumb_img"`                // 头像URL
	Companies   string       `json:"companies" db:"companies" gorm:"column:companies"`                // 头像URL
	ReleaseTime time.Time    `json:"release_time" db:"release_time" gorm:"column:release_time"`       // 头像URL
	Intro       *null.String `json:"intro" db:"intro" gorm:"column:intro"`                            // 简介
	Songs       SongArray    `json:"songs" db:"songs" gorm:"column:songs"`                            // 简介
}

func (m *Album) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m Album) Value() (driver.Value, error) {
	return json.Marshal(m)
}

type AlbumArray []Album

func (m *AlbumArray) Scan(src interface{}) error {
	if src == nil {
		return nil
	}

	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m AlbumArray) Value() (driver.Value, error) {
	return json.Marshal(m)
}

func (p *Album) LoadPage(offset, limit int) (rr []Album, e error) {
	e = db.Offset(offset).Limit(limit).Order("release_time desc").Find(&rr).Error

	return
}

func (p *Album) Find(offset, limit int) (rr []Album, e error) {
	tx := db.Offset(offset).Limit(limit).Order("id desc")

	if p.ID > 0 {
		tx = tx.Where("id = ?", p.ID)
	} else if p.Name != "" {
		tx = tx.Where("name LIKE ?", "%"+p.Name+"%")
	} else if p.Singer != "" {
		tx = tx.Where("singer = ?", p.Singer)
	} else {
		tx = tx.Where("songs is not null") // 列表只显示有歌的
	}

	e = tx.Find(&rr).Error

	return
}
