import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/bottomPlayerBar.dart';
import 'package:kuge_app/material/bottom_padding.dart';
import 'package:kuge_app/material/flexible_app_bar.dart';
import 'package:kuge_app/model/album.model.dart';
import 'package:kuge_app/pages/songlist_detail/song_list_header.dart';
import 'package:kuge_app/pages/songlist_detail/songlistdetail.page.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/album.service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlbumInfoPage extends StatefulWidget {
  final int albumID;

  const AlbumInfoPage(this.albumID): assert(albumID > 0);

  @override
  _AlbumInfoPageState createState() => _AlbumInfoPageState();
}

class _AlbumInfoPageState extends State<AlbumInfoPage> {
  AlbumModel? _data;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<AlbumModel> _load() async {
    var resp = await AlbumService.albumDetail(widget.albumID);
    if (resp!.isError) {}

    setState(() {
      _data = resp.asValue!.value;
    });

    return resp.asFuture;
  }

  ///build a preview stack for loading or error
  Widget _buildPreview(BuildContext context, Widget content) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          title: _data == null ? const Text('专辑详情') : null,
          expandedHeight: _data == null ? kToolbarHeight : HEIGHT_HEADER,
          flexibleSpace: _data == null ? null : _DetailHeader(_data!),
          bottom: _data == null ? null : MusicListHeader(_data!.songs),
        ),
        SliverList(delegate: SliverChildListDelegate([content]))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: (_data == null)
          ? _buildPreview(context,
              const SizedBox(height: 200, child: Center(child: Text("努力加载中..."))))
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  elevation: 0,
                  pinned: true,
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: HEIGHT_HEADER,
                  bottom: _buildListHeader(context),
                  flexibleSpace: _DetailHeader(_data!),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _data!.songs.length) {
                          return bottomPadding(context);
                        }
                        return InkWell(
                          onTap: () => context.read<KugeAudioPlayer>().play(_data!.songs[index]),
                          child: ListTile(
                              contentPadding: EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: FadeInImage(
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(_data!.songs[index].picUrl!),
                                  placeholder: const AssetImage('assets/images/song.png'),
                                ),
                              ),
                              title: Text(_data!.songs[index].name!,
                                  maxLines: 1),
                              subtitle: Text(_data!.songs[index].singerName!,
                                  maxLines: 1),
                              trailing: IconButton(
                                  icon: const Icon(Icons.play_circle_outline),
                                  onPressed: () {
                                    context.read<KugeAudioPlayer>().play(_data!.songs[index]);
                                    Navigator.pushNamed(context, Routes.playerPage);
                                  })));
                      },
                      childCount: _data!.songs.length +1),
                ),
              ],
            ),

      //    FutureBuilder<AlbumModel>(
      // future:  //  kugeRepository.albumDetail(widget.albumID),
      // builder: (context, result) {
      //   if (result == null) {
      //     return _buildLoading(context);
      //   } else {
      //     return _Body(result);
      //   }
      // }),
      bottomNavigationBar: BottomControllerBar(),
    );
  }

  PreferredSizeWidget _buildListHeader(BuildContext context) {
    // bool owner = widget.playlist.creator != null && (widget.playlist.creator["userId"] == Provider.of<UserAccount>(context).userId);
    // if (!owner) {
    //   tail = _SubscribeButton(widget.playlist.subscribed, widget.playlist.subscribedCount, _doSubscribeChanged);
    // }
    return MusicListHeader(_data!.songs, tail: Container());
  }
}

///action button for playlist header
class _HeaderAction extends StatelessWidget {
  _HeaderAction(this.icon, this.action, this.onTap);

  final IconData icon;

  final String action;

  GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).primaryTextTheme;

    return InkResponse(
      onTap: onTap,
      splashColor: textTheme.bodyText2!.color,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: textTheme.bodyText2!.color,
            ),
            const Padding(padding: EdgeInsets.only(top: 4)),
            Text(
              action,
              style: textTheme.caption!.copyWith(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}

///播放列表头部背景
class PlayListHeaderBackground extends StatelessWidget {
  final String imageUrl;

  const PlayListHeaderBackground({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Image(
            image: CachedNetworkImageProvider(imageUrl),
            fit: BoxFit.cover,
            width: 120,
            height: 1),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(color: Colors.black.withOpacity(0.3)),
        ),
        Container(color: Colors.black.withOpacity(0.3))
      ],
    );
  }
}

///header show list information
class DetailHeader extends StatelessWidget {
  const DetailHeader(
      {Key? key,
      required this.content,
      this.onCommentTap,
      this.onShareTap,
      this.onSelectionTap,
      int commentCount = 0,
      int shareCount = 0,
      this.background})
      : commentCount = commentCount ?? 0,
        shareCount = shareCount ?? 0,
        super(key: key);

  final Widget content;

  final GestureTapCallback? onCommentTap;
  final GestureTapCallback? onShareTap;
  final GestureTapCallback? onSelectionTap;

  final int commentCount;
  final int shareCount;

  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        background!,
        Material(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + kToolbarHeight),
            child: Column(
              children: <Widget>[
                content,
                const SizedBox(height: 10),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _HeaderAction(
                        Icons.comment,
                        commentCount > 0 ? commentCount.toString() : "评论",
                        onCommentTap),
                    _HeaderAction(
                        Icons.share,
                        shareCount > 0 ? shareCount.toString() : "分享",
                        onShareTap),
                    _HeaderAction(Icons.file_download, '下载', null),
                    // _HeaderAction(Icons.check_box, "多选", onSelectionTap),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ]..removeWhere((v) => v == null),
    );
  }
}

///a detail header describe playlist information
class _DetailHeader extends StatelessWidget {
  const _DetailHeader(this.data);

  final AlbumModel data;

  @override
  Widget build(BuildContext context) {
    return FlexibleDetailBar(
      background: PlayListHeaderBackground(imageUrl: data.getCoverImg),
      content: _buildContent(context),
      builder: (context, t) => AppBar(
        elevation: 0,
        titleSpacing: 0,
        leading: const BackButton(color: Colors.white),
        automaticallyImplyLeading: false,
        title: const Text("专辑详情", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    // Map<String, Object> creator = playlist.creator;

    return DetailHeader(
        commentCount: Random().nextInt(100000),
        shareCount: Random().nextInt(100000),
        onCommentTap: () {
          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return CommentPage(
          //     threadId:
          //         CommentThreadId(playlist.id, CommentType.playlist, payload: CommentThreadPayload.playlist(playlist)),
          //   );
          // }));
        },
        onSelectionTap: () async {
          // if (musicList == null) {
          //   // showSimpleNotification(Text("歌曲未加载,请加载后再试"));
          // } else {
          //   await Navigator.push(context, MaterialPageRoute(builder: (context) {
          //     return PlaylistSelectionPage(
          //         list: musicList,
          //         onDelete: (selected) async {
          //           // return neteaseRepository.playlistTracksEdit(
          //           //     PlaylistOperation.remove, playlist.id, selected.map((m) => m.id).toList());
          //         });
          //   }));
          // }
        },
        // onShareTap: () => toast("未接入！"),
        content: SizedBox(
          height: 146,
          child: Row(
            children: <Widget>[
              const SizedBox(width: 16),
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  child: Image(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(data.getCoverImg)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(data.getName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 20, color: Colors.white)),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("歌手: ", style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(color: Colors.white)),
                          Text(data.singerName!, style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("发行时间: ", style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(color: Colors.white)),
                          Text(data.releaseTime!.split("T")[0], style: Theme.of(context).primaryTextTheme.bodyText1!.copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
