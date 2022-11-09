import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/material/bottom_padding.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/search.service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SongsResultSection extends StatefulWidget {
  const SongsResultSection({Key? key, required this.query}) : super(key: key);

  final String query;

  @override
  SongsResultSectionState createState() => SongsResultSectionState();
}

class SongsResultSectionState extends State<SongsResultSection> with AutomaticKeepAliveClientMixin {
  List<MusicModel> _musicData = [];
  Future<List<MusicModel>>? _futureBuilderFuture;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _futureBuilderFuture = _getSong();
    _getSong();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MusicModel>>(
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          return (_musicData.isEmpty)
              ? const Center(child: Text('努力加载中...'))
              : ListView.builder(
                  itemCount: _musicData.length +1,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= _musicData.length ) {
                      return bottomPadding(context);
                    }
                    return InkWell(
                      onTap: () => context.read<KugeAudioPlayer>().play(_musicData[index]),
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(16.w, 0, 20.w, 0),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: FadeInImage(
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            image: CachedNetworkImageProvider(_musicData[index].picUrl!),
                            placeholder: const AssetImage('assets/images/song.png'),
                          ),
                        ),
                        title: Text(_musicData[index].name!, maxLines: 1),
                        subtitle: Text(_musicData[index].singerName!, maxLines: 1),
                        trailing: IconButton(
                        icon: const Icon(Icons.play_circle_outline, color: Colors.grey),
                        onPressed: () {
                          context.read<KugeAudioPlayer>().play(_musicData[index]);
                          Navigator.pushNamed(context, Routes.playerPage);
                      })));
                  },
                );
        });
  }

  Future<List<MusicModel>> _getSong() async {
    var resp = await SearchService.searchMusic(widget.query);
    if (resp.isError) {}
    
    setState(() {
      _musicData = resp.asValue!.value;
    });

    return resp.asFuture;
  }
}
