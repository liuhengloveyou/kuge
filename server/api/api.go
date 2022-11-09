package api

import (
	"kuge/common"

	"github.com/julienschmidt/httprouter"
	"go.uber.org/zap"
)

var (
	logger *zap.SugaredLogger
	router *httprouter.Router
)

func init() {
	router = httprouter.New()
	logger = common.Logger.Sugar()
}
