package service

import (
	"fmt"
	"time"

	"kuge/dao"
)

func AddFeedback(userID uint, userName, feedbackType, feedbackContent string) error {
	err := (&dao.Feedback{
		UserID:          userID,
		UserName:        userName,
		FeedbackType:    feedbackType,
		FeedbackContent: feedbackContent,
		CreatedAt:       time.Now(),
		UpdatedAt:       time.Now(),
	}).Add()
	if err != nil {
		logger.Errorf("AddFeedback ERR:", err.Error())
		return fmt.Errorf("服务错误")
	}

	return nil
}

func ListFeedback(minID, limit uint) (rr dao.FeedbackArray, total int64, err error) {
	model := &dao.Feedback{}
	rr, err = model.List(minID, limit)
	if err != nil {
		logger.Errorf("ListFeedback ERR:", err.Error())
		return nil, 0, fmt.Errorf("服务错误")
	}

	total, err = model.Count()
	if err != nil {
		logger.Errorf("ListFeedback ERR:", err.Error())
		return nil, 0, fmt.Errorf("服务错误")
	}

	return
}
