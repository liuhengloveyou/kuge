package api

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strings"

	"kuge/service"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
	passport "github.com/liuhengloveyou/passport/face"
)

func SetPWDQuestion(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	_, auth := passport.AuthFilter(r)
	if auth == false {
		logger.Error("SetPWDQuestion session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "末登录用户")
		return
	}

	userInfo := passport.GetSessionUser(r)
	if userInfo.UID <= 0 {
		logger.Error("SetPWDQuestion session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "末登录用户")
		return
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		logger.Error("SetPWDQuestion ioutil.ReadAll(r.Body) ERR: ", err)
		gocommon.HttpErr(w, http.StatusBadRequest, 0, err.Error())
		return
	}
	logger.Infof("param: %v\n", body)

	var req map[string]interface{}
	if err = json.Unmarshal(body, &req); err != nil {
		logger.Error("SetPWDQuestion json.Unmarshal ERR: ", string(body))
		gocommon.HttpErr(w, http.StatusBadRequest, -1, err.Error())
		return
	}

	logger.Infof("SetPWDQuestion body: %#v\n", req)

	uid := userInfo.UID
	cellphone := userInfo.Cellphone
	pwd := req["pwd"].(string)
	question := int(req["question"].(float64))
	answer := req["answer"].(string)

	if err = service.SetPwdQuestion(uid, cellphone.String, question, answer, pwd); err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("SetPWDQuestion ERR: ", err.Error(), uid, pwd)
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, "")
	logger.Infof("SetPWDQuestion OK: %v %v %v %v", uid, question, answer)

	return
}

func ResetPWD(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		logger.Error("ResetPWD ioutil.ReadAll(r.Body) ERR: ", err)
		gocommon.HttpErr(w, http.StatusBadRequest, 0, err.Error())
		return
	}

	var req map[string]interface{}
	if err = json.Unmarshal(body, &req); err != nil {
		logger.Error("ResetPWD json.Unmarshal ERR: ", string(body))
		gocommon.HttpErr(w, http.StatusBadRequest, -1, err.Error())
		return
	}

	logger.Infof("ResetPWD body: %#v\n", req)

	cellphone := req["cellphone"].(string)
	question := int(req["question"].(float64))
	answer := req["answer"].(string)
	if strings.TrimSpace(cellphone) == "" {
		gocommon.HttpErr(w, http.StatusBadRequest, 0, "请正确输入注册手机号")
		return
	}
	if strings.TrimSpace(answer) == "" {
		gocommon.HttpErr(w, http.StatusBadRequest, 0, "请正确输入答案")
		return
	}

	if err = service.ResetPwd(cellphone, question, answer); err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("ResetPWD ERR: ", err.Error(), cellphone)
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, "")
	logger.Infof("ResetPWD OK: %v %v %v\n", cellphone, question, answer)

	return
}
