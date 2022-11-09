package dao

import (
	"database/sql/driver"
	"encoding/json"
	"log"
	"os"
	"time"

	"go.uber.org/zap"
	gormMysql "gorm.io/driver/mysql"
	"gorm.io/gorm"
	gormLogger "gorm.io/gorm/logger"

	"kuge/common"

	"github.com/jmoiron/sqlx"
)

var (
	logger   *zap.SugaredLogger
	db       *gorm.DB
	mysqlCli *sqlx.DB

	maxSongID     uint
	maxPlaylistID uint
)

func InitMysql(urn string) (e error) {
	logger = common.Logger.Sugar()

	newLogger := gormLogger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags), // io writer
		gormLogger.Config{
			SlowThreshold: time.Second,     // 慢 SQL 阈值
			LogLevel:      gormLogger.Info, // Log level
			Colorful:      true,            // 禁用彩色打印
		},
	)

	if db, e = gorm.Open(gormMysql.Open(common.ServConfig.Mysql), &gorm.Config{Logger: newLogger}); e != nil {
		return e
	}

	// if e = db.AutoMigrate(&Playlist{}, &Singer{}, &Song{}, &Album{}, &Feedback{}); e != nil {
	// 	return e
	// }
	// if e = db.AutoMigrate(&Feedback{}); e != nil {
	// 	return e
	// }

	if mysqlCli, e = sqlx.Connect("mysql", urn); e != nil {
		return e
	}
	mysqlCli.SetMaxOpenConns(200)
	mysqlCli.SetMaxIdleConns(100)
	if e = mysqlCli.Ping(); e != nil {
		return e
	}

	song := &Song{}
	if err := song.GetMaxID(); err != nil {
		return err
	}
	maxSongID = song.ID

	playlist := &Playlist{}
	if err := playlist.GetMaxID(); err != nil {
		return err
	}
	maxPlaylistID = playlist.ID

	return nil
}

type Uint64Arr []uint64

func (m *Uint64Arr) Scan(src interface{}) error {
	b, _ := src.([]byte)
	return json.Unmarshal(b, m)
}
func (m Uint64Arr) Value() (driver.Value, error) {
	return json.Marshal(m)
}
