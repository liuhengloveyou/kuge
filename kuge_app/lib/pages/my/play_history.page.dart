import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/bottomPlayerBar.dart';
import 'package:kuge_app/service/play_history.service.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:provider/provider.dart';

class PlayHistoryPage extends StatefulWidget with WidgetsBindingObserver {
  @override
  _PlayHistoryPageState createState() => _PlayHistoryPageState();
}

class _PlayHistoryPageState extends State<PlayHistoryPage> {
  @override
   Widget build(BuildContext context) {
    List<MusicModel> songs = PlayHistory.songs;

    return Scaffold(
        appBar: AppBar(
          title: const Text('我的播放记录'),
          elevation: 0,
        ),
        body: ListView(
          children: songs.map((music) {
            return InkWell(
                onTap: () async {
                  await context.read<KugeAudioPlayer>().play(music);
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: FadeInImage(
                      placeholder: const AssetImage("assets/images/song.png"),
                      image: CachedNetworkImageProvider(music.picUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text("${music.name}"),
                  subtitle: Text("${music.subTitle}"),
                ));
          }).toList(),
        ),
        bottomNavigationBar: BottomControllerBar());
  }
}
