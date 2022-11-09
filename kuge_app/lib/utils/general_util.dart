import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

final navGK = GlobalKey<NavigatorState>();
// ///接单轮循倒计时
// Timer receiveTimer;

class GeneralUtil {
  static String CNY = "¥";

  ///屏幕适配
  static screenAdaptation(
    BuildContext context, {
    double height = 667,
    double width = 375,
  }) =>
      ScreenUtil.init(context,
          designSize: Size(width, height));

  ///Container装饰器
  static BoxDecoration decoration({
    double radius = 0,
    Border? border,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    Color? color,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: border,
      boxShadow: boxShadow,
      gradient: gradient,
    );
  }

  ///状态栏高度
  static double statusBarHeight(BuildContext context) {
    return MediaQueryData.fromWindow(window).padding.top;
  }

  static double navigationBarHeight(BuildContext context) {
    return kToolbarHeight;
  }

  static double topBarHeight(BuildContext context) {
    return kToolbarHeight + MediaQueryData.fromWindow(window).padding.top;
  }

  ///键盘高度
  static double keyBordHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  ///时间戳转字符串
  static String formatTimeStampToString(timestamp, format) {
    assert(timestamp != null);

    int time = 0;

    if (timestamp is int) {
      time = timestamp;
    } else {
      time = int.parse(timestamp.toString());
    }

    format ??= 'yyyy-MM-dd HH:mm:ss';

    DateFormat dateFormat = DateFormat(format);

    var date = DateTime.fromMillisecondsSinceEpoch(time * 1000);

    return dateFormat.format(date);
  }

  ///跳转本地浏览器
  static void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  ///保留小数    digits是保留位数+1的值
  static String fixedDoubleNum(double num, int digits) {
    return num.toStringAsFixed(digits)
        .substring(0, num.toString().lastIndexOf('.') + digits);
  }

  ///字符串中间***省略
  static String hideString(String value, int limit) {
    if (value == null) return '';
    if (value.length > 12) {
      String header = value.substring(0, limit);
      String footer = value.substring(value.length - limit, value.length);
      return '$header****$footer';
    } else {
      return value;
    }
  }


  /// 计算天数、小时、分钟、秒
   static String caculateTime(nowTime, endTime) {
    var surplus = endTime.difference(nowTime);
    int day = (surplus.inSeconds ~/ 3600) ~/ 24;
    int hour = (surplus.inSeconds ~/ 3600) % 24;
    int minute = surplus.inSeconds % 3600 ~/ 60;
    // 如果用到秒的话计算
    int second = surplus.inSeconds % 60;

    var str = '';
    if (day > 0) {
      str = '$day天';
    }
    if (hour > 0 || (day > 0 && hour == 0)) {
      str = '$str$hour小时';
    }
    str = str + minute.toString() + '分钟' + second.toString() + "秒";
    return str;
  }

}
