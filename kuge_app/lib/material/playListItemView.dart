import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/model/playlist.model.dart';


class PlayListItemView extends StatelessWidget {
  final SonglistModel playlist;
  final GestureTapCallback onTap;
 
  const PlayListItemView({
    Key? key,
    required this.onTap,
    required this.playlist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GestureLongPressCallback? onLongPress;
   

    String copyWrite = "playlist[copywriter]";
    if (copyWrite.isNotEmpty) {
      onLongPress = () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text(
                  "playlist[copywriter]",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              );
            });
      };
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/playlist_playlist.9.png"),
                    image: CachedNetworkImageProvider(playlist.coverImg!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 4)),
            Text(
              playlist.getName!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}