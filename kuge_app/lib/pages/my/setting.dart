import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/pages/my/image_editor.dart';
import 'package:kuge_app/pages/my/setNamePage.dart';
import 'package:kuge_app/pages/my/setPwdPage.dart';
import 'package:kuge_app/pages/my/setPwdQuestionPage.dart';
import 'package:kuge_app/pages/my/setSexPage.dart';
import 'package:kuge_app/provider/account_provider.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:provider/provider.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 8, top: 16, bottom: 6),
          child: const Text("设置",
              style:
                  TextStyle(color: Color.fromARGB(255, 175, 175, 175))),
        ),
        InkWell(
            child: settingBlock(context, Icons.person, '头像'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SimpleImageEditor();
              }));
            }),
        InkWell(
            child: settingBlock(context, Icons.person, '名字'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SetNamePage();
              }));
            }),
        InkWell(
            child: settingBlock(context, Icons.person, '性别'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SetSexPage();
              }));
            }),
        InkWell(
            child: settingBlock(context, Icons.person, '修改密码'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SetPWDPage();
              }));
            }),
        InkWell(
            child: settingBlock(context, Icons.person, '设置密码保护问题'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SetPWDQuestionPage();
              }));
            }),
        const SizedBox(height: 30),
        InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.theme_setting_page),
            child: settingBlock(context, Icons.color_lens, '主题')),
        InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.feedbackPage),
            child: settingBlock(context, Icons.message, '意见&建议')),
        Container(
            margin: const EdgeInsets.only(top: 16, bottom: 100, left: 16, right: 16),
            child: MaterialButton(
                minWidth: double.infinity,
                color: Colors.red,
                textColor: Colors.white,
                child: const Text("退 出"),
                onPressed: () => context.read<UserAccount>().userLogout()))
      ],
    );
  }
}

Widget settingBlock(BuildContext context, icon, title) {
  return Container(
    child: Row(
      children: <Widget>[
        SizedBox(
          width: ScreenUtil().setWidth(152),
          height: ScreenUtil().setHeight(105),
          child: Icon(icon),
        ),
        Container(
          width: ScreenUtil().setWidth(598),
          height: ScreenUtil().setHeight(105),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1,
                color: Theme.of(context).primaryColorLight,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Text(title),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.grey[300],
                      )))
            ],
          ),
        )
      ],
    ),
  );
}
