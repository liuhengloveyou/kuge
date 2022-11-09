import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/material/img_title_block.dart';
import 'package:kuge_app/model/playlist.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/personal.service.dart';

class HotSongList extends StatefulWidget {
  final BuildContext buildContext;

  const HotSongList({super.key, required this.buildContext});

  @override
  _HotSongListState createState() => _HotSongListState();
}

class _HotSongListState extends State<HotSongList> {
  List<SonglistModel>? songListData;
  Future<List<SonglistModel>>? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();

    _futureBuilderFuture = _getSongList();

    setState(() {
      songListData = PersonalizedService.cachedPersonalizedPlaylist();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white,
      child: Column(
        children: <Widget>[
          _title(),
          _songList(context),
        ],
      ),
    );
  }

// 推荐歌单标题
  Widget _title() {
    return Container(
        margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
        height: ScreenUtil().setHeight(120),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().setWidth(555),
              child: Text(
                '大家都在听',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }

  // 推荐歌单
  Widget _songList(context) {
    return FutureBuilder<List<SonglistModel>>(
        initialData: songListData,
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          return (songListData == null || songListData!.isEmpty)
              ? const Text('努力加载中...')
              : Wrap(
                  spacing: 4,
                  children: songListData!.map((oneSongList) {
                    return InkWell(
                      onTap: () => Navigator.pushNamed(context, Routes.songListDetailPage, arguments: oneSongList.id),
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10.h),
                        width: ScreenUtil().setWidth(232),
                        child: ImgTitleBlock(oneSongList.coverImg!, oneSongList.name!, oneSongList.playCount),
                      ),
                    );
                  }).toList());
          // }
        });
  }

  Future<List<SonglistModel>> _getSongList() async {
    var resp = await PersonalizedService.personalizedPlaylist();
    if (resp!.isError) {}

    setState(() {
      songListData = resp.asValue!.value;
    });

    return resp.asFuture;
  }
}
