import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/material/img_title_block.dart';
import 'package:kuge_app/model/playlist.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/personal.service.dart';

class RecommendSongList extends StatefulWidget {
  final BuildContext buildContext;

  const RecommendSongList({super.key, required this.buildContext});

  @override
  _RecommendSongListState createState() => _RecommendSongListState();
}

class _RecommendSongListState extends State<RecommendSongList> {
  List<SonglistModel>? songListData;
  Future<List<SonglistModel>>? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();

    _futureBuilderFuture = _getSongList();

    setState(() {
      songListData = PersonalizedService.cachedPersonalizedPlaylist();
    });

    _getSongList();
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
                '推荐歌单',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                width: ScreenUtil().setWidth(154),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.songListPage),
                  child: Container(
                    width: ScreenUtil().setWidth(154),
                    height: ScreenUtil().setHeight(50),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 1, color: Colors.black12)),
                    child: Text(
                      '歌单广场',
                      style: TextStyle(fontSize: ScreenUtil().setSp(26)),
                    ),
                  ),
                ))
          ],
        ));
  }

  // 推荐歌单
  Widget _songList(context) {
    return FutureBuilder<List<SonglistModel>>(
        initialData: songListData,
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: 
            case ConnectionState.waiting:
              return const Text('努力加载中...');
            default:
              if (snapshot.hasError) {
                print("${snapshot.error}");
                return MaterialButton(child: const Text("重新加载"),onPressed: () =>  _getSongList());
              } else {
                return (songListData== null || songListData!.isEmpty)
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
              }
          }
          // }
        });
  }

  Future<List<SonglistModel>> _getSongList() async {
    print('------------------推荐歌单------------------------');
    final resp = await PersonalizedService.personalizedPlaylist();
    if (resp != null && false == resp.isError) {
      setState(() {
        songListData = resp.asValue!.value;
      });
    }

    return resp!.asFuture;
  }
}
