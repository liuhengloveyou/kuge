package api

import (
	"crypto/md5"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"path"
	"strconv"
	"time"

	"kuge/common"

	"github.com/julienschmidt/httprouter"
	gocommon "github.com/liuhengloveyou/go-common"
	passport "github.com/liuhengloveyou/passport/face"
	passportproto "github.com/liuhengloveyou/passport/protos"
)

func InitHttpApi(addr string) error {
	// 歌手
	router.GET("/artist", ListSinger)
	router.GET("/artist/detail", SingerDetail)
	// 专辑列表
	router.GET("/album", ListAlbums)
	router.GET("/album/detail", AlbumDetail)
	// 歌单列表
	router.GET("/playlist", ListPlayList)
	router.GET("/playlist1", ListPlayList1)
	// 歌单详情
	router.GET("/playlist/detail", PlaylistDetail)

	// 单曲详情
	router.GET("/song/info", GetSongInfo)
	router.GET("/song/infos", GetSongsInfo)

	// 搜索
	router.GET("/s", Search)

	// 推荐
	router.GET("/personalized/playlist", PersonalizedPlayList)
	router.GET("/personalized/song", PersonalizedSong)

	// 文件上传
	//router.POST("/upload", FileUpload)
	//router.GET("/files", FileDown)

	// 用户
	router.POST("/users/pwdquestion", SetPWDQuestion) // 设置密码保护
	router.POST("/users/resetpwd", ResetPWD)          // 重置密码
	//router.GET("/api/user/open", GetUserInfoOpen) // 查询用户公开信息
	router.POST("/users/feedback", AddFeedback) // 用户反馈
	router.GET("/users/feedback", ListFeedback) // 查询用户反馈列表
	router.POST("/users/update", UserUpdate)    // 更新用户信息
	router.GET("/users/info", FetchUserInfo)    // 拉取用户信息

	// 系统管理
	router.GET("/system/app/version", AppVersioin) // app版本升级

	// 用户中心
	options := &passportproto.OptionStruct{
		AvatarDir: common.ServConfig.AvatarDir,
		LogDir:    "./logs", // 日志目录
		LogLevel:  "debug",  // 日志级别
		MysqlURN:  common.ServConfig.Mysql,
	}
	http.Handle("/user", passport.InitAndRunHttpApi(options))
	// root
	http.Handle("/", &Server{})

	s := &http.Server{
		Addr:           addr,
		ReadTimeout:    10 * time.Minute,
		WriteTimeout:   10 * time.Minute,
		MaxHeaderBytes: 1 << 20,
	}

	fmt.Printf("HTTP %v\n", common.ServConfig.Addr)
	if err := s.ListenAndServe(); err != nil {
		return err
	}

	return nil
}

type Server struct{}

func (p *Server) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	defer logger.Sync()

	// // 跨域资源共享
	// w.Header().Set("Access-Control-Allow-Origin", "https://music.fuzu.pro")
	// w.Header().Set("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS")
	// w.Header().Set("Access-Control-Max-Age", "3600")
	// w.Header().Set("Access-Control-Allow-Credentials", "true")
	// w.Header().Add("Access-Control-Allow-Headers", "X-API, X-REQUEST-ID, X-API-TRANSACTION, X-API-TRANSACTION-TIMEOUT, X-RANGE, Origin, X-Requested-With, Content-Type, Accept")
	// w.Header().Add("P3P", `CP="CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"`)
	if r.Method == "OPTIONS" {
		w.WriteHeader(204)
		return
	}

	uri := r.RequestURI
	logger.Debugf("uri: %s\n", uri)

	router.ServeHTTP(w, r)

	return
}

