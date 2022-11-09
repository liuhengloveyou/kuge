import 'dart:ui' as ui;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/playingListDialog.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/provider/liked_song.provider.dart';
import 'package:kuge_app/service/downloaderManager.dart';
import 'package:provider/provider.dart';
import 'centerSection.dart';
import 'player_progress.dart';
import 'package:share/share.dart';

///歌曲播放页面
class PlayingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    KugeAudioPlayer player = context.watch<KugeAudioPlayer>();
    MusicModel? current =player.currentMusic();
    if (current == null) {
      current = MusicModel.origin();
      current.name = "酷歌音乐";
      current.singerName = "";
      current.picUrl = "";
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          _blurBackground(context, current.picUrl!),
          SafeArea(
            bottom: true,
            child: Material(
            color: Colors.transparent,
            child: Column(children: <Widget>[
              _playingTitle(context, current.name!, current.singerName!),
              CenterSection(music: current),
              _operationBar(context, current),
              DurationProgressBar(),
              _playerControllerBar(context, player.processingState),
              SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
            ]),
          )),
        ],
      ),
    );
  }

  Widget _playingTitle(BuildContext context, String songName, String singerName) {
    return SafeArea(
      top: true,
      bottom: false,
      child: AppBar(
        elevation: 0,
        primary: false,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context)),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(songName, style: const TextStyle(color: Colors.white, fontSize: 17)),
            (singerName != "")
                ? InkWell(
                    // onTap: () => Navigator.pushNamed(context, Routes.artistDetailPage, arguments: singerID),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            singerName,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Icon(Icons.chevron_right, size: 17, color: Colors.white),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
        backgroundColor: Colors.transparent,
        // actions: <Widget>[
        //   PopupMenuButton(
        //     itemBuilder: (context) {
        //       return [
        //         PopupMenuItem(
        //           child: Text("下载"),
        //         ),
        //         PopupMenuItem(
        //           child: Text("收藏"),
        //         ),
        //       ];
        //     },
        //     icon: Icon(Icons.more_vert,color: Theme.of(context).primaryIconTheme.color),
        //   )
        // ],
      ),
    );
  }

  Widget _blurBackground(BuildContext context, String picUrl) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        (picUrl != "")
            ? Image(
                image: CachedNetworkImageProvider(picUrl),
                fit: BoxFit.cover,
                gaplessPlayback: true,
              )
            : Image.asset(
                "assets/images/splash.png",
                fit: BoxFit.cover,
                gaplessPlayback: true,
              ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaY: 14, sigmaX: 24),
          child: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black54,
                Colors.black26,
                Colors.black45,
                Colors.black87,
              ],
            )),
          ),
        ),
      ],
    );
  }

  Widget _operationBar(BuildContext context, MusicModel music) {
    const iconColor = Colors.white;
    LikeSong likeSong = context.watch<LikeSong>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            icon: Icon(
                likeSong.isLiked(music)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: iconColor),
            onPressed: () => likeSong.clickLikeMusic(music)),
        IconButton(
            icon: const Icon(Icons.file_download, color: iconColor),
            onPressed: () async {
              final rst = await DownloaderManager.getInstance().download(
                  context,
                  music.downloadUrl!,
                  music.downloadName!,
                  music.toJson());
              if (rst == -3) {
                showToast("文件错误", position: StyledToastPosition.center);
              } else if (rst == -2) {
                showToast("下载任务已存在", position: StyledToastPosition.center);
              } else {
                showToast("下载任务添加成功", position: StyledToastPosition.center);
              }
            }),
        // IconButton(
        //     icon: Icon(
        //       Icons.comment,
        //       color: iconColor,
        //     ),
        //     onPressed: () {
        //       Toast.show("敬请期待", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        //       if (music == null) {
        //         return;
        //       }
        //       // Navigator.push(context, MaterialPageRoute(builder: (context) {
        //       //   return CommentPage(
        //       //     threadId: CommentThreadId(music.id, CommentType.song, payload: CommentThreadPayload.music(music)),
        //       //   );
        //       // }));
        //     }),
        IconButton(
            icon: const Icon(Icons.share, color: iconColor),
            onPressed: () async {
              Share.share("http://m.alokuge.com/home?id=${music.id}");
            }),
      ],
    );
  }

  Widget _playerControllerBar(BuildContext context, int stat) {
    var color = Colors.white;

    final iconPlayPause = <Widget>[
      IconButton(
          tooltip: "播放",
          iconSize: 40,
          icon: Icon(
            Icons.play_circle_outline,
            color: color,
          ),
          onPressed: () => context.read<KugeAudioPlayer>().play(null)),
      IconButton(
          tooltip: "暂停",
          iconSize: 40,
          icon: Icon(
            Icons.pause_circle_outline,
            color: color,
          ),
          onPressed: () => context.read<KugeAudioPlayer>().pause()),
      const SizedBox(
        height: 56,
        width: 56,
        child: Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(backgroundColor: Colors.red))),
      )][stat];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
              icon: Icon(context.watch<KugeAudioPlayer>().playMode.icon),
              color: color,
              onPressed: () {
                context.read<KugeAudioPlayer>().setPlayMode();
              }),
          IconButton(
              iconSize: 36,
              icon: Icon(
                Icons.skip_previous,
                color: color,
              ),
              onPressed: () {
                context.read<KugeAudioPlayer>().next(-1);
              }),
          iconPlayPause,
          IconButton(
              tooltip: "下一曲",
              iconSize: 36,
              icon: Icon(
                Icons.skip_next,
                color: color,
              ),
              onPressed: () {
                context.read<KugeAudioPlayer>().next(1);
              }),
          IconButton(
              tooltip: "当前播放列表",
              icon: Icon(
                Icons.menu,
                color: color,
              ),
              onPressed: () => {PlayingListDialog.show(context)}),
        ],
      ),
    );
  }
}
