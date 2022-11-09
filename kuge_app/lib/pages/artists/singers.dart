import 'package:azlistview/azlistview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/model/artist.model.dart';
import 'package:kuge_app/pages/search/search.page.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/artist.service.dart';

class SingersPage extends StatefulWidget {
  @override
  SingersPageState createState() => SingersPageState();
}

class SingersPageState extends State<SingersPage> {
  bool _loading = false;
  List<ArtistModel> artists = [];
  Future<List<ArtistModel>>? _futureBuilderFuture;

  String la = "";
  String cat = "";
  String ft = "";

  ProxyAnimation transitionAnimation = ProxyAnimation(kAlwaysDismissedAnimation);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      var position = _scrollController.position;
      if (position.maxScrollExtent - position.pixels < 100) {
        _loadMore();
      }
    });

    _futureBuilderFuture = _loadMore() as Future<List<ArtistModel>>?;

    setState(() {
      artists = ArtistService.cachedArtistList()!;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<ArtistModel>?> _loadMore() async {
    if (_loading == true) {
      return null;
    }

    setState(() {
      _loading = true;
    });

    var resp = await ArtistService.listArtist(limit: 100, offset: artists.length);
    if (resp != null && resp.isValue) {
      artists.addAll(resp.asValue!.value);
    }

    setState(() {
      _loading = false;
    });

    if (resp!.asValue!.value.isNotEmpty) {
      Future.delayed(const Duration(milliseconds: 5)).then((value) => _loadMore());
    }
    
    return resp.asFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('歌手'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                Navigator.push(context, SearchPageRoute(transitionAnimation)),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(58.0),
            child: Container(
                padding: const EdgeInsets.all(0),
                child: Column(children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          width: ScreenUtil().getWidth(60),
                          height: ScreenUtil().getWidth(40),
                          child: TextButton(
                              child: Text("全部",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: la == ""
                                          ? FontWeight.w900
                                          : FontWeight.w400)),
                              onPressed: () {
                                setState(() {
                                  la = "";
                                });
                              }),
                        ),
                        SizedBox(
                          width: ScreenUtil().getWidth(60),
                          height: ScreenUtil().getWidth(40),
                          child: TextButton(
                              onPressed: () {
                                setState(() {
                                  la = "华语";
                                });
                              },
                              child: Text("华语",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: la == "华语"
                                          ? FontWeight.w900
                                          : FontWeight.w400))),
                        ),
                        SizedBox(
                          width: ScreenUtil().getWidth(60),
                          height: ScreenUtil().getWidth(40),
                          child: TextButton(
                              child: Text("欧美",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: (la == "欧美")
                                          ? FontWeight.w900
                                          : FontWeight.w400)),
                              onPressed: () {
                                setState(() {
                                  la = "欧美";
                                });
                              }),
                        ),
                        SizedBox(
                          width: ScreenUtil().getWidth(60),
                          height: ScreenUtil().getWidth(40),
                          child: TextButton(
                              child: Text("日韩",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: la == "日韩"
                                          ? FontWeight.w900
                                          : FontWeight.w400)),
                              onPressed: () {
                                setState(() {
                                  la = "日韩";
                                });
                              }),
                        ),
                      ]),
                  Row(children: [
                    SizedBox(
                      width: ScreenUtil().getWidth(60),
                      height: ScreenUtil().getWidth(40),
                      child: TextButton(
                          child: Text("全部",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: cat == ""
                                      ? FontWeight.w900
                                      : FontWeight.w400)),
                          onPressed: () {
                            setState(() {
                              cat = "";
                            });
                          }),
                    ),
                    SizedBox(
                      width: ScreenUtil().getWidth(60),
                      height: ScreenUtil().getWidth(40),
                      child: TextButton(
                          child: Text("男",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: cat == "男"
                                      ? FontWeight.w900
                                      : FontWeight.w400)),
                          onPressed: () {
                            setState(() {
                              cat = "男";
                            });
                          }),
                    ),
                    SizedBox(
                      width: ScreenUtil().getWidth(60),
                      height: ScreenUtil().getWidth(40),
                      child: TextButton(
                          child: Text("女",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: cat == "女"
                                      ? FontWeight.w900
                                      : FontWeight.w400)),
                          onPressed: () {
                            setState(() {
                              cat = "女";
                            });
                          }),
                    ),
                    SizedBox(
                      width: ScreenUtil().getWidth(60),
                      height: ScreenUtil().getWidth(40),
                      child: TextButton(
                          child: Text("组合",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: cat == "组合"
                                      ? FontWeight.w900
                                      : FontWeight.w400)),
                          onPressed: () {
                            setState(() {
                              cat = "组合";
                            });
                          }),
                    ),
                  ]),
                ]))),
      ),
      body: FutureBuilder<List<ArtistModel>>(
          initialData: artists,
          future: _futureBuilderFuture,
          builder: (context, snapshot) {
            return (artists == null)
                ? const Center(child: Text('努力加载中...'))
                : AzListView(
                    data: artists,
                    itemCount: artists.length,
                    itemBuilder: (BuildContext context, int i) {
                      // if (i >= this.artists.length - 1) {
                      //   return (_loading)
                      //       ? SpinKitCircle(color: Colors.black, size: 32.0)
                      //       : FlatButton(child: new Text('加载更多', style: TextStyle(color: Colors.grey[600])),onPressed: () => _loadMore());
                      // }
                      if ((la != "" && artists[i].la != la) || (cat != "" && artists[i].cat != cat)) {
                        return const SizedBox(width: 0, height: 0);
                      }
                      return InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.artistDetailPage, arguments: artists[i].id),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: FadeInImage(
                                    placeholder: const AssetImage("assets/images/place_block.png"),
                                    image: CachedNetworkImageProvider(artists[i].avatarURL),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(artists[i].name, style: Theme.of(context).textTheme.subtitle1),
                          ));
                    },
                    physics: const BouncingScrollPhysics(),
                    indexBarData: const [...kIndexBarData],
                    indexBarOptions: const IndexBarOptions(
                      needRebuild: true,
                      ignoreDragCancel: true,
                      downTextStyle:TextStyle(fontSize: 12, color: Colors.white),
                      downItemDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                    ),
                  );

            // ListView.separated(
            //     itemCount: artists.length,
            //     controller: this._scrollController,
            //     itemBuilder: (context, i) {
            //       if (i >= this.artists.length - 1) {
            //         return (_loading)
            //             ? SpinKitCircle(color: Colors.black, size: 32.0)
            //             : FlatButton(
            //                 child: new Text('加载更多', style: TextStyle(color: Colors.grey[600])),
            //                 onPressed: () => _loadMore());
            //       }
            //       if ((artists[i].la != la && la != "") || (artists[i].cat != cat && cat != "")) {
            //         return Container(width: 0, height: 0);
            //       }

            //       return InkWell(
            //         onTap: () => Navigator.pushNamed(context, Routes.artistDetailPage, arguments: artists[i].id),
            //         child: ListTile(
            //             leading: Container(
            //               padding: EdgeInsets.all(3),
            //               child: ClipRRect(
            //                 borderRadius: BorderRadius.all(Radius.circular(5)),
            //                 child: AspectRatio(
            //                   aspectRatio: 1,
            //                   child: FadeInImage(
            //                     placeholder: AssetImage("assets/images/place_block.png"),
            //                     image: CachedNetworkImageProvider(artists[i].avatarURL),
            //                     fit: BoxFit.cover,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             title: Text("${artists[i].name}", style: Theme.of(context).textTheme.subtitle1),
            //           ));
            //     },
            //     separatorBuilder: (context, i) {
            //       if ((artists[i].la == la || la == "") &&
            //           (artists[i].cat == cat || cat == "") &&
            //           i < this.artists.length) {
            //         return Divider(
            //           height: .5,
            //           indent: 100,
            //           color: Color(0xFFDDDDDD),
            //         );
            //       } else {
            //         return Container(width: 0, height: 0);
            //       }
            //     });
          }),
      // bottomSheet: PlayWidget(),
    );
  }

  Widget _getSusItem(BuildContext context, String tag,
      {double susHeight = 40}) {
    return Container(
      height: susHeight,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 16.0),
      color: const Color(0xFFF3F4F5),
      alignment: Alignment.centerLeft,
      child: Text(
        tag,
        softWrap: false,
        style: const TextStyle(
          fontSize: 14.0,
          color: Color(0xFF666666),
        ),
      ),
    );
  }
}
