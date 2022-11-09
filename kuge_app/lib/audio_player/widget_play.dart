// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:provider/provider.dart';

// /// 所有页面下面的播放条
// class PlayWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PlayerProvider>(builder: (context, model, child) {
//       Song curSong;
//       Widget child;

//       if (false == model.allSongs.isEmpty) {
//         curSong = model.curSong;
//       }
//       if (curSong == null || curSong.picUrl == "" || curSong.bqUrl == "") {
//         curSong = Song(0, name: "酷歌音乐", artists: "音乐陪伴生活", picUrl: "images/disc.png");
//       }

//       child = GestureDetector(
//         behavior: HitTestBehavior.translucent,
//         onTap: () {
//           NavigatorUtil.goPlaySongsPage(context);
//         },
//         child: Row(
//           children: <Widget>[
//             // RoundImgWidget(curSong.picUrl, 80),
//             RoundImgWidget("images/disc.png", 80),
//             HEmptyView(10),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   Text(
//                     curSong.name,
//                     style: mCommonTextStyle,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   Text(
//                     'curSong.artists,',
//                     style: common13TextStyle,
//                   ),
//                 ],
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 if (model.curState == null) {
//                   model.play();
//                 } else {
//                   model.togglePlay();
//                 }
//               },
//               child: Icon(
//                   model.curState == AudioPlayerState.PLAYING
//                       ? IconData(0xe039, fontFamily: 'MaterialIcons')
//                       : IconData(57398, fontFamily: 'MaterialIcons'),
//                   size: ScreenUtil().setWidth(70)),
//             ),
//             HEmptyView(15),
//             GestureDetector(
//               child: Icon(IconData(57439, fontFamily: 'MaterialIcons'), size: ScreenUtil().setWidth(80)),
//               onTap: () {},
//             ),
//           ],
//         ),
//       );

//       return Container(
//         width: Application.screenWidth,
//         height: ScreenUtil().setWidth(110),
//         decoration: BoxDecoration(
//           border: Border(top: BorderSide(color: Colors.grey[200])),
//           color: Colors.white,
//         ),
//         padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(10)),
//         alignment: Alignment.center,
//         child: child,
//       );
//     });
//   }
// }
