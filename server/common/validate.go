package common

import (
	"regexp"

	zhongwen "github.com/go-playground/locales/zh"
	ut "github.com/go-playground/universal-translator"
	validator "gopkg.in/go-playground/validator.v9"
	validatorzh "gopkg.in/go-playground/validator.v9/translations/zh"
)

var Validate *validator.Validate

func init() {
	Validate = validator.New()
	Validate.RegisterValidation("phone", CellPhoneValidate)

	zh := zhongwen.New()
	trans, ok := ut.New(zh, zh).GetTranslator("zh")
	if !ok {
		panic(ok)
	}

	err := Validate.RegisterTranslation("phone", trans,
		func(ut ut.Translator) (err error) {
			return ut.Add("phone", "手机号码格式错误", true)
		},
		func(ut ut.Translator, fe validator.FieldError) string {
			t, err := ut.T(fe.Tag(), fe.Field())
			if err != nil {
				return fe.(error).Error()
			}
			return t
		})
	if err != nil {
		panic(err)
	}

	if err := validatorzh.RegisterDefaultTranslations(Validate, trans); err != nil {
		panic(err)
	}
}

func CellPhoneValidate(fl validator.FieldLevel) bool {
	if fl.Field().Type().String() != "string" {
		return false
	}

	re, _ := regexp.Compile(`^1([378][0-9]|14[57]|5[^4])\d{8}$`)

	return re.MatchString(fl.Field().String())
}
