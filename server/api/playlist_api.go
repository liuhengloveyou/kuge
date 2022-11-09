package api

import (
	"net/http"
	"strconv"

	"kuge/service"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func ListPlayList(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id := r.FormValue("id")
	offset, _ := strconv.ParseInt(r.FormValue("offset"), 10, 64)
	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)
	tag := r.FormValue("tag")

	if offset < 0 {
		offset = 0
	}
	if limit > 1000 {
		limit = 1000
	} else if limit < 1 {
		limit = 1
	}

	logger.Debug("ListPlayList: ", offset, limit)

	iid, _ := strconv.Atoi(id)
	rst, err := service.GetPlayList(uint(iid), tag, int(offset), int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("ListPlayList ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("ListPlayList OK: %v %v", offset, limit)

	return
}

func PlaylistDetail(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id := r.FormValue("id")
	logger.Debug("PlaylistDetail: ", id)
	if id == "" {
		gocommon.HttpErr(w, http.StatusOK, -1, "参数错误")
		return
	}

	iid, _ := strconv.Atoi(id)
	rst, err := service.GetPlayList(uint(iid), "", 0, 1)
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("PlaylistDetail ERR: " + err.Error())
		return
	}
	if len(rst) == 0 {
		gocommon.HttpErr(w, http.StatusOK, -1, "播放列表不存在")
		return

	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst[0])
	logger.Infof("PlaylistDetail OK: %v\n", id)

	return
}

func ListPlayList1(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id := r.FormValue("id")
	offset, _ := strconv.ParseInt(r.FormValue("offset"), 10, 64)
	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)

	if offset < 0 {
		offset = 0
	}
	if limit > 100 {
		limit = 100
	} else if limit < 1 {
		limit = 10
	}

	logger.Debug("ListPlayList1: ", offset, limit)

	rst, err := service.GetPlayList1(id, int(offset), int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("ListPlayList1 ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("ListPlayList1 OK: %v %v %v %v", offset, limit)

	return
}
