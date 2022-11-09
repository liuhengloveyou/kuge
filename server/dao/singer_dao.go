package dao

import (
	"database/sql/driver"
	"encoding/json"
	"time"
)

type Singer struct {
	ID          uint   `json:"id" validate:"-" db:"id" gorm:"primarykey;autoIncrement"`
	DataID      string `json:"data_id" gorm:"column:data_id;uniqueIndex;type:varchar(128)"`
	CreatedAt   time.Time
	UpdatedAt   time.Time
	Name        string     `json:"name" gorm:"column:name;uniqueIndex:idx_name;type:varchar(64)" db:"name"` // 名称
	Lang        string     `json:"la" db:"lang"`                                                            // 国集
	Category    string     `json:"cat" db:"category"`                                                       // 类型
	FirstLetter string     `json:"ft" db:"first_letter"`                                                    // 类型
	AvatarName  string     `json:"avatar_name" db:"avatar_name"`                                            // 头像URL
	AvatarURL   string     `json:"avatar_url"`                                                              // 头像URL
	Intro       string     `json:"intro" gorm:"column:intro" db:"intro"`                                    // 简介
	HotSongs    SongArray  `json:"hot_songs"`
	Albums      AlbumArray `json:"albums"`
}

func (m *Singer) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m Singer) Value() (driver.Value, error) {
	return json.Marshal(m)
}

type SingerArr []Singer

func (m *SingerArr) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m SingerArr) Value() (driver.Value, error) {
	return json.Marshal(m)
}

func (p *Singer) Find(offset, limit int) (rr []Singer, e error) {
	tx := db.Offset(offset).Limit(limit).Order("first_letter,name")

	if p.ID > 0 {
		tx = tx.Where("id = ?", p.ID)
	} else if p.Name != "" {
		tx = tx.Where("name LIKE ?", "%"+p.Name+"%")
	} else {
		if p.Lang != "" {
			tx = tx.Where("lang = ?", p.Lang)
		}
		if p.FirstLetter != "" {
			tx = tx.Where("first_letter = ?", p.FirstLetter)
		}
		if p.Category != "" {
			tx = tx.Where("category = ?", p.Category)
		}
	}

	e = tx.Find(&rr).Error

	return
}

func (p *Singer) FindByName(offset, limit int) (rr []Singer, e error) {
	e = db.Offset(offset).Limit(limit).Where("name = ?", p.Name).Find(&rr).Error

	return
}
