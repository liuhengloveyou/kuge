import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/bottomPlayerBar.dart';
import 'package:kuge_app/material/bottom_padding.dart';
import 'package:kuge_app/model/album.model.dart';
import 'package:kuge_app/model/artist.model.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/pages/artists/artist_header.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/artist.service.dart';


///歌手详情页
class ArtistDetailPage extends StatelessWidget {
  final int artistId;
  ArtistModel? _data;

  ArtistDetailPage(this.artistId);

  Future<ArtistModel> _load() async {
    var resp = await ArtistService.artistDetail(artistId);
    _data = resp.asValue!.value;

    return resp.asFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ArtistModel>(
        future: _load(),
        builder: (context, artist) {
          return (_data == null)
              ? Scaffold(appBar: AppBar(title: const Text("歌手")))
              : Scaffold(
                  body: DefaultTabController(
                    length: 3,
                    child: NestedScrollView(
                        headerSliverBuilder: (context, innerBoxIsScrolled) {
                          return [
                            SliverOverlapAbsorber(
                              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              sliver: ArtistHeader(artist: _data!),
                            ),
                          ];
                        },
                        body: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.only(top: kToolbarHeight + kTextTabBarHeight),
                            child: TabBarView(
                              children: [
                                _PageHotSongs(musicList: _data!.hot_songs, artistId: artistId),
                                _PageAlbums(artistId: artistId, albums: _data!.albums),
                                _PageArtistIntroduction(artistId: artistId, artistName: _data!.name),
                              ],
                            ),
                          ),
                        )),
                  ),
                  bottomNavigationBar: BottomControllerBar(),
                );
        });
  }
}

///热门单曲
class _PageHotSongs extends StatefulWidget {
  const _PageHotSongs(
      {Key? key, required this.musicList, required this.artistId})
      : super(key: key);

  final List<MusicModel> musicList;
  final int artistId;

  @override
  _PageHotSongsState createState() => _PageHotSongsState();
}

class _PageHotSongsState extends State<_PageHotSongs>
    with AutomaticKeepAliveClientMixin {
  Widget _buildHeader(BuildContext context) {
    return InkWell(
      onTap: () {
        // PlaylistSelectorDialog.addSongs(context, widget.musicList.map((m) => m.id).toList());
      },
      child: SizedBox(
        height: 48,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 8),
                  const Icon(Icons.add_box),
                  const SizedBox(width: 8),
                  Expanded(child: Text("收藏热门${widget.musicList.length}单曲")),
                  TextButton(
                      child: const Text("多选"),
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                        //   // return PlaylistSelectionPage(list: widget.musicList);
                        // }));
                      })
                ],
              ),
            ),
            const Divider(height: 0)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.musicList.isEmpty) {
      return Container(
        child: const Center(child: Text("该歌手无热门曲目")),
      );
    }
    return ListView.builder(
        itemCount: widget.musicList.length+1,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          if (index >= widget.musicList.length){
            return bottomPadding(context);
          }
          return InkWell(
              onTap: () => context.read<KugeAudioPlayer>().play(widget.musicList[index]),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: FadeInImage(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(widget.musicList[index].picUrl!),
                    placeholder: const AssetImage('assets/images/song.png'),
                  ),
                ),
                title: Text(widget.musicList[index].name!, maxLines: 1),
                subtitle:Text("${widget.musicList[index].subTitle}", maxLines: 1),
                trailing: IconButton(
                    icon: const Icon(Icons.play_circle_outline, color: Colors.grey),
                    onPressed: () {
                      context.read<KugeAudioPlayer>().play(widget.musicList[index]);
                      Navigator.pushNamed(context, Routes.playerPage);
                    }),
              ));
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class _PageAlbums extends StatefulWidget {
  final int artistId;
  final List<AlbumModel> albums;

  const _PageAlbums({Key? key, required this.artistId, required this.albums}) : super(key: key);

  @override
  _PageAlbumsState createState() => _PageAlbumsState();
}

class _PageAlbumsState extends State<_PageAlbums> with AutomaticKeepAliveClientMixin {

  @override
  Widget build(BuildContext context) {
    if (widget.albums.isEmpty) {
      return Container(
        child: const Center(child: Text("无该歌手专辑信息")),
      );
    }
    return ListView.builder(
        itemCount: widget.albums.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
              onTap: () => Navigator.pushNamed(context, Routes.albumInfoPage, arguments: widget.albums[index].id),
              child: ListTile(
                contentPadding: EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: FadeInImage(
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(widget.albums[index].getCoverImg),
                    placeholder: const AssetImage('assets/images/song.png'),
                  ),
                ),
                title: Text(widget.albums[index].name!, maxLines: 1),
                subtitle: Text(widget.albums[index].getSubTitle, maxLines: 1)
              ));
        });
  }

  @override
  bool get wantKeepAlive => true;
}

