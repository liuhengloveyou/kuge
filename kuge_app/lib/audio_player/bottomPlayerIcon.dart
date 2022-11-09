import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:provider/provider.dart';

class BottomNavigationIcon extends StatelessWidget {
  const BottomNavigationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    var player = context.watch<KugeAudioPlayer>();
    double currPositionVal = 0;
    MusicModel? curMusic = player.currentMusic();

    final currPosition = player.curPosition;
    final currDuration = player.curDuration;
    if (currPosition >0 && currDuration > 0 ) {
      currPositionVal = currPosition / currDuration;
    }
    if (currPositionVal > 1) {
      currPositionVal = 1;
    }

    return (curMusic != null)
        ? Stack(alignment: Alignment.center, children: [
            SizedBox(
                height: 48.0,
                width: 48.0,
                child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(180)),
                child: FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: const AssetImage("assets/images/play/disc.png"),
                  image: CachedNetworkImageProvider(curMusic.picUrl!)))),
            SizedBox(
                height: 48.0,
                width: 48.0,
                child: CircularProgressIndicator(
                    strokeWidth: 1,
                    value: currPositionVal, //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                    backgroundColor: Theme.of(context).primaryColor,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.red))),
          ])
        : Stack(alignment: Alignment.center, children: const [
            SizedBox(
                height: 48.0,
                width: 48.0,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(180)),
                    child: FadeInImage(
                        placeholder: AssetImage("assets/images/gg.png"),
                        image: AssetImage('assets/images/gg.png'),
                        fit: BoxFit.cover))),
            SizedBox(
                height: 48.0,
                width: 48.0,
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(180)),
                    child: FadeInImage(
                        placeholder: AssetImage("assets/images/play/disc.png"),
                        image: AssetImage('assets/images/play/disc.png'),
                        fit: BoxFit.cover))),
          ]);
  }
}
