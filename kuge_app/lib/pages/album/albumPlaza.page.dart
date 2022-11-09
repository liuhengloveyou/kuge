import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kuge_app/model/album.model.dart';
import 'package:kuge_app/pages/search/search.page.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/album.service.dart';
import 'albumItemView.page.dart';

class AlbumPlaze extends StatefulWidget {
  @override
  AlbumPlazeState createState() => AlbumPlazeState();
}

class AlbumPlazeState extends State<AlbumPlaze> {
  List<AlbumModel> _albums = [];
  Future<List<AlbumModel>>? _futureBuilderFuture;

  final ScrollController _scrollController = ScrollController();
  ProxyAnimation transitionAnimation = ProxyAnimation(kAlwaysDismissedAnimation);

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      var position = _scrollController.position;
      if (position.maxScrollExtent - position.pixels < 100) {
        _loadMore(); // 小于100px时，触发上拉加载；
      }
    });

    _futureBuilderFuture = _loadMore();

    setState(() {
      _albums  = AlbumService.cachedAlbumList()!;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<AlbumModel>> _loadMore() async {
    var resp = await AlbumService.listAlbum();
    if (resp!.isError) {}

    setState(() {
      _albums = resp.asValue!.value;
    });

    return resp.asFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: const Text('专辑'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(context, SearchPageRoute(transitionAnimation)),
            ),
          ],
        ),
        body: FutureBuilder<List<AlbumModel>>(
            initialData: _albums,
            future: _futureBuilderFuture,
            builder: (context, snapshot) {
              return (_albums == null)
                  ? const Center(child: Text('努力加载中...'))
                  : GridView.builder(
                      shrinkWrap: true,
                      itemCount: _albums.length + 1,
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
                        if (index > _albums.length - 1) {
                          return const SpinKitCircle(color: Colors.black, size: 32.0);
                        } else {
                          return AlbumItemView(
                              album: _albums[index],
                              onTap: () => Navigator.pushNamed(context, Routes.albumInfoPage, arguments: _albums[index].id));
                        }
                      });
            }));
  }
}
