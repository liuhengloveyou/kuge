import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/pages/search/search.page.dart';

class SearchArea extends StatelessWidget {
  ProxyAnimation transitionAnimation = ProxyAnimation(kAlwaysDismissedAnimation);


  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).primaryColor,
      width: ScreenUtil().setWidth(550),
      height: ScreenUtil().setHeight(90),
      alignment: Alignment.center,
      child: InkWell(
        onTap: (){
           Navigator.push(context, SearchPageRoute(transitionAnimation));
        },
        child: Container(
        // width: ScreenUtil().setWidth(520),
        // height: ScreenUtil().setHeight(70),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(ScreenUtil().setHeight(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              IconData(0xe618, fontFamily: 'IconFont'),
              size: 17,
              color: Color(0xffc5c5c6),
            ),
            Text(
              ' 酷歌音乐',
              style: TextStyle(fontSize: ScreenUtil().setSp(30), color: const Color(0xffc5c5c6)),
            )
          ],
        ),
      )),
    );
  }
}
