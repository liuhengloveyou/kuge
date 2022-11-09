import 'package:flutter/material.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/pages/playing/cover.dart';

class CenterSection extends StatefulWidget {
  final MusicModel music;

  const CenterSection({Key? key, required this.music}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CenterSectionState();
}

class CenterSectionState extends State<CenterSection> {
  static const bool _showLyric = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedCrossFade(
        crossFadeState: _showLyric ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        layoutBuilder: (Widget topChild, Key topChildKey, Widget bottomChild, Key bottomChildKey) {
          return Stack(
            // overflow: Overflow.visible,
            children: <Widget>[
              Center(
                key: bottomChildKey,
                child: bottomChild,
              ),
              Center(
                key: topChildKey,
                child: topChild,
              ),
            ],
          );
        },
        duration: const Duration(milliseconds: 300),
        firstChild: GestureDetector(
          onTap: () {
            // setState(() {
            //   _showLyric = !_showLyric;
            // });
          },
          child: AlbumCover(music: widget.music),
        ),
        secondChild: AlbumCover(music: widget.music),
        //   PlayingLyricView(
        //     music: widget.music,
        //     onTap: () {
        //       setState(() {
        //         _showLyric = !_showLyric;
        //       });
        //     },
        //   ),
      ),
    );
  }
}
