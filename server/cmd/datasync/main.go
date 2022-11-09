package main

import (
	"encoding/json"
	"fmt"
	"strings"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var (
	GormCli *gorm.DB
)

func main() {
	var err error

	dsn := "root:lhisroot@tcp(192.168.0.100:3306)/kuge?charset=utf8mb4&parseTime=true"
	if GormCli, err = gorm.Open(mysql.Open(dsn), &gorm.Config{}); err != nil {
		panic(err)
	}
	fmt.Println("mysql ok")

	playlist(GormCli)
	return

	var maxID uint32 = 536414
	for {
		var results []map[string]interface{}
		if err = GormCli.Table("songs").Where("id > ?", maxID).Limit(100).Find(&results).Error; err != nil {
			panic(err)
		}
		if len(results) == 0 {
			fmt.Println("END")
			break
		}

		for i := 0; i < len(results); i++ {
			o := results[i]
			maxID = o["id"].(uint32)

			if nil == o["pic_name"] {
				fmt.Println("@>>>", o["id"], o["pic_name"])
				continue
			}

			if strings.Index(o["pic_name"].(string), "/") > 0 {
				fmt.Println("@>>>", o["id"], o["pic_name"])
				continue
			}

			picNameStr := o["pic_name"].(string)

			picNameLen := len(picNameStr)
			if picNameLen > 6 {
				picNameStr = fmt.Sprintf("%s/%s", picNameStr[picNameLen-6:picNameLen-4], picNameStr)

				err = GormCli.Table("songs").Where("id = ?", o["id"]).Update("pic_name", picNameStr).Error
				if err != nil {
					panic(err)
				}
				fmt.Println(">>>", o["id"], picNameStr)
			}
		}
	}
}

func playlist(db *gorm.DB) {
	var maxID uint64 = 0
	for {
		var results []map[string]interface{}
		if err := db.Table("playlists").Where("id > ?", maxID).Limit(100).Find(&results).Error; err != nil {
			panic(err)
		}
		if len(results) == 0 {
			fmt.Println("END")
			break
		}

		for i := 0; i < len(results); i++ {
			o := results[i]
			maxID = o["id"].(uint64)

			trackIds := o["track_ids"].(string)

			var trackIdsJson []map[string]interface{}
			json.Unmarshal([]byte(trackIds), &trackIdsJson)

			err := GormCli.Table("playlists").Where("id = ?", o["id"]).Update("track_count", len(trackIdsJson)).Error
			if err != nil {
				panic(err)
			}
			fmt.Println(">>>", o["id"], len(trackIdsJson))

		}
	}

}
