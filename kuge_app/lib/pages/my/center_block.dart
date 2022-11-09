import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/service/play_history.service.dart';
import 'package:kuge_app/provider/liked_song.provider.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:provider/provider.dart';

class CenterBlockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.playHistoryPage),
            child: _block(context, const IconData(0xe60c, fontFamily: 'IconFont'), '最近播放', '${PlayHistory.songs.length}')),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.myCollectionPage),
            child: _block(context, const IconData(0xe629, fontFamily: 'IconFont'), '我的收藏', '${context.watch<LikeSong>().songs.length}')),
          InkWell(
            onTap: () => Navigator.pushNamed(context, Routes.downLoadMangerPage),
            child: _block(context, const IconData(0xe601, fontFamily: 'IconFont'), '本地音乐', '')),
        ],
      ),
    );
  }

  Widget _block(BuildContext context, iconData, title, num, [border = false]) {
    return Container(
          // color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(152),
                height: ScreenUtil().setHeight(105),
                child: Icon(iconData),
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
                    Container(
                      alignment: Alignment.centerRight,
                      width: ScreenUtil().setWidth(430),
                      child: Text(num),
                    ),
                    Icon(
                      Icons.chevron_right,
                      color: Color(0xffe6e6e6),
                    )
                  ],
                ),
              )
            ],
          ),
        );
  }
}
