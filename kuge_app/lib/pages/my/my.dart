import 'package:flutter/material.dart';
import 'package:kuge_app/provider/liked_song.provider.dart';
import 'package:kuge_app/service/play_history.service.dart';
import 'package:kuge_app/service/song.service.dart';
import 'package:kuge_app/service/user.service.dart';
import 'package:provider/provider.dart';
import 'package:kuge_app/pages/my/setting.dart';
import 'package:kuge_app/provider/account_provider.dart';
import './center_block.dart';
import 'is_login_top.dart';

class MyPage extends StatefulWidget {
  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> {
  @override
  void initState() {
    super.initState();

    context.read<UserAccount>().fetchUserInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    UsersService.fetchUserInfo().then((resp) {
      if (resp.data["code"] == 0) {
        List songPlayHistory = resp.data['data']['songPlayHistory'];
        List songCollect = resp.data['data']['songCollect'];

        if (songPlayHistory.isNotEmpty) {
          SongService.Infos(songPlayHistory).then((songPlayHistoryValue) {
            final songPlayHistoryArr =  songPlayHistoryValue!.asValue!.value;
            if (songPlayHistoryArr.length > PlayHistory.songs.length) {
              PlayHistory.setCache(songPlayHistoryArr);
            }
          });
        }

        if (songCollect.isNotEmpty) {
          final likeSong = context.read<LikeSong>();

          SongService.Infos(songCollect).then((songCollectValue) {
            final songCollectArr =  songCollectValue!.asValue!.value;
            if (songCollectArr.length > likeSong.songs.length) {
              likeSong.setCache(songCollectArr);
            }
          });
        }
      }
    });
  }

  Widget _myListTile(Icon icon, String title, Widget rightTitle, GestureTapCallback onTap){
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListTile(
        leading: icon,
        title: Row(children: [
          Text(
            title,
            textAlign: TextAlign.left,
        ),
        if (rightTitle != null)
          Expanded(child: rightTitle),
        ]), 
        trailing: const Icon(Icons.keyboard_arrow_right),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserAccount userInfo = context.watch<UserAccount>();
    final likeSongLength = context.watch<LikeSong>().songs.length;
       
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "我的音乐",
          style: TextStyle(fontSize: 18),
        ),
        elevation: 0,
        centerTitle: true
      ),
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          // TopAreaPage(),
          IsLoginPage(),
          CenterBlockPage(),
          (userInfo.isLogin == true)? SettingPage() : Container(),
        ])));
  }
}
