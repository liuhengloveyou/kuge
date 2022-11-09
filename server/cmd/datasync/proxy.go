package main

import (
	"crypto/md5"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"
)

const (
	openProxyServer  = "http://123.56.65.117:8000/proxy.php"
	closeProxyServer = "http://123.56.65.117:8000/close.php"
)

var proxyMutex sync.Mutex

type ProxyStruct struct {
	Status  string            `json:"status"`
	Message string            `json:"message"`
	Server  string            `json:"server"`
	Proxy   []int             `json:"proxy"`
	Remote  map[string]string `json:"remote"`
}

func GetProxyIP(proxyType, id, pwd string, ex, count int) (proxy ProxyStruct) {
	proxyMutex.Lock()
	defer proxyMutex.Unlock()

	iv := time.Now().UnixNano() / 1e6 //时间戳，必传，精确到毫秒（13位）【每个时间戳只能用1次】，用来防止重放攻击，时间戳【不能与真实时间差距过大】

	// auth
	authTmpStr := fmt.Sprintf("%s|%d|%d||%d|%s|%s", proxyType, ex, count, iv, id, pwd)
	auth := md5.Sum([]byte(authTmpStr))
	// fmt.Printf("auth: %s md5: %x\n", authTmpStr, auth)

	body := fmt.Sprintf("type=%v&time=%v&count=%d&id=%s&iv=%v&auth=%x", proxyType, ex, count, id, iv, auth)
	resp, err := http.Post(openProxyServer, "application/x-www-form-urlencoded", strings.NewReader(body))
	if err != nil {
		fmt.Println("proxy ERR: ", err)
		return
	}
	defer resp.Body.Close()

	respBody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("proxy ERR: ", err)
		return
	}

	// fmt.Println("respBody: ", string(respBody))
	if err := json.Unmarshal(respBody, &proxy); err != nil {
		fmt.Println("proxy ERR: ", err)
		return
	}

	return
}

func CloseProxy(proxyPort *ProxyStruct, id, pwd string) (rst *ProxyStruct, err error) {
	proxyMutex.Lock()
	defer proxyMutex.Unlock()

	iv := time.Now().UnixNano() / 1e6

	proxyServer := proxyPort.Server
	for i, port := range proxyPort.Proxy {
		if i == 0 {
			proxyServer = fmt.Sprintf("%s:%d", proxyServer, port)
		} else {
			proxyServer = fmt.Sprintf("%s,%d", proxyServer, port)
		}
	}

	// auth
	authTmpStr := fmt.Sprintf("%s|%v|%s|%s", proxyServer, iv, id, pwd)
	auth := md5.Sum([]byte(authTmpStr))

	body := fmt.Sprintf("port=%v&id=%s&iv=%v&auth=%x", url.PathEscape(proxyServer), id, iv, auth)
	resp, err := http.Post(closeProxyServer, "application/x-www-form-urlencoded", strings.NewReader(body))
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	respBody, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	respJSON := &ProxyStruct{}
	if err := json.Unmarshal(respBody, respJSON); err != nil {
		return nil, err
	}

	return respJSON, nil
}
