package dao

import (
	"fmt"
	"time"
)

type PWDQuestionStrut struct {
	UID        uint64     `json:"uid" db:"uid"`
	Question   int        `json:"question" db:"question"`
	Answer     string     `json:"answer" db:"answer"`
	Cellphone  string     `json:"cellphone" db:"cellphone"`
	UpdateTime *time.Time `json:"updateTime,omitempty" db:"update_time"`
}

func (p *PWDQuestionStrut) Add() error {
	sql := fmt.Sprintf("INSERT INTO pwd_question(uid, cellphone, question, answer) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE question=?, answer = ?")

	_, e := mysqlCli.Exec(sql, p.UID, p.Cellphone, p.Question, p.Answer, p.Question, p.Answer)

	return e
}

func (p *PWDQuestionStrut) GetByCellphone() (r PWDQuestionStrut, e error) {
	sql := fmt.Sprintf("SELECT uid, question, answer, cellphone FROM pwd_question WHERE cellphone = ?")

	e = mysqlCli.Get(&r, sql, p.Cellphone)

	return
}

func ResetPWD(uid uint64, pwd string) (e error) {
	sql := fmt.Sprintf("UPDATE users SET `password` = ? WHERE (`uid` = ?)")

	_, e = mysqlCli.Exec(sql, pwd, uid)

	return
}
