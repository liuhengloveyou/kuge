package main

import (
	"fmt"
	"math/rand"
	"os"
	"os/signal"
	"syscall"
	"time"

	"kuge/api"
	"kuge/common"
	"kuge/dao"

	gocommon "github.com/liuhengloveyou/go-common"
)

var Sig string

func main() {
	gocommon.SingleInstane(common.ServConfig.PID) // 单例

	rand.Seed(time.Now().UTC().UnixNano())
	sigHandler()

	fmt.Println("init mysql:", common.ServConfig.Mysql)
	if err := dao.InitMysql(common.ServConfig.Mysql); err != nil {
		panic(err)
	}

	fmt.Println("init mysql ok")
	// datasync.SyncMigu1()
	// os.Exit(0)

	if err := api.InitHttpApi(common.ServConfig.Addr); err != nil {
		panic("HTTPAPI: " + err.Error())
	}
}

func sigHandler() {
	c := make(chan os.Signal, 1)
	signal.Notify(c, syscall.SIGTERM)

	go func() {
		s := <-c
		Sig = "service is suspend ..."
		fmt.Println("Got signal:", s)
	}()
}
