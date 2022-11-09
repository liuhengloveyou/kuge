package dao

import (
	"database/sql/driver"
	"encoding/json"
	"time"
)

type Feedback struct {
	ID              uint      `json:"id" gorm:"primarykey;autoIncrement"`
	UserID          uint      `json:"user_id" gorm:"index:index_user_id;type:BIGINT"`
	UserName        string    `json:"user_name" gorm:"type:varchar(45)"`
	CreatedAt       time.Time `json:"created_at,omitempty"`
	UpdatedAt       time.Time `json:"updated_at,omitempty"`
	FeedbackType    string    `json:"feedback_type" gorm:"type:varchar(64);index:index_feedback_type"`
	FeedbackContent string    `json:"content" gorm:"type:varchar(128)"`
}

func (m *Feedback) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m Feedback) Value() (driver.Value, error) {
	return json.Marshal(m)
}

type FeedbackArray []Feedback

func (m *FeedbackArray) Scan(src interface{}) error {
	if src == nil {
		return nil
	}

	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m FeedbackArray) Value() (driver.Value, error) {
	return json.Marshal(m)
}

func (p *Feedback) List(minID, limit uint) (rr FeedbackArray, e error) {
	tx := db.Table("feedbacks").Order("id desc").Limit(int(limit))
	if minID > 0 {
		tx = tx.Where("id < ?", minID)
	}

	e = tx.Find(&rr).Error

	return
}

func (p *Feedback) Add() error {
	return db.Table("feedbacks").Create(p).Error
}

func (p *Feedback) Count() (count int64, e error) {
	e = db.Table("feedbacks").Count(&count).Error
	return
}
