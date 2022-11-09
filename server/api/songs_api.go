package api

import (
	"encoding/json"
	"net/http"
	"strconv"

	"kuge/service"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func GetSongInfo(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id := r.FormValue("id")
	offset, _ := strconv.ParseInt(r.FormValue("offset"), 10, 64)
	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)

	if id == "" {
		gocommon.HttpErr(w, http.StatusOK, -1, "参数错误")
		logger.Error("GetSongInfo param ERR.")
		return
	}
	iid, _ := strconv.Atoi(id)

	if offset < 0 {
		offset = 0
	}
	if limit > 100 {
		limit = 100
	} else if limit < 1 {
		limit = 1
	}

	logger.Debug("GetSongInfo: ", id, offset, limit)

	rst, err := service.GetSongInfo(uint(iid), int(offset), int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("GetSongInfo ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("GetSongInfo OK: %v %v %v", id, offset, limit)

	return
}

func GetSongsInfo(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	ids := r.FormValue("ids")
	if ids == "" {
		gocommon.HttpErr(w, http.StatusOK, -1, "参数错误")
		logger.Error("GetSongInfo param ERR.")
		return
	}

	logger.Debug("GetSongsInfo: ", ids)

	var idArr []uint64
	if err := json.Unmarshal([]byte(ids), &idArr); err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, "参数错误")
		logger.Error("GetSongsInfo param ERR.")
		return
	}

	rst, err := service.GetSongByIDs(idArr)
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("GetSongsInfo ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	return
}
