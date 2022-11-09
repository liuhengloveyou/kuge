package api

import (
	"encoding/json"
	"io/ioutil"
	"net/http"
	"strconv"

	"kuge/common"
	"kuge/service"

	passport "github.com/liuhengloveyou/passport/face"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func AddFeedback(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	_, auth := passport.AuthFilter(r)
	if auth == false {
		logger.Error("AddFeedback auth ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "请登录")
		return
	}

	userInfo := passport.GetSessionUser(r)
	if userInfo.UID <= 0 {
		logger.Error("AddFeedback session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "请登录")
		return
	}

	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		logger.Error("AddFeedback ioutil.ReadAll(r.Body) ERR: ", err)
		gocommon.HttpErr(w, http.StatusBadRequest, 0, err.Error())
		return
	}
	logger.Infof("param: %v\n", string(body))

	var req map[string]interface{}
	if err = json.Unmarshal(body, &req); err != nil {
		logger.Error("AddFeedback json.Unmarshal ERR: ", string(body))
		gocommon.HttpErr(w, http.StatusBadRequest, -1, err.Error())
		return
	}

	uid := userInfo.UID
	feedbackType := req["feedbackType"].(string)
	feedbackContent := req["feedbackContent"].(string)

	if err = service.AddFeedback(uint(uid), userInfo.Cellphone.String, feedbackType, feedbackContent); err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("AddFeedback ERR: ", err.Error(), uid, req)
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, "")
	logger.Infof("AddFeedback OK: %v %v\n", uid, req)

	return
}

func ListFeedback(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	_, auth := passport.AuthFilter(r)
	if auth == false {
		logger.Error("AddFeedback auth ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "请登录")
		return
	}

	userInfo := passport.GetSessionUser(r)
	if userInfo.UID <= 0 {
		logger.Error("AddFeedback session ERR")
		gocommon.HttpErr(w, http.StatusForbidden, -1, "请登录")
		return
	}

	isAdmin := false
	for _, u := range common.ServConfig.AdminUserNames {
		if userInfo.Cellphone.String == u {
			isAdmin = true
			break
		}
	}
	if false == isAdmin {
		gocommon.HttpErr(w, http.StatusForbidden, -1, "你没有权限，请联系管理员")
		return
	}

	minid, _ := strconv.ParseUint(r.FormValue("minid"), 10, 64)
	limit, _ := strconv.ParseUint(r.FormValue("limit"), 10, 64)

	if minid < 0 {
		minid = 0
	}
	if limit > 1000 {
		limit = 1000
	} else if limit < 1 {
		limit = 1
	}

	logger.Debug("ListFeedback: ", minid, limit)

	rst, total, err := service.ListFeedback(uint(minid), uint(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("ListFeedback ERR: " + err.Error())
		return
	}

	gocommon.HttpResponseArray(w, http.StatusOK, 0, rst, total)
	logger.Infof("ListPlayList OK: %v %v\n", minid, limit)

	return
}
