package api

import (
	"encoding/json"
	"io/ioutil"
	"net/http"

	"kuge/service"

	passport "github.com/liuhengloveyou/passport/face"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func FetchUserInfo(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	_, auth := passport.AuthFilter(r)
	if auth == false {
		logger.Error("FetchUserInfo session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "末登录用户")
		return
	}

	userInfo := passport.GetSessionUser(r)
	if userInfo.UID <= 0 {
		logger.Error("FetchUserInfo session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "末登录用户")
		return
	}

	uid := userInfo.UID
	user, err := service.LoadUserInfo(uid)
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("FetchUserInfo ERR: ", err.Error(), uid)
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, user)
	return
}

func UserUpdate(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	_, auth := passport.AuthFilter(r)
	if auth == false {
		logger.Error("UserUpdate session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "末登录用户")
		return
	}

	userInfo := passport.GetSessionUser(r)
	if userInfo.UID <= 0 {
		logger.Error("UserUpdate session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "末登录用户")
		return
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		logger.Error("UserUpdate ioutil.ReadAll(r.Body) ERR: ", err)
		gocommon.HttpErr(w, http.StatusBadRequest, 0, err.Error())
		return
	}
	logger.Infof("param: %v\n", body)

	var req map[string]interface{}
	if err = json.Unmarshal(body, &req); err != nil {
		logger.Error("UserUpdate json.Unmarshal ERR: ", string(body))
		gocommon.HttpErr(w, http.StatusBadRequest, -1, err.Error())
		return
	}

	logger.Infof("UserUpdate body: %#v\n", req)

	uid := userInfo.UID

	if err = service.UserUpdate(uid, req); err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("UserUpdate ERR: ", err.Error(), uid)
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, "")
	logger.Infof("UserUpdate OK: %v %v", uid, req)

	return
}
