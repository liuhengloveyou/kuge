import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/model/album.model.dart';


class AlbumItemView extends StatelessWidget {
  final AlbumModel album;
  final GestureTapCallback onTap;

  const AlbumItemView({
    Key? key,
    required this.onTap,
    required this.album,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // onLongPress: ,
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(3)),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: FadeInImage(
                    placeholder: const AssetImage("assets/images/place_block.png"),
                    image: CachedNetworkImageProvider(album.getCoverImg),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 4),
              alignment: Alignment.centerLeft,
              child: Text(
                album.getName,
                textAlign: TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              )),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                album.singerName!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey,
                ),
            ))
          ],
        ),
      ),
    );
  }
}