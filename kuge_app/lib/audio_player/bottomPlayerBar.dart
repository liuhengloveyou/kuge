import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/playingListDialog.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:provider/provider.dart';

import 'bottomPlayerIcon.dart';

///底部当前音乐播放控制栏
class BottomControllerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<KugeAudioPlayer>(builder: (context, player, child) {
      String title = "酷歌音乐";
      String subTitle = "让音乐陪伴生活";
      MusicModel? music = player.currentMusic();
      title = music!.getTitle!;
      subTitle = music.subTitle!;

      return InkWell(
        onTap: () => Navigator.pushNamed(context, Routes.playerPage),
        child: Card(
          margin: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0))),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                boxShadow: [
                  //阴影效果
                  BoxShadow(
                    offset: const Offset(0, 0), //阴影在X轴和Y轴上的偏移
                    color: Theme.of(context).primaryColorLight, //阴影颜色
                    blurRadius: 1, //阴影程度
                    spreadRadius: 0, //阴影扩散的程度 取值可以正数,也可以是负数
                  ),
                ]),
            child: Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      left: 8, right: 10, top: 0, bottom: 0),
                  child: BottomNavigationIcon(),
                ),
                Expanded(
                  child: DefaultTextStyle(
                    style: const TextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(title,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                        Text(subTitle,
                            style: Theme.of(context).textTheme.bodyText2),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
                _PauseButton(context, player.processingState),
                IconButton(
                    tooltip: "当前播放列表",
                    icon: const Icon(Icons.menu),
                    onPressed: () => PlayingListDialog.show(context)),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _PauseButton(BuildContext context, int stat) {
    return <Widget>[
      IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () {
            context.read<KugeAudioPlayer>().play(null);
          }),
      IconButton(
          icon: const Icon(Icons.pause),
          onPressed: () {
            context.read<KugeAudioPlayer>().pause();
          }),
      Container(
        height: 24,
        width: 24,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(4),
        child: const CircularProgressIndicator(backgroundColor: Colors.red),
      )
    ][stat];
  }
}

// class _SubTitleOrLyric extends StatelessWidget {
//   final String subtitle;

//   const _SubTitleOrLyric(this.subtitle, {required Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // final playingLyric = ""; //context.read<PlayingLyric>();
//     // if ("" == "playingLyric.hasLyric") {
//     //   return Text(subtitle);
//     // }
//     // final line = playingLyric.lyric.getLineByTimeStamp(context.playbackState.positionWithOffset, 0)?.line;
//     // if (line == null || line.isEmpty) {
//     //   return Text(subtitle);
//     // }
//     // return Text(line);
//   }
// }