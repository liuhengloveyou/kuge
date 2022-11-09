package dao

import (
	"math/rand"
	"time"

	null "gopkg.in/guregu/null.v3/zero"
)

type Playlist struct {
	ID           uint   `json:"id" gorm:"primarykey;autoIncrement" db:"id"`
	DataID       string `json:"data_id" gorm:"column:data_id;uniqueIndex;type:varchar(128)" db:"data_id"`
	CreatedAt    time.Time
	UpdatedAt    time.Time
	Name         string       `json:"name" gorm:"column:name;uniqueIndex:idx_name;type:varchar(64)" db:"name"`
	CoverImgName string       `json:"cover_img_name" db:"cover_img_name"`
	Tags         string       `json:"tags" db:"tags"`
	Intro        *null.String `json:"intro" db:"intro"`
	Tracks       SongArray    `json:"track_ids" gorm:"column:track_ids" db:"track_ids"`
	PlayCount    uint         `json:"play_count" gorm:"column:play_count;type:int" db:"play_count"`
	ShareCount   uint         `json:"share_count" gorm:"column:share_count;type:int" db:"share_count"`
	TrackCount   uint         `json:"track_count" gorm:"column:track_count;type:int" db:"track_count"`
}

func (p *Playlist) GetMaxID() error {
	return db.Table("playlists").Order("id desc").First(p).Error
}

func (p *Playlist) Find(offset, limit int) (rr []Playlist, e error) {
	tx := db.Table("playlists").Offset(offset).Limit(limit)

	if p.ID > 0 {
		tx = tx.Where("id = ?", p.ID)
	}
	if p.DataID != "" {
		tx = tx.Where("data_id = ?", p.ID)
	}
	if p.Name != "" {
		tx = tx.Where("name LIKE ?", "%"+p.Name+"%")
	}
	if p.Tags != "" {
		tx = tx.Where("tags LIKE ?", "%"+p.Tags+"%")
	}

	e = tx.Find(&rr).Where("track_count > 3").Order("updated_at desc").Error

	return
}

func (p *Playlist) FindRand(limit int) (rr []Playlist, e error) {
	e = db.Table("playlists").Limit(limit).Where("id >= ? and track_count > 10", rand.Intn(int(maxPlaylistID))).Find(&rr).Error

	return
}
