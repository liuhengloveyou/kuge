package api

import (
	"net/http"

	"kuge/common"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
)

func AppVersioin(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	gocommon.HttpErr(w, http.StatusOK, 0, common.ServConfig.AppVersion)

	return
}
