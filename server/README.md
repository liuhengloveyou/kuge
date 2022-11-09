## 接口

### 查歌手

```
GET /api/v1/artist?id=123&la=xxx&cat=xxx&cat=xxx&ft=xxx&offset=123&limit=123

{
	"code":0,
	"errmsg": "错误信息",
	"data": [{
        "id": 10000,
        "name": "周杰伦"，
        "avatar_url": "http://fuzu.pro/8601a18b87d6277f991a966f23786c35e924fc26.jpeg",
        "intro": "简介信息base64编码",
        "la":"A",
        "cat":"A",
        "ft":"A"
    },
    {
        "id":10000,
        "name":"阿杜",
        "avatar_url":"http://music.fuzu.pro/ARTM1701192310131223.jpg",
        "intro":"u6fku7vjgII=",
        "la":"A",
        "cat":"A",
        "ft":"A"
    },
    ...]
}
```

参数说明：

| 参数   | 含义                       | 取值                   | 默认值 |
| ------ | -------------------------- | ---------------------- | ------ |
| id     | 歌手ID；用于查单个歌手详情 | >0                     |        |
| la     | 国籍                       | 华语、欧美、日韩 |      |
| cat    | 类型                       | 男、女、 组合      |       |
| ft     | 名字首字母                 | A ... Z                | A      |
| offset | 偏移数量，用于分页         | 正整数                 | 0     |
| limit  | 返回记录条数               | 1 <= X < 100           | 1    |



### 查专集

```
GET /api/v1/album?id=1&singer=xxx&offset=123&limit=123

{
	"code":0,
	"errmsg": "错误信息",
	"data": [{
        "id":10297,
        "name":"不爱我就拉倒",
        "singer":"周杰伦",
        "thumb_img":"http://music.fuzu.pro/60a54f378043da2e3160f2d2.jpg",
        "companies":"杰威尔音乐有限公司",
        "release_time":"2018-05-15T00:00:00Z",
        "intro":"nmoTmrYzmm7LvvIE="
    },
    {
        "id":10297,
        "name":"不爱我就拉倒",
        "singer":"周杰伦",
        "thumb_img":"http://music.fuzu.pro/60a54f378043da2e3160f2d2.jpg",
        "companies":"杰威尔音乐有限公司",
        "release_time":"2018-05-15T00:00:00Z",
        "intro":"nmoTmrYzmm7LvvIE="
    },
    ...]
}
```

参数说明：

| 参数   | 含义                             | 取值         | 默认值 |
| ------ | -------------------------------- | ------------ | ------ |
| id     | 专辑ID；用于查一个专辑的详情     | >0           |        |
| singer | 歌手名。没有的时候就是取专辑列表 | 歌手名       |        |
| offset | 偏移数量，用于分页               | 正整数       | 0      |
| limit  | 返回记录条数                     | 1 <= X < 100 | 1      |



### 查歌单

```
GET /api/v1/playlist?id=123&offset=123&limit=123

{
	"code":0,
	"errmsg": "错误信息",
	"data": [
		{
            "id":8131,
            "title":"Girl Power！女力觉醒，做回真我！",
            "thumb_url":"http://music.fuzu.pro/cfc-50be-4725-b213-4e400a98685f.jpg",
            "tags":" 励志 国语 英语 治愈 宣泄",
            "intro":"nV0IGRvIGl077yB",
            "clicks":" 44.6W",
            "songs":[...]
        },
        {
            "id":8130,
            "title":"忆莲盛放——天后林忆莲生日快乐",
            "thumb_url":"http://music.fuzu.pro/a580-d6a8081bdf2b.jpg",
            "tags":" 经典老歌 流行 KTV 治愈",
            "intro":"bojrIg77yB",
            "clicks":"54.1W",
            "songs":[...]
        }
	]
}
```

参数说明：

| 参数   | 含义               | 取值          | 默认值 |
| ------ | ------------------ | ------------- | ------ |
| id     | 专辑ID；用于查一个专辑的详情 | >0            |        |
| offset | 偏移数量，用于分页 | 正整数        | 0    |
| limit  | 返回记录条数       | 10 <= X < 100 | 1    |

### 歌单详情

