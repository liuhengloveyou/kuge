import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/provider/songListTag_provider.dart';
import 'package:provider/provider.dart';

class PlaylistFilter extends StatefulWidget {
  @override
  PlaylistFilterState createState() => PlaylistFilterState();
}

class PlaylistFilterState extends State<PlaylistFilter>
    with SingleTickerProviderStateMixin {
  List<String> lan = ["华语", "欧美", "日语", "韩语", "粤语"];
  List<String> style = [
    "流行",
    "摇滚",
    "民谣",
    "电子",
    "舞曲",
    "说唱",
    "轻音乐",
    "爵士",
    "乡村",
    "R&B",
    "古典",
    "民族",
    "英伦",
    "金属",
    "朋克",
    "蓝调",
    "雷鬼",
    "拉丁"
  ];
  List<String> scene = [
    "清晨",
    "夜晚",
    "学习",
    "工作",
    "午休",
    "下午茶",
    "地铁",
    "驾车",
    "运动",
    "旅行",
    "散步",
    "酒吧"
  ];
  List<String> emotion = [
    "怀旧",
    "清新",
    "浪漫",
    "伤感",
    "治愈",
    "放松",
    "孤独",
    "感动",
    "兴奋",
    "快乐",
    "安静",
    "思念"
  ];
  List<String> theme = [
    "综艺",
    "影视原声",
    "ACG",
    "儿童",
    "校园",
    "游戏",
    "70后",
    "80后",
    "90后",
    "网络歌曲",
    "KTV",
    "经典",
    "翻唱",
    "吉他",
    "钢琴",
    "器乐",
    "榜单",
    "00后"
  ];

  // _add(item){
  //   for (int i = 0; i < my.length; i ++) {
  //     if (item == my[i]) {
  //       return;
  //     }
  //   }

  //   setState(() {
  //   });

  //   SpUtil.putStringList(songlistFilterCacheKey, my);
  // }

  // _del(item){
  //   if (item == "推荐") {
  //     return;
  //   }

  //   setState(() {
  //     my.remove(item);
  //   });

  //   SpUtil.putStringList(songlistFilterCacheKey, my);
  // }

  Widget _title(text) {
    return Container(
        width: 1334,
        padding: const EdgeInsets.only(left: 10, top: 15),
        child: Text(text,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(32),
                fontWeight: FontWeight.bold)));
  }

  // @override
  // void initState() {
  //   super.initState();

  //   List<String> myTmp = SpUtil.getStringList(songlistFilterCacheKey);
  //   if (myTmp.length > 0) {
  //     if (myTmp[0] == "推荐") {
  //       my.removeAt(0);
  //       setState(() {
  //         my.addAll(myTmp);
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final tagsProvider = context.watch<SongListTagProvider>();

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('歌单标签'),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          _title("我的歌单广场"),
          GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10.0, //水平子Widget之间间距
            mainAxisSpacing: 15.0, //垂直子Widget之间间距
            padding: const EdgeInsets.all(10.0), //GridView内边距
            crossAxisCount: 5, //一行的Widget数量
            childAspectRatio: 2.5, //子Widget宽高比例
            children: tagsProvider
                .load()
                .map<Widget>((item) => TextButton(
                    child: Text(item), onPressed: () => tagsProvider.del(item)))
                .toList(),
          ),
          _title("语种"),
          GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10.0, //水平子Widget之间间距
            mainAxisSpacing: 10.0, //垂直子Widget之间间距
            padding: const EdgeInsets.all(10.0), //GridView内边距
            crossAxisCount: 5, //一行的Widget数量
            childAspectRatio: 2.5, //子Widget宽高比例
            children: lan
                .map<Widget>((item) => TextButton(
                    child: Text(item), onPressed: () => tagsProvider.add(item)))
                .toList(),
          ),
          _title("风格"),
          GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10.0, //水平子Widget之间间距
            mainAxisSpacing: 15.0, //垂直子Widget之间间距
            padding: const EdgeInsets.all(10.0), //GridView内边距
            crossAxisCount: 5, //一行的Widget数量
            childAspectRatio: 2.5, //子Widget宽高比例
            children: style
                .map<Widget>((item) => TextButton(
                    child: Text(item), onPressed: () => tagsProvider.add(item)))
                .toList(),
          ),
          _title("场景"),
          GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10.0, //水平子Widget之间间距
            mainAxisSpacing: 15.0, //垂直子Widget之间间距
            padding: const EdgeInsets.all(10.0), //GridView内边距
            crossAxisCount: 5, //一行的Widget数量
            childAspectRatio: 2.5, //子Widget宽高比例
            children: scene
                .map<Widget>((item) => TextButton(
                    child: Text(item), onPressed: () => tagsProvider.add(item)))
                .toList(),
          ),
          _title("情感"),
          GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10.0, //水平子Widget之间间距
            mainAxisSpacing: 15.0, //垂直子Widget之间间距
            padding: const EdgeInsets.all(10.0), //GridView内边距
            crossAxisCount: 5, //一行的Widget数量
            childAspectRatio: 2.5, //子Widget宽高比例
            children: emotion
                .map<Widget>((item) => TextButton(
                    child: Text(item), onPressed: () => tagsProvider.add(item)))
                .toList(),
          ),
          _title("主题"),
          GridView.count(
            shrinkWrap: true,
            crossAxisSpacing: 10.0, //水平子Widget之间间距
            mainAxisSpacing: 15.0, //垂直子Widget之间间距
            padding: const EdgeInsets.all(10.0), //GridView内边距
            crossAxisCount: 5, //一行的Widget数量
            childAspectRatio: 2.5, //子Widget宽高比例
            children: theme
                .map((item) => TextButton(
                    child: Text(item), onPressed: () => tagsProvider.add(item)))
                .toList(),
          ),
        ])));
  }
}
