import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kuge_app/material/bottom_padding.dart';
import 'package:kuge_app/material/chart_button.dart';
import 'package:kuge_app/pages/find/recommend_song.dart';
import 'hot_songlist.dart';
import 'searcharea.dart';
import 'top_navigation.dart';
import 'recommend_songlist.dart';

class FindPage extends StatefulWidget {
  @override
  _FindPageState createState() => _FindPageState();
}

class _FindPageState extends State<FindPage> with AutomaticKeepAliveClientMixin {
  // 保持状态
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        leading: InkWell(
          onTap: () {},
          child: Icon(
            const IconData(0xe64f, fontFamily: 'IconFont'),
            size: 25,
            color: Theme.of(context).appBarTheme.backgroundColor
          ),
        ),
        title: SearchArea(),
        elevation: 0,
        centerTitle: true,
        actions: <Widget>[ChartButton()], systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: ListView(
        children: <Widget>[
          // SwiperPage(),
          TopNavigation(),
          RecommendSongList(buildContext: context),
          HotSongList(buildContext: context),
          RecommendSong(buildContext: context),
          // NewDishPage(),
          bottomPadding(context)
        ],
      )
    );
  }
}
