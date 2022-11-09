import 'package:flutter/material.dart';
import 'package:kuge_app/model/artist.model.dart';
import 'package:kuge_app/pages/artists/artist_detail.page.dart';

void launchArtistDetailPage(BuildContext context, List<ArtistModel> artists) async {
  if (artists.isEmpty) {
    return;
  }
  if (artists.length == 1) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return ArtistDetailPage(artists[0].id);
    }));
  } else {
    final artist = await showDialog<ArtistModel>(
        context: context,
        builder: (context) {
          return ArtistSelectionDialog(artists: artists);
        });
    if (artist != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return ArtistDetailPage(artist.id);
      }));
    }
  }
}

///歌手选择弹窗
///返回 [Artist]
class ArtistSelectionDialog extends StatelessWidget {
  final List<ArtistModel> artists;

  const ArtistSelectionDialog({Key? key, required this.artists})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = artists.map<Widget>((artist) {
      final enabled = artist.id != 0;
      return ListTile(
        title: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(artist.name,
              style: Theme.of(context).textTheme.bodyText2!.merge(TextStyle(color: enabled ? null : Colors.grey))),
        ),
        enabled: enabled,
        onTap: () {
          Navigator.of(context).pop(artist);
        },
      );
    }).toList();

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 356),
        child: SimpleDialog(
          title: Container(
            constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width * 0.8),
            child: const Text("请选择要查看的歌手"),
          ),
          children: children,
        ),
      ),
    );
  }
}
