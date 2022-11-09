package service

import (
	"kuge/common"

	"go.uber.org/zap"
)

var logger *zap.SugaredLogger

func init() {
	logger = common.Logger.Sugar()
}

func ValidateStruct(model interface{}) error {
	return common.Validate.Struct(model)
}
