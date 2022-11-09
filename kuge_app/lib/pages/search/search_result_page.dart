import 'package:flutter/material.dart';

import 'searchresult_artists.dart';
import 'searchresult_playlists.dart';
import 'searchresult_songs.dart';

///搜索结果分类
const List<String> SECTIONS = ["单曲", "歌单", "歌手"];

class SearchResultPage extends StatefulWidget {
  SearchResultPage({Key? key, required this.query})
      : assert(query.isNotEmpty),
        super(key: key);

  final String query;

  @override
  _SearchResultPageState createState() =>  _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  String query = "";

  @override
  void initState() {
    super.initState();
    query = widget.query;
  }

  @override
  void didUpdateWidget(SearchResultPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      setState(() {
        query = widget.query;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        SongsResultSection(query: query, key: Key("SongTab_$query")),
        PlaylistResultSection(query: query, key: Key("PlaylistTab_$query")),
        ArtistsResultSection(query: query, key: Key("Artists_$query")),
        // AlbumsResultSection(query: query, key: Key("AlbumTab_$query")),        
      ],
    );
  }
}
