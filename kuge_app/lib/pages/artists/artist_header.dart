import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/material/flexible_app_bar.dart';
import 'package:kuge_app/material/tabs.dart';
import 'package:kuge_app/model/artist.model.dart';

class ArtistHeader extends StatelessWidget {
  final ArtistModel artist;

  const ArtistHeader({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      leading: const BackButton(color: Colors.white),
      expandedHeight: 330,
      flexibleSpace: _ArtistFlexHeader(artist: artist),
      elevation: 0,
      forceElevated: false,
      bottom: const RoundedTabBar(
        tabs: <Widget>[
          Tab(text: "热门单曲"),
          Tab(text: "专辑"),
          Tab(text: "艺人信息"),
        ],
      ),
      // actions: <Widget>[
      //   IconButton(icon: Icon(Icons.share, color: Theme.of(context).primaryIconTheme.color), onPressed: null)
      // ],
    );
  }
}

class _ArtistFlexHeader extends StatelessWidget {
  final ArtistModel artist;

  const _ArtistFlexHeader({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleDetailBar(
        background: FlexShadowBackground(
            child: Image(
                image: CachedNetworkImageProvider(artist.avatarURL),
                height: 300,
                fit: BoxFit.cover)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(),
                Text(artist.name,style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24)),
              ]),
        ),
        builder: (context, t) {
          return AppBar(
            title: Text(t > 0.5 ? artist.name : ''),
            backgroundColor: Colors.transparent,
            elevation: 0,
            titleSpacing: 0,
            // actions: <Widget>[
            //   IconButton(
            //       icon: Icon(Icons.share),
            //       tooltip: "分享",
            //       onPressed: () {
            //         // toast('分享');
            //       })
            // ],
          );
        },
    );
  }
}