// class _PageMVs extends StatefulWidget {
//   final int artistId;

//   final int mvCount;

//   const _PageMVs({Key key, @required this.artistId, @required this.mvCount}) : super(key: key);

//   @override
//   _PageMVsState createState() {
//     return new _PageMVsState();
//   }
// }

// class _PageMVsState extends State<_PageMVs> with AutomaticKeepAliveClientMixin {
// Future<Result<List<Map>>> _loadMv(int offset) async {
// final result = await neteaseRepository.artistMvs(widget.artistId, offset: offset);
// return ValueResult((result.asValue.value["mvs"] as List).cast());
// }

//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return AutoLoadMoreList<Map>(
//         loadMore: _loadMv,
//         builder: (context, mv) {
//           return InkWell(
//             onTap: () {
//               Navigator.pushNamed(context, '/mv', arguments: mv['id']);
//             },
//             child: Container(
//               height: 72,
//               child: Row(
//                 children: <Widget>[
//                   SizedBox(width: 8),
//                   Container(
//                     height: 72,
//                     width: 72 * 1.6,
//                     padding: EdgeInsets.all(4),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(3),
//                       child: Image(
//                         image: CachedNetworkImageProvider(mv["imgurl16v9"]),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Expanded(
//                       child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       Spacer(),
//                       Text(mv["name"], maxLines: 1, overflow: TextOverflow.ellipsis),
//                       SizedBox(height: 4),
//                       Text(mv["publishTime"], style: Theme.of(context).textTheme.caption),
//                       Spacer(),
//                       Divider(height: 0)
//                     ],
//                   ))
//                 ],
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   bool get wantKeepAlive => true;
// }

class _PageArtistIntroduction extends StatefulWidget {
  final int artistId;
  final String artistName;

  const _PageArtistIntroduction(
      {Key? key, required this.artistId, required this.artistName})
      : super(key: key);

  @override
  _PageArtistIntroductionState createState() => _PageArtistIntroductionState();
}

class _PageArtistIntroductionState extends State<_PageArtistIntroduction> with AutomaticKeepAliveClientMixin {
  String intro = "";

  List<Widget> _buildIntroduction(BuildContext context) {
    Widget title = Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Text(("${widget.artistName}简介"), style: const TextStyle( fontSize: 15, fontWeight: FontWeight.bold, shadows: [])));

    Widget briefDesc = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        widget.artistName,
        style: TextStyle(color: Theme.of(context).textTheme.caption!.color),
      ),
    );
    // Widget button = InkWell(
    //   onTap: () {
    //     // notImplemented(context);
    //   },
    //   child: Container(
    //     height: 36,
    //     child: Center(
    //       child: Text("完整歌手介绍"),
    //     ),
    //   ),
    // );
    return [title, briefDesc];
  }

  List<Widget> _buildTopic(BuildContext context, Map result) {
    final List<Map> data = (result["topicData"] as List).cast();
    if (data.isEmpty) {
      return [];
    }
    Widget title = const Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Text(("相关专题文章"),
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, shadows: [])));
    List<Widget> list = data.map<Widget>((topic) {
      String subtitle =
          "by ${topic["creator"]["nickname"]} 阅读 ${topic["readCount"]}";
      return InkWell(
        onTap: () {
          debugPrint("on tap : ${topic["url"]}");
        },
        child: SizedBox(
          height: 72,
          child: Row(
            children: <Widget>[
              const SizedBox(width: 8),
              Container(
                height: 72,
                width: 72 * 1.6,
                padding: const EdgeInsets.all(4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Image(
                    image: CachedNetworkImageProvider(topic["rectanglePicUrl"]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Spacer(),
                  Text(topic["mainTitle"],
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.caption),
                  const Spacer(),
                  const Divider(height: 0)
                ],
              ))
            ],
          ),
        ),
      );
    }).toList();
    list.insert(0, title);

    if (result["count"] > data.length) {
      list.add(InkWell(
        onTap: () {
          // notImplemented(context);
        },
        child: const SizedBox(
          height: 56,
          child: Center(
            child: Text("全部专栏文章"),
          ),
        ),
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
        final widgets = <Widget>[];
        widgets.addAll(_buildIntroduction(context));
        // widgets.addAll(_buildTopic(context, null));
        return ListView(
          children: widgets,
        );
  }

  @override
  bool get wantKeepAlive => true;
}
