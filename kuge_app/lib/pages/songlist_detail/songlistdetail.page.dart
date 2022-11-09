import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/bottomPlayerBar.dart';
import 'package:kuge_app/material/bottom_padding.dart';
import 'package:kuge_app/material/flexible_app_bar.dart';
import 'package:kuge_app/model/playlist.model.dart';
import 'package:kuge_app/pages/search/search.page.dart';
import 'package:kuge_app/pages/songlist_detail/song_list_header.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/songlist.service.dart';
import 'package:kuge_app/utils/number.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///歌单详情信息 header 高度
const double HEIGHT_HEADER = 264 + kToolbarHeight;

class PlaylistDetailPage extends StatefulWidget {
  final int playlistId;

  const PlaylistDetailPage(this.playlistId);

  @override
  State<StatefulWidget> createState() => _PlayListDetailState();
}

class _PlayListDetailState extends State<PlaylistDetailPage> {
  SonglistModel? _data;

  @override
  void initState() {
    super.initState();

    _load();
  }

  Future<SonglistModel> _load() async {
    var resp = await SonglistService.songlistDetail(widget.playlistId);
    if (resp!.isError) {}

    setState(() {
      _data = resp.asValue!.value;
    });

    return resp.asFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: (_data == null)
          ? _buildPreview(
              context,
              const SizedBox(
                  height: 200, child: Center(child: Text("努力加载中..."))))
          : CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                elevation: 0,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                expandedHeight: HEIGHT_HEADER,
                flexibleSpace: _PlaylistDetailHeader(_data!),
                bottom: _buildListHeader(context),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  if (index >= _data!.songs.length) {
                    return bottomPadding(context);
                  }

                  return InkWell(
                      onTap: () {
                        context
                            .read<KugeAudioPlayer>()
                            .play(_data!.songs[index]);
                      },
                      child: ListTile(
                          contentPadding: EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: FadeInImage(
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  _data!.songs[index].picUrl!),
                              placeholder: const AssetImage(
                                  'assets/images/place_block.png'),
                            ),
                          ),
                          title: Text(_data!.songs[index].name!, maxLines: 1),
                          subtitle: Text(_data!.songs[index].singerName!,
                              maxLines: 1),
                          trailing: IconButton(
                              icon: const Icon(Icons.play_circle_outline),
                              onPressed: () {
                                context
                                    .read<KugeAudioPlayer>()
                                    .play(_data!.songs[index]);
                                Navigator.pushNamed(context, Routes.playerPage);
                              })));
                }, childCount: _data!.songs.length + 1),
              ),
            ]),
      bottomNavigationBar: BottomControllerBar(),
    );
  }

  ///build a preview stack for loading or error
  Widget _buildPreview(BuildContext context, Widget content) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          automaticallyImplyLeading: false,
          title: _data == null ? const Text('歌单详情') : null,
          expandedHeight: _data == null ? kToolbarHeight : HEIGHT_HEADER,
          flexibleSpace: _data == null ? null : _PlaylistDetailHeader(_data!),
        ),
        SliverList(delegate: SliverChildListDelegate([content]))
      ],
    );
  }

  ///订阅与取消订阅歌单
  Future<bool> _doSubscribeChanged(bool subscribe) async {
    bool succeed = true;

    try {
      // succeed = await showLoaderOverlay(context, neteaseRepository.playlistSubscribe(widget.playlist.id, !subscribe));
    } catch (e) {
      succeed = false;
    }
    String action = !subscribe ? "收藏" : "取消收藏";
    if (succeed) {
      // showSimpleNotification(Text("$action成功"));
    } else {
      // showSimpleNotification(Text("$action失败"), background: Theme.of(context).errorColor);
    }
    return succeed ? !subscribe : subscribe;
  }

  PreferredSizeWidget? _buildListHeader(BuildContext context) {
    Widget tail =
        _SubscribeButton(false, _data!.shareCount, _doSubscribeChanged);
    return MusicListHeader(_data!.songs, tail: tail);
  }

  void showSimpleNotification(Text text) {}
}

class _SubscribeButton extends StatefulWidget {
  final bool subscribed;
  final int subscribedCount;

  ///currentState : is playlist be subscribed when function invoked
  final Future<bool> Function(bool currentState) doSubscribeChanged;

  const _SubscribeButton(
      this.subscribed, this.subscribedCount, this.doSubscribeChanged,
      {Key? key})
      : super(key: key);

  @override
  _SubscribeButtonState createState() => _SubscribeButtonState();
}

class _SubscribeButtonState extends State<_SubscribeButton> {
  bool subscribed = false;

  @override
  void initState() {
    super.initState();
    subscribed = false; // widget.subscribed;
  }

