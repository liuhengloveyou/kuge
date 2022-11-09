package api

import (
	"net/http"
	"strconv"

	"kuge/service"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func PersonalizedPlayList(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)
	if limit > 1000 {
		limit = 1000
	} else if limit <= 6 {
		limit = 6
	}

	logger.Debug("PersonalizedPlayList: ", limit)

	rst, err := service.GetPlayListRand(int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("PersonalizedPlayList ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("PersonalizedPlayList OK: %v %v", limit, len(rst))

	return
}

func PersonalizedSong(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)
	if limit > 1000 {
		limit = 1000
	} else if limit <= 6 {
		limit = 6
	}

	logger.Debug("PersonalizedSong: ", limit)

	rst, err := service.GetSongsRand(int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("PersonalizedSong ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("PersonalizedSong OK: %v %v", limit, len(rst))

	return
}
