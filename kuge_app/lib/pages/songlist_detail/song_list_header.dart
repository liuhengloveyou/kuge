import 'package:kuge_app/model/music.model.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';

/// The header view of MusicList
class MusicListHeader extends StatelessWidget implements PreferredSizeWidget {
  final  List<MusicModel> musicList;
  final Widget? tail;

  const MusicListHeader(this.musicList, {super.key, this.tail});

  @override
  Widget build(BuildContext context) {
    int musicCount = musicList != null ? musicList.length : 0;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      child: Material(
        // color: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        child: InkWell(
          onTap: () => context.read<KugeAudioPlayer>().playMusicList(musicList),
          child: SizedBox.fromSize(
            size: preferredSize,
            child: Row(
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(left: 16)),
                Icon(Icons.play_circle_outline,color: Theme.of(context).iconTheme.color),
                const Padding(padding: EdgeInsets.only(left: 4)),
                Text("播放全部",style: Theme.of(context).textTheme.bodyText2),
                const Padding(padding: EdgeInsets.only(left: 2)),
                Text("(共$musicCount首)", style: Theme.of(context).textTheme.caption),
                const Spacer(),
                Container(margin: const EdgeInsets.all(0),
                  padding: const EdgeInsets.all(0),child: tail,
                ),
              ]..removeWhere((v) => v == null),
            ),
          ),
        ),
      ),
    );
  }

  // @override
  @override
  Size get preferredSize => const Size.fromHeight(50);
}