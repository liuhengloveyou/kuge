import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/model/album.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/search.service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlbumsResultSection extends StatefulWidget {
  final String? query;

  const AlbumsResultSection({Key? key, this.query}) : super(key: key);

  @override
  _AlbumsResultSectionState createState() => _AlbumsResultSectionState();
}

class _AlbumsResultSectionState extends State<AlbumsResultSection> with AutomaticKeepAliveClientMixin {
  List<AlbumModel> _data = [];
  Future<List<AlbumModel>>? _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _futureBuilderFuture = _load();
    _load();
  }

  @override
  Widget build(BuildContext context) {
      return FutureBuilder<List<AlbumModel>>(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          return (_data.isEmpty)
              ? const Center(child: Text('努力加载中...'))
              : ListView.builder(
                  itemCount: _data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () => Navigator.pushNamed(context, Routes.albumInfoPage, arguments: _data[index].id),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: FadeInImage(
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(_data[index].thumbImg!),
                            placeholder: const AssetImage('assets/images/song.png'),
                          ),
                        ),
                        title: Text(_data[index].name!, maxLines: 1),
                        subtitle: Text(_data[index].getSubTitle, maxLines: 1)));
                  },
                );
        });
  }

    Future<List<AlbumModel>> _load() async {
    var resp = await SearchService.searchAlbums(widget.query!);
    if (resp.isError) {}
    
    setState(() {
      _data = resp.asValue!.value;
    });

    return resp.asFuture;
  }
}