```
GET /api/v1/playlist/info?id=123

{
	"code":0,
	"errmsg": "错误信息",
	"data": [{
            "id":8131,
            "title":"Girl Power！女力觉醒，做回真我！",
            "thumb_url":"http://music.fuzu.pro/cfc-50be-4725-b213-4e400a98685f.jpg",
            "tags":" 励志 国语 英语 治愈 宣泄",
            "intro":"nV0IGRvIGl077yB",
            "clicks":" 44.6W",
            "songs":[...]
        }]
}
```

参数说明：

| 参数 | 含义   | 取值   | 默认值 |
| ---- | ------ | ------ | ------ |
| id   | 歌单ID | 正整数 |        |


### 音乐详情

```
GET /api/v1/song/info?cid=123

{
    "code":0,
    "data":[
        {
            "id":1,
            "cid":"6005971CZLM",
            "name":"暧昧(电视剧《恶魔在身边》片尾曲)",
            "singer":"杨丞琳",
            "album":"异想天开 新歌+精选",
            "writer":"姜忆萱,颜玺轩",
            "music":"小冷",
            "tags":" 流行 爱情 国语 伤感 黄昏 电视剧 抒情流行",
            "words":"",
            "info":"[{"id": "6604", "pic": "//cdnmusic.migu.cn/picture/2019/0606/0257/AS1609221115548927.jpg", "name": "暧昧(电视剧《恶魔在身边》片尾曲)", "rate": ["BQ", "HQ", "SQ"], "type": "audio/mp3", "bqUrl": "http://tyst.migu.cn/public/product5th/product30/2019/03/21/2018%E5%B9%B411%E6%9C%8810%E6%97%A502%E7%82%B925%E5%88%86%E6%89%B9%E9%87%8F%E9%A1%B9%E7%9B%AESONY100%E9%A6%96-4/%E6%A0%87%E6%B8%85%E9%AB%98%E6%B8%85/MP3_128_16_Stero/6005971CZLM.mp3", "hqUrl": "http://tyst.migu.cn/public/product5th/product30/2019/03/21/2018%E5%B9%B411%E6%9C%8810%E6%97%A502%E7%82%B925%E5%88%86%E6%89%B9%E9%87%8F%E9%A1%B9%E7%9B%AESONY100%E9%A6%96-4/%E6%A0%87%E6%B8%85%E9%AB%98%E6%B8%85/MP3_320_16_Stero/6005971CZLM.mp3", "sqUrl": "http://tyst.migu.cn/public/product5th/product30/2019/03/21/2018%E5%B9%B411%E6%9C%8810%E6%97%A502%E7%82%B925%E5%88%86%E6%89%B9%E9%87%8F%E9%A1%B9%E7%9B%AESONY100%E9%A6%96-4/%E6%AD%8C%E6%9B%B2%E4%B8%8B%E8%BD%BD/flac/6005971CZLM.flac", "mvList": [], "songType": 0, "albumInfo": [{"albumId": "1108377190", "albumName": "再见 青春 极精选"}, {"albumId": "63042", "albumName": "异想天开 新歌+精选"}, {"albumId": "7848", "albumName": "暧昧"}], "singerInfo": [{"artistId": "1234", "artistName": "杨丞琳"}], "songLength": "00:04:11", "copyrightId": "6005971CZLM", "inDigitalAlbum": 0, "auditionsLength": 0}]"
        }
    ]
}
```



### 搜索

```json
GET /api/v1/s?t=A&k=aa&offset=1&limit=1

{
	"code":0,
	"errmsg": "错误信息",
	"data": [{
        "id": 10000,
        "name": "周杰伦"，
        "avatar_url": "http://fuzu.pro/8601a18b87d6277f991a966f23786c35e924fc26.jpeg",
        "intro": "简介信息base64编码",
        "la":"A",
        "cat":"A",
        "ft":"A"
    },
    {
        "id":10000,
        "name":"阿杜",
        "avatar_url":"http://music.fuzu.pro/ARTM1701192310131223.jpg",
        "intro":"u6fku7vjgII=",
        "la":"A",
        "cat":"A",
        "ft":"A"
    },
    ...]
}
```

参数说明：

| 参数   | 含义               | 取值                              | 默认值 |
| ------ | ------------------ | --------------------------------- | ------ |
| t      | 搜索类型           | A: 歌手；B:单曲；C: 专辑；D: 歌单 | 无     |
| k      | 搜索词             | 字符串                            | A      |
| offset | 偏移数量，用于分页 | 正整数                            | 0      |
| limit  | 返回记录条数       | 10 <= X < 100                     | 1      |




