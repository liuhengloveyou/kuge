package common

import (
	"flag"
	"os"
	"time"

	rotatelogs "github.com/lestrrat-go/file-rotatelogs"
	gocommon "github.com/liuhengloveyou/go-common"
	passportcommon "github.com/liuhengloveyou/passport/common"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
)

var confile = flag.String("c", "app.conf.yaml", "配置文件")

type ApiConf struct {
	Name     string `yaml:"name"` // API名称、标题
	Operates map[string]struct {
		Auth bool `yaml:"auth"` // 是否需要用户登录
		Perm bool `yaml:"perm"` // 是否需要RBAC授权
	} `yaml:"operates"` // 支持的操作列表
}

type AppVersionModel struct {
	ID          string `yaml:"id" json:"id"`
	Content     string `yaml:"content" json:"content"`
	URL         string `yaml:"url" json:"url"`
	Version     string `yaml:"version" json:"version"`
	AppType     int    `yaml:"app_type" json:"appType"`
	IsUpdate    int    `yaml:"is_update" json:"isUpdate"`
	IsSensitive int    `yaml:"is_sensitive" json:"isSensitive"`
}

type ConfigStruct struct {
	PID       string `yaml:"pid"`
	Host      string `yaml:"host"`
	Addr      string `yaml:"addr"`
	Mysql     string `yaml:"mysql"`
	UploadDir string `yaml:"upload_dir"`
	FileDir   string `yaml:"file_dir"`
	LogDir    string `yaml:"log_dir"`
	LogLevel  string `yaml:"log_level"`

	AvatarDir string             `yaml:"avatar_dir"`
	HostName  string             `yaml:"host_name"`
	ImgServer string             `yaml:"img_server"`
	APIs      map[string]ApiConf `yaml:"apis"`

	AdminUserNames []string        `yaml:"admin_user_names"`
	AppVersion     AppVersionModel `yaml:"app_version"`
}

var (
	ServConfig ConfigStruct
	Logger     *zap.Logger
)

func init() {
	flag.Parse()

	if e := gocommon.LoadYamlConfig(*confile, &ServConfig); e != nil {
		panic(e)
	}

	InitLog(ServConfig.LogDir, ServConfig.LogLevel)
	passportcommon.Logger = Logger

	// 上传目录
	if ServConfig.UploadDir != "" {
		if err := os.MkdirAll(ServConfig.UploadDir, 0755); err != nil {
			panic(err)
		}
	}

}

func InitLog(logDir, logLevel string) error {
	writer, _ := rotatelogs.New(
		logDir+"log.%Y%m%d%H%M",
		rotatelogs.WithLinkName("log"),
		rotatelogs.WithMaxAge(7*24*time.Hour),
		rotatelogs.WithRotationTime(time.Hour),
	)

	level := zapcore.InfoLevel
	if e := level.UnmarshalText([]byte(logLevel)); e != nil {
		return e
	}

	core := zapcore.NewCore(
		zapcore.NewConsoleEncoder(zap.NewDevelopmentEncoderConfig()),
		zapcore.AddSync(writer),
		level)

	Logger = zap.New(core, zap.AddCaller())

	return nil
}
