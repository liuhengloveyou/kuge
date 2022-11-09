import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/tone_option.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:provider/provider.dart';

class PlayingListDialog extends StatefulWidget {
  const PlayingListDialog({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return const PlayingListDialog();
        });
  }

  @override
  PlayingListDialogState createState() => PlayingListDialogState();
}

class PlayingListDialogState extends State<PlayingListDialog> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KugeAudioPlayer>(builder: (context, player, child) {
      return Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _Header(player: player),
              const Divider(height: 1, thickness: 1),
              Expanded(
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: player.queueLength,
                      itemBuilder: (context, index) {
                        return _MusicTile(
                            music: player.musicAt(index)!,
                            index: index,
                            playing: index == player.currentIndex);
                      }))
            ],
          ),
        ),
      );
    });
  }
}

class _Header extends StatelessWidget {
  final KugeAudioPlayer player;

  const _Header({required this.player}) : super();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: <Widget>[
          TextButton.icon(
              onPressed: () => player.setPlayMode(),
              icon: Icon(player.playMode.icon),
              label: Text('${player.playMode.name}(${player.queueLength}首)')),
          _ToneOption(player: player),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => player.cleanQueue(),
          ),
          // FlatButton.icon(
          //     onPressed: () async {
          //       final ids = []; // context.playList.queue.map((m) => int.parse(m.mediaId)).toList();
          //       if (ids.isEmpty) {
          //         return;
          //       }
          //       final succeed = await PlaylistSelectorDialog.addSongs(context, ids);
          //       if (succeed == null) {
          //         return;
          //       }
          //       if (succeed) {
          //         // showSimpleNotification(Text("添加到收藏成功"));
          //       } else {
          //         // showSimpleNotification(Text("添加到收藏失败"),
          //             // leading: Icon(Icons.error), background: Theme.of(context).errorColor);
          //       }
          //     },
          //     icon: Icon(Icons.add_box),
          //     label: Text("收藏全部")),
        ],
      ),
    );
  }
}

class _MusicTile extends StatelessWidget {
  final MusicModel music;
  final bool playing;
  final int index;

  const _MusicTile(
      {required this.music, required this.index, this.playing = false});

  @override
  Widget build(BuildContext context) {
    if (music.getTitle == "") {
      return Container();
    }

    Widget leading = Text((index + 1).toString(),
        style: const TextStyle(color: Colors.grey, fontSize: 16));
    if (playing) {
      leading = const Icon(
        Icons.volume_up,
        color: Colors.red,
      );
    }

    return InkWell(
        onTap: () => context.read<KugeAudioPlayer>().play(music),
        child: ListTile(
            leading: Container(
                padding: const EdgeInsets.only(top: 10), child: leading),
            title:
                Text(music.getTitle!, maxLines: 1, overflow: TextOverflow.clip),
            subtitle: Text("${music.subTitle}",
                maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.read<KugeAudioPlayer>().removeAt(index),
            )));
  }
}

class _ToneOption extends StatelessWidget {
  final KugeAudioPlayer player;

  const _ToneOption({required this.player}) : super();

  @override
  Widget build(BuildContext context) {
    var tone = player.tone;
    if (tone.index < ToneOption.standard.index ||
        tone.index > ToneOption.lossless.index) {
      tone = ToneOption.standard;
    }

    return Row(children: [
      PopupMenuButton(
        itemBuilder: _buildMenu,
        onSelected: (ToneOption val) => _handleMusicAction(context, val),
        child: Text(tone.name),
      ),
      const Icon(Icons.arrow_drop_down)
    ]);
  }

  List<PopupMenuItem<ToneOption>> _buildMenu(BuildContext context) {
    var items = [
      PopupMenuItem(
        value: ToneOption.standard,
        child: Text(ToneOption.standard.name),
      ),
      PopupMenuItem(
        value: ToneOption.high,
        child: Text(ToneOption.high.name),
      ),
      PopupMenuItem(
        value: ToneOption.lossless,
        child: Text(ToneOption.lossless.name),
      ),
    ];
    return items;
  }

  void _handleMusicAction(BuildContext context, ToneOption val) {
    player.setPlayTone(val);
  }
}
