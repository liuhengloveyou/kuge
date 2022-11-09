import 'dart:async';
import 'package:flutter/material.dart';

///dialog for select current login user'playlist
///
///pop with a int value which represent selected id
///or null indicate selected nothing
class PlaylistSelectorDialog extends StatelessWidget {
  ///add songs to user playlist
  ///return :
  /// if success -> true
  /// failed -> false
  /// cancel -> null
  static Future<bool?> addSongs(BuildContext context, List<int> ids) async {
    final playlistId = await showDialog(
        context: context,
        builder: (context) {
          return PlaylistSelectorDialog();
        });
    if (playlistId == null) {
      return null;
    }
    try {
      // return await neteaseRepository.playlistTracksEdit(PlaylistOperation.add, playlistId, ids);
    } catch (e) {
      return false;
    }
    return null;
  }

  Widget _buildTile(BuildContext context, Widget leading, Widget title,
      Widget subTitle, GestureTapCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 40,
              width: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: leading,
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 8)),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AnimatedDefaultTextStyle(
                    style: Theme.of(context).textTheme.bodyText2!,
                    duration: Duration.zero,
                    child: title),
                AnimatedDefaultTextStyle(
                    style: Theme.of(context).textTheme.caption!,
                    duration: Duration.zero,
                    child: subTitle),
              ]..removeWhere((v) => v == null),
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: <Widget>[
          const Padding(padding: EdgeInsets.only(left: 16)),
          Expanded(
              child:
                  Text("收藏到歌单", style: Theme.of(context).textTheme.headline6))
        ],
      ),
    );
  }

  Widget _buildDialog(BuildContext context, Widget content) {
    return SizedBox(
      height: 356,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(minWidth: 280.0, maxHeight: 356),
              child: Material(
                elevation: 24.0,
                type: MaterialType.card,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Column(
                  children: <Widget>[
                    _buildTitle(context),
                    Expanded(
                      child: content,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildDialog(
        context,
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text("当前未登陆"),
              const SizedBox(height: 16),
              TextButton(
                  onPressed: () {
                    // Navigator.of(context).pushNamed(pageLogin);
                  },
                  child: const Text("点击前往登陆页面")),
              const SizedBox(height: 32),
            ],
          ),
        ));
  }
}
