import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:provider/provider.dart';

class IsLoginPage extends StatefulWidget {
  @override
  IsLoginPageState createState() => IsLoginPageState();
}

class IsLoginPageState extends State<IsLoginPage> {
  UserAccount? _userInfo;

  Widget _logined(BuildContext context, UserAccount userInfo) {
    String userName = "末登录";
    String cellphone = "-";
    if (userInfo.isLogin) {
      userName = userInfo.nickName!;
      cellphone = userInfo.cellphone!;
    }

    var avatar = CircleAvatar(
      backgroundColor: Theme.of(context).primaryColorLight,
      backgroundImage: const AssetImage("assets/images/icon_renqi.png"), //CachedNetworkImageProvider(userInfo["avatarUrl"]),
    );
    if ("" != userInfo.avatarUrl) {
      avatar = CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        backgroundImage: CachedNetworkImageProvider("${Api.FILE_HOST}useravatar/${userInfo.avatarUrl}"),
      );
    }

    return Row(
      children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10),
        width: ScreenUtil().setWidth(155),
        height: ScreenUtil().setWidth(155),
        child: avatar,
      ),
      Expanded(
          child: Column(children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            userName,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(36)),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(left: 10, top: 8),
          child: Text(
            '手机号码: $cellphone',
            style: TextStyle(fontSize: ScreenUtil().setSp(26)),
          ),
        )
      ])),
    ]);
  }

  Widget _loginBtn(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 25),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            const Text('登陆酷歌音乐'),
            const Text('尽享海量高品质音乐'),
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 10),
              width: ScreenUtil().setWidth(720),
              height: ScreenUtil().setHeight(80),
              child: OutlinedButton(
                child: Text('立即登录', style: TextStyle(fontSize: ScreenUtil().setSp(32))),
                onPressed: () => Navigator.pushNamed(context, Routes.loginPage),
              ),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    _userInfo = context.watch<UserAccount>();

    return _userInfo!.isLogin
        ? _logined(context, _userInfo!)
        : _loginBtn(context);
  }
}
