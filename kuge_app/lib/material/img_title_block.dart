import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/utils/number.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget ImgTitleBlock(String coverImg, String title, int playCount) {
    return Column(children: <Widget>[
      Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: FadeInImage(
              width: 242.w,
              height: 242.w,
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(coverImg),
              placeholder: AssetImage('assets/images/song.png'),
            ),
          ),
          Positioned(
            right: 4,
            top: 2,
            child: Row(
              children: <Widget>[
                Icon(
                  const IconData(0xe62f, fontFamily: 'IconFont'),
                  color: Colors.white,
                  size: 15,
                ),
                Text(
                  '${getFormattedNumber(playCount)}',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
      Padding(padding: EdgeInsets.only(top: 4)),
      Text(title, textAlign: TextAlign.left, maxLines: 2, overflow: TextOverflow.ellipsis)
    ]);
  }