func FileUpload(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	const MAX_LEN = 5 * 1024 * 1024 // 最大上传文件大小
	var (
		dir string
		fp  string
	)

	flen, _ := strconv.ParseInt(r.Header.Get("Content-Length"), 10, 64)
	if flen == 0 || flen > MAX_LEN {
		logger.Error("FileUpload Content-Length ERR: ", flen)
		gocommon.HttpErr(w, http.StatusBadRequest, -1, "文件大小错误")
		return

	}

	r.ParseMultipartForm(32 << 20)

	fileName := r.FormValue("name")
	fileType := r.FormValue("type")
	if fileType == "" {
		logger.Error("FileUpload fileType nil")
		gocommon.HttpErr(w, http.StatusBadRequest, -1, "文件类型错误")
		return
	}

	file, _, err := r.FormFile("file")
	if err != nil {
		logger.Error("FileUpload FormFile err: ", err)
		gocommon.HttpErr(w, http.StatusBadRequest, -1, "读上传文件错误")
		return
	}
	defer file.Close()

	fileBuff, err := ioutil.ReadAll(file)
	if err != nil {
		logger.Error("FileUpload ReadAll err: ", err)
		gocommon.HttpErr(w, http.StatusBadRequest, -1, "读上传文件错误")
		return
	}

	if fileName == "" {
		// 公开文件
		dir = fmt.Sprintf("%s/%d/%d", common.ServConfig.UploadDir, time.Now().Year(), time.Now().Month())
		if err := os.MkdirAll(dir, 0755); err != nil {
			gocommon.HttpErr(w, http.StatusOK, -1, "文件系统错误")
			logger.Error("FileUpload mkdir ERR: ", dir, err)
			return
		}
	} else {
		// 私人文件
		dir = fmt.Sprintf("%s/%d/%d", common.ServConfig.FileDir, time.Now().Year(), time.Now().Month())
		if err := os.MkdirAll(dir, 0755); err != nil {
			gocommon.HttpErr(w, http.StatusOK, -1, "文件系统错误")
			logger.Error("FileUpload mkdir ERR: ", dir, err)
			return
		}
	}

	fp = fmt.Sprintf("%s/%x.%s", dir, md5.Sum(fileBuff), fileType)
	logger.Info("FileUpload fn: ", fp)

	// 是否已经存在
	if true == gocommon.IsExists(fp) {
		logger.Error("FileUpload exists: ", fp)
		gocommon.HttpErr(w, http.StatusAccepted, -1, "文件已经存在")
		return
	}

	if err := ioutil.WriteFile(fp, fileBuff, 0755); err != nil {
		logger.Error("FileUpload err: ", err)
		gocommon.HttpErr(w, http.StatusInternalServerError, -1, "写文件失败")
		return
	}

	logger.Info("FileUpload ok: ", fp)

	gocommon.HttpErr(w, http.StatusOK, 0, fmt.Sprintf("%d/%d/%x.%s", time.Now().Year(), time.Now().Month(), md5.Sum(fileBuff), fileType))

	return
}

func FileDown(w http.ResponseWriter, r *http.Request, p httprouter.Params) {
	logger.Error("FileDown: ", r.RequestURI)

	r.ParseForm()
	f := r.FormValue("f")
	if f == "" {
		gocommon.HttpErr(w, http.StatusNotFound, -1, "")
		return
	}

	file, err := os.Open(path.Join(common.ServConfig.FileDir, f))
	if err != nil {
		logger.Error("FileDown ERR: ", err.Error())
		gocommon.HttpErr(w, http.StatusInternalServerError, -1, "")
		return
	}
	defer file.Close()

	w.Header().Add("Content-Type", "application/octet-stream")
	w.Header().Add("content-disposition", "attachment; filename=\""+url.QueryEscape(path.Base(f))+"\"")
	if _, err := io.Copy(w, file); err != nil {
		logger.Error("FileDown ERR: ", err.Error())
		gocommon.HttpErr(w, http.StatusInternalServerError, -1, "")
		return
	}

	logger.Info("FileDown OK: ", path.Join(common.ServConfig.FileDir, f))
	return
}
