package service

import (
	"fmt"

	"kuge/dao"

	passport "github.com/liuhengloveyou/passport/service"
)

func SetPwdQuestion(uid uint64, cellphone string, question int, answer, pwd string) error {
	auth, _ := passport.AuthPWDService(uid, pwd)
	if auth == false {
		return fmt.Errorf("密码验证不通过")
	}

	m := &dao.PWDQuestionStrut{
		UID:       uid,
		Cellphone: cellphone,
		Question:  question,
		Answer:    answer,
	}

	if e := m.Add(); e != nil {
		return e
	}

	return nil
}

func ResetPwd(cellphone string, question int, answer string) error {
	m := &dao.PWDQuestionStrut{
		Cellphone: cellphone,
	}

	r, e := m.GetByCellphone()
	if e != nil {
		return e
	}

	if r.Question != question || r.Answer != answer {
		return fmt.Errorf("密码保护问题错误")
	}

	e = dao.ResetPWD(r.UID, "131436b2b584610a6c624051b56278ffd08b1bafaa116b1609a972cb0f8fbc23")
	if e != nil {
		return e
	}

	return nil
}
