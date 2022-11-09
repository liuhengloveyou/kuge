package api

import (
	"net/http"
	"strconv"

	"kuge/service"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func ListSinger(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id, _ := strconv.Atoi(r.FormValue("id"))
	la := r.FormValue("la")
	cat := r.FormValue("cat")
	ft := r.FormValue("ft")
	offset, _ := strconv.ParseInt(r.FormValue("offset"), 10, 64)
	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)

	if offset < 0 {
		offset = 0
	}
	if limit > 10000 {
		limit = 10000
	} else if limit < 1 {
		limit = 1
	}

	logger.Debug("ListArtist: ", id, la, cat, ft, offset, limit)

	rst, err := service.GetSingers(uint(id), la, cat, ft, int(offset), int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("ListArtist ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("ListArtist OK: %v %v %v %v", la, cat, ft, offset, limit)

	return
}

func SingerDetail(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	id, _ := strconv.Atoi(r.FormValue("id"))
	logger.Debug("SingerDetail: ", id)

	rst, err := service.SingerDetail(uint(id))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("SingerDetail ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("SingerDetail OK: %v", id)

	return
}
