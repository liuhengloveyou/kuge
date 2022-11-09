import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/material/bottom_padding.dart';
import 'package:kuge_app/model/playlist.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/search.service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaylistResultSection extends StatefulWidget {
  final String? query;
  const PlaylistResultSection({Key? key, this.query}) : super(key: key);

  @override
  _PlaylistResultSectionState createState() => _PlaylistResultSectionState();
}

class _PlaylistResultSectionState extends State<PlaylistResultSection>
    with AutomaticKeepAliveClientMixin {
  List<SonglistModel> _data = [];
  Future<List<SonglistModel>>? _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _futureBuilderFuture = _getSonglist();
    _getSonglist();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SonglistModel>>(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          return (_data.isEmpty)
              ? const Center(child: Text('努力加载中...'))
              : ListView.builder(
                  itemCount: _data.length+1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= _data.length ) {
                      return bottomPadding(context);
                    }
                    return InkWell(
                      onTap: () => Navigator.pushNamed(context, Routes.songListDetailPage, arguments: _data[index].id),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: FadeInImage(
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(_data[index].coverImg!),
                            placeholder: const AssetImage('assets/images/song.png'),
                          ),
                        ),
                        title: Text(_data[index].name!, maxLines: 1),
                        subtitle: Text(_data[index].intro!, maxLines: 1),
                        // trailing: Icon(Icons.play_circle_outline)
                    ));
                  });
        });
  }

  Future<List<SonglistModel>> _getSonglist() async {
    var resp = await SearchService.searchPlaylist(widget.query!);
    if (resp.isError) {}

    setState(() {
      _data = resp.asValue!.value;
    });

    return resp.asFuture;
  }
}
