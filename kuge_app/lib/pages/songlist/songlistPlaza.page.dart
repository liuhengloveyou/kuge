import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuge_app/material/img_title_block.dart';
import 'package:kuge_app/model/playlist.model.dart';
import 'package:kuge_app/pages/search/search.page.dart';
import 'package:kuge_app/pages/songlist/playlist_filter.dart';
import 'package:kuge_app/provider/songListTag_provider.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/songlist.service.dart';
import 'package:provider/provider.dart';

class PlaylistPlaze extends StatefulWidget {
  @override
  PlaylistPlazeState createState() => PlaylistPlazeState();
}

class PlaylistPlazeState extends State<PlaylistPlaze>  with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  bool _loading = false;
  String tag = "";
  List<SonglistModel> _playLists = [];
  Future<List<SonglistModel>>? _futureBuilderFuture;

  final ScrollController _scrollController = ScrollController();
  ProxyAnimation transitionAnimation = ProxyAnimation(kAlwaysDismissedAnimation);

  List<String> tabKeys = ['推荐', '流行', "摇滚", "吉他", "蓝调", "地铁", "电子", '推荐', '流行', "摇滚", "吉他", "蓝调", "地铁", "电子"]; // 默认
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, length: tabKeys.length);
    _tabController.addListener(() {
      tag = tabKeys[_tabController.index];
      if (tag == "推荐") {
        tag = "";
      }
      _loadMore(reload: true);
    });

    _scrollController.addListener(() {
      var position = _scrollController.position;
      if (position.maxScrollExtent - position.pixels < 100) {
        _loadMore(); // 小于100px时，触发上拉加载；
      }
    });

    _futureBuilderFuture = _loadMore(reload: true);

    setState(() {
      _playLists = SonglistService.cachedSongList()!;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<SonglistModel>> _loadMore({bool reload = false}) async {
    if (_loading == true) {
      return [];
    }
    setState(() {
      _loading = true;
    });

    var offset = _playLists.length;
    if (reload) {
      offset = 0;
    }
    var resp = await SonglistService.list(tag: tag, limit: 21, offset: offset);

    if (reload || _playLists.isEmpty) {
      _playLists = resp!.asValue!.value;
    } else {
      _playLists.addAll(resp!.asValue!.value);
    }

    setState(() {
      _loading = false;
    });

    return resp.asFuture;
  }

  @override
  Widget build(BuildContext context) {
    // 加载tab
    List<String> myTmp = context.watch<SongListTagProvider>().load();
    if (myTmp.isNotEmpty) {
      tabKeys = myTmp;
      
      _tabController = TabController(vsync: this, length: tabKeys.length);
      _tabController.addListener(() {
        tag = tabKeys[_tabController.index];
        if (tag == "推荐") {
          tag = "";
        }
        _loadMore(reload: true);
      });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text('歌单广场'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(context, SearchPageRoute(transitionAnimation))),
          ],
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 40),
            child: Container(child:Stack(alignment: AlignmentDirectional.centerEnd, children: [
              Container(
                padding: const EdgeInsets.only(right: 50),
                child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: const BoxDecoration(),
                labelPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                labelStyle: TextStyle(
                    fontSize: ScreenUtil().getSp(20),
                    fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(
                    fontSize: ScreenUtil().getSp(16),
                    fontWeight: FontWeight.normal),
                tabs: tabKeys.map((String tk) => Tab(text: tk)).toList(),
              )),
              Container(
                width: 45,
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                color: Theme.of(context).primaryColor,
                child: IconButton(
                  padding: const EdgeInsets.all(0),
                  icon: Icon(Icons.menu, color: Theme.of(context).iconTheme.color),
                  onPressed: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, Animation<double> animation, Animation secondaryAnimation) =>
                            FadeTransition(opacity: animation, child: PlaylistFilter())
                    )
                    );
                  },
                ),
              )
            ])),
          ),
        ),
        body: FutureBuilder<List<SonglistModel>>(
            initialData: _playLists,
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              return (_playLists == null)
                  ? const Center(child: Text('努力加载中...'))
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: _playLists.length,
                      physics: const AlwaysScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      controller: _scrollController,
                      padding: const EdgeInsets.all(6),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        if (index >= _playLists.length - 1) {
                          Future.delayed(const Duration(seconds: 0))
                              .then((value) => _loadMore());
                          return const SpinKitCircle(color: Colors.black, size: 32.0);
                        }

                        return InkWell(
                            onTap: () => Navigator.pushNamed(
                                context, Routes.songListDetailPage,
                                arguments: _playLists[index].id),
                            child: ImgTitleBlock(
                                _playLists[index].coverImg!,
                                _playLists[index].name!,
                                _playLists[index].playCount));
                      });
            })
        // bottomSheet: BottomControllerBar()
    );
  }

  @override
  bool get wantKeepAlive => true;
}
