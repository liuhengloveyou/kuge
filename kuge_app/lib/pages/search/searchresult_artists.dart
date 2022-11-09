import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/material/bottom_padding.dart';
import 'package:kuge_app/model/artist.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/search.service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ArtistsResultSection extends StatefulWidget {
  final String? query;

  const ArtistsResultSection({Key? key, this.query}) : super(key: key);

  @override
  _ArtistsResultSectionState createState() => _ArtistsResultSectionState();
}

class _ArtistsResultSectionState extends State<ArtistsResultSection> with AutomaticKeepAliveClientMixin {
  List<ArtistModel> _data = [];
  Future<List<ArtistModel>>? _futureBuilderFuture;

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
    return FutureBuilder<List<ArtistModel>>(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          return (_data.isEmpty)
              ? const Center(child: Text('努力加载中...'))
              : ListView.builder(
                  itemCount: _data.length+1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= _data.length ) {
                      return bottomPadding(context);
                    }
                    return InkWell(
                        onTap: () => Navigator.pushNamed(context, Routes.artistDetailPage, arguments: _data[index].id),
                        child: ListTile(
                            contentPadding:
                                EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: FadeInImage(
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                image: CachedNetworkImageProvider(
                                    _data[index].avatarURL),
                                placeholder:
                                    const AssetImage('assets/images/place_block.png'),
                              ),
                            ),
                            title: Text(_data[index].name, maxLines: 1),
                            subtitle: Text(_data[index].la, maxLines: 1)));
                  },
                );
        });
  }

  Future<List<ArtistModel>> _load() async {
    var resp = await SearchService.searchSingers(widget.query!);
    if (resp.isError) {}

    setState(() {
      _data = resp.asValue!.value;
    });

    return resp.asFuture;
  }
}
