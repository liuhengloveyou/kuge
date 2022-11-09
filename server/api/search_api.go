package api

import (
	"net/http"
	"strconv"

	"kuge/service"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func Search(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	r.ParseForm()

	t := r.FormValue("t")
	k := r.FormValue("k")
	offset, _ := strconv.ParseInt(r.FormValue("offset"), 10, 64)
	limit, _ := strconv.ParseInt(r.FormValue("limit"), 10, 64)

	if t == "" || k == "" {
		gocommon.HttpErr(w, http.StatusOK, -1, "参数错误")
		logger.Error("Search param ERR: ", t, k)
		return
	}
	if offset <= 0 {
		offset = 0
	}
	if limit > 100 {
		limit = 100
	} else if limit < 1 {
		limit = 1
	}

	logger.Debug("Search: ", t, k, offset, limit)

	rst, err := service.Search(t, k, int(offset), int(limit))
	if err != nil {
		gocommon.HttpErr(w, http.StatusOK, -1, err.Error())
		logger.Error("Search ERR: " + err.Error())
		return
	}

	gocommon.HttpErr(w, http.StatusOK, 0, rst)
	logger.Infof("Search OK: %v %v %v %v", t, k, offset, limit)

	return
}