  @override
  Widget build(BuildContext context) {
    if (!subscribed) {
      return ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10), bottomLeft: Radius.circular(3)),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Theme.of(context).primaryColor.withOpacity(0.5),
            Theme.of(context).primaryColor
          ])),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                // final result = await widget.doSubscribeChanged(subscribed);
                // setState(() {
                //   subscribed = result;
                // });
              },
              child: Row(
                children: const <Widget>[
                  // SizedBox(width: 16),
                  // Icon(Icons.add, color: Theme.of(context).primaryIconTheme.color),
                  // SizedBox(width: 4),
                  // // Text(
                  // //   "收藏",
                  // //   // "收藏(${getFormattedNumber(widget.subscribedCount)})",
                  // //   style: Theme.of(context).primaryTextTheme.bodyText2,
                  // // ),
                  // SizedBox(width: 16),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return InkWell(
          child: SizedBox(
            height: 40,
            child: Row(
              children: <Widget>[
                const SizedBox(width: 16),
                Icon(Icons.folder_special,
                    size: 20, color: Theme.of(context).disabledColor),
                const SizedBox(width: 4),
                Text("getFormattedNumber(widget.subscribedCount)",
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14)),
                const SizedBox(width: 16),
              ],
            ),
          ),
          onTap: () async {
            final result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: const Text("确定不再收藏此歌单吗?"),
                    actions: <Widget>[
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("取消")),
                      TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("不再收藏"))
                    ],
                  );
                });
            if (result != null && result) {
              final result = await widget.doSubscribeChanged(subscribed);
              setState(() {
                subscribed = result;
              });
            }
          });
    }
  }
}

///header show list information
class DetailHeader extends StatelessWidget {
  final Widget content;
  final GestureTapCallback? onCommentTap;
  final GestureTapCallback? onShareTap;
  final GestureTapCallback? onSelectionTap;
  final int commentCount;
  final int shareCount;
  final Widget? background;

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
                SizedBox(height: 30.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _headerAction(
                        context,
                        Icons.comment,
                        commentCount > 0 ? commentCount.toString() : "评论",
                        null),
                    _headerAction(context, Icons.share,
                        shareCount > 0 ? shareCount.toString() : "分享", null),
                    _headerAction(context, Icons.file_download, '下载', null),
                    // _HeaderAction(Icons.check_box, "多选", onSelectionTap),
                  ],
                )
              ],
            ),
          ),
        ),
      ]..removeWhere((v) => v == null),
    );
  }

  ///action button for playlist header
  Widget _headerAction(BuildContext context, IconData icon, String action,
      GestureTapCallback? onTap) {
    // var textColor = Theme.of(context).secondaryHeaderColor;

    return InkResponse(
      onTap: onTap,
      // splashColor: textColor,
      child: Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              // color: textColor,
            ),
            const Padding(padding: EdgeInsets.only(top: 4)),
            Text(
              action,
              style: const TextStyle(fontSize: 13),
            )
          ],
        ),
      ),
    );
  }
}

///a detail header describe playlist information
class _PlaylistDetailHeader extends StatelessWidget {
  final SonglistModel _data;
  ProxyAnimation transitionAnimation =
      ProxyAnimation(kAlwaysDismissedAnimation);

  _PlaylistDetailHeader(this._data);

  @override
  Widget build(BuildContext context) {
    return FlexibleDetailBar(
      background: _headerBackground(context, _data.coverImg!),
      content: _buildContent(context),
      builder: (context, t) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        leading: const BackButton(color: Colors.white),
        title: const Text("歌单详情", style: TextStyle(color: Colors.white70)),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.search, color: Colors.white70),
              onPressed: () => Navigator.push(
                  context, SearchPageRoute(transitionAnimation))),
        ],
      ),
    );
  }

  Widget _headerBackground(BuildContext context, String imageUrl) {
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

  Widget _buildContent(BuildContext context) {
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
          if (_data.songs == null) {
            // showSimpleNotification(Text("歌曲未加载,请加载后再试"));
          } else {
            // await Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return PlaylistSelectionPage(
            //       list: musicList,
            //       onDelete: (selected) async {
            //         // return neteaseRepository.playlistTracksEdit(
            //         //     PlaylistOperation.remove, playlist.id, selected.map((m) => m.id).toList());
            //       });
            // }));
          }
        },
        // onShareTap: () => toast("未接入！"),
        content: Container(
          height: 146,
          padding: EdgeInsets.only(left: 10.w),
          child: Row(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  child: Stack(
                    children: <Widget>[
                      Image(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(_data.coverImg!)),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                              Colors.black54,
                              Colors.black26,
                              Colors.transparent,
                              Colors.transparent,
                            ])),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(Icons.headset, size: 11),
                              Text(getFormattedNumber(_data.playCount),
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.white70))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      _data.getName!,
                      style:
                          const TextStyle(fontSize: 20, color: Colors.white70),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) {
                        //   return UserDetailPage(userId: creator['userId']);
                        // }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            // SizedBox(
                            //   height: 24,
                            //   width: 24,
                            //   child: ClipOval(
                            //     child: Image(image: CachedImage(playlist.getCoverUrl)),
                            //   ),
                            // ),
                            // Padding(padding: EdgeInsets.only(left: 4)),
                            const Text("标签: ",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white70)),
                            Text(_data.getTags!,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white70)),
                            // Icon(
                            //   Icons.chevron_right,
                            //   color: Theme.of(context).secondaryHeaderColor,
                            // )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
