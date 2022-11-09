package api

import (
	"net/http"
	"strconv"

	"kuge/service"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func ListAlbums(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id, _ := strconv.ParseInt(r.FormValue("id"), 10, 64)
	singer := r.FormValue("singer")
	offset, _ := strconv.ParseInt(r.FormValue("offset"), 10, 64)
	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)

	if offset < 0 {
		offset = 0
	}
	if limit > 100 {
		limit = 100
	} else if limit < 1 {
		limit = 1
	}

	logger.Debug("ListAlbums: ", id, singer, offset, limit)

	rst, err := service.GetAlbums(uint(id), singer, int(offset), int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("ListAlbums ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("ListAlbums OK: %v %v %v %v", singer, offset, limit)

	return
}

func AlbumDetail(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id, _ := strconv.ParseInt(r.FormValue("id"), 10, 64)
	logger.Debug("AlbumDetail: ", id)

	rst, err := service.GetAlbumDetail(uint(id))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("AlbumDetail ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("AlbumDetail OK: %v\n", id)

	return
}
