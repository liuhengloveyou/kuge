import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/route/routes.dart';

class TopNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(190),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _containPage(const IconData(0xe624, fontFamily: 'IconFont'), '每日推荐', 24.0, context),
          _containPage(const IconData(0xe64b, fontFamily: 'IconFont'), '歌单', 20.0, context),
          _containPage(const IconData(0xe608, fontFamily: 'IconFont'), '排行榜', 20.0, context),
          _containPage(const IconData(0xe605, fontFamily: 'IconFont'), '直播', 24.0, context)
        ],
      ),
    );
  }

  Widget _containPage(IconData iconData, String title, double IconSize, BuildContext context) {
    int _date = new DateTime.now().day;
    
    return Container(
        // decoration: BoxDecoration(border:Border(bottom: BorderSide(width: 1, color: Colors.black12))),
        width: ScreenUtil().setWidth(150),
        child: InkWell(
            onTap: () {
              switch(title) {
                case "歌单":
                  Navigator.pushNamed(context, Routes.songListPage);
                  break;
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 17, bottom: 8),
                      width: ScreenUtil().setWidth(90),
                      height: ScreenUtil().setWidth(90),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(45)),
                      child: Icon(iconData, size: IconSize, color: Colors.white),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(24),
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: ScreenUtil().setSp(76),
                  child: title == '每日推荐'
                      ? Text(
                          '$_date',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        )
                      : Text(''),
                )
              ],
            )));
  }
}
