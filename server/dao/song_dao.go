package dao

import (
	"database/sql/driver"
	"encoding/json"
	"math/rand"
	"time"
)

type SongFile struct {
	URL        string `json:"url,omitempty" db:"url"`
	Size       int    `json:"size,omitempty" db:"size"`
	Md5        string `json:"md5,omitempty" db:"md5"`
	EncodeType string `json:"encode_type,omitempty" db:"encode_type"`
}

func (m *SongFile) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m SongFile) Value() (driver.Value, error) {
	return json.Marshal(m)
}

type SongURL map[string]SongFile

func (m *SongURL) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m SongURL) Value() (driver.Value, error) {
	return json.Marshal(m)
}

type Song struct {
	ID          uint      `json:"id" gorm:"primarykey;autoIncrement" db:"id"`
	DataID      string    `json:"data_id" gorm:"uniqueIndex;type:varchar(1024)" db:"data_id"`
	CreatedAt   time.Time `json:"created_at,omitempty" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at,omitempty" db:"update_at"`
	Name        string    `json:"name" db:"name"`
	SingerName  string    `json:"singer_name" gorm:"column:singer_name;index:index_singer_name" db:"singer_name"`
	AlbumName   string    `json:"album_name" db:"album_name"`
	URLs        SongURL   `json:"urls" db:"urls"`
	Tags        string    `json:"tags" db:"tags"`
	Words       string    `json:"words" db:"words"`
	PublishTime int64     `json:"publishTime,omitempty" db:"publish_time"`
	SongLength  int       `json:"song_length,omitempty" db:"song_length"`
	Album       Album     `json:"al,omitempty" gorm:"type:TEXT" db:"album"`
	Arists      SingerArr `json:"ar,omitempty" gorm:"type:TEXT" db:"arists"`
	PicName     string    `json:"pic_name" db:"pic_name"`
}

func (m *Song) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m Song) Value() (driver.Value, error) {
	return json.Marshal(m)
}

type SongArray []Song

func (m *SongArray) Scan(src interface{}) error {
	if src == nil {
		return nil
	}

	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m SongArray) Value() (driver.Value, error) {
	return json.Marshal(m)
}

func (p *Song) GetMaxID() error {
	return db.Table("songs").Order("id desc").First(p).Error
}

func (p *Song) Find(offset, limit int) (rr []Song, e error) {
	tx := db.Offset(offset).Limit(limit)

	if p.ID > 0 {
		tx = tx.Where("id = ?", p.ID)
	} else if p.Name != "" && p.SingerName != "" {
		tx = tx.Where("name LIKE ?", "%"+p.Name+"%").Or("singer LIKE ?", "%"+p.SingerName+"%")
	} else if p.Name != "" {
		tx = tx.Where("name LIKE ?", "%"+p.Name+"%")
	}

	e = tx.Find(&rr).Error

	return
}

func (p *Song) FindByIDs(ids []uint64) (rr []Song, e error) {
	e = db.Where("id in ?", ids).Find(&rr).Error
	return
}
func (p *Song) FindBySingerName(offset, limit int) (rr []Song, e error) {
	e = db.Offset(offset).Limit(limit).Where("singer_name = ?", p.SingerName).Find(&rr).Error

	return
}

func (p *Song) FindByDataIDs(ids []string) (rr []Song, e error) {
	e = db.Where("data_id in (?)", ids).Find(&rr).Error
	return
}

func (p *Song) FindRand(limit int) (rr []Song, e error) {
	e = db.Table("songs").Limit(limit).Where("id >= ?", rand.Intn(int(maxSongID))).Find(&rr).Error

	return
}

func (p *Song) Add() error {
	return db.Table("songs").Create(p).Error
}
