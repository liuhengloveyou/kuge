import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/route/routes.dart';
import 'package:kuge_app/service/personal.service.dart';
import 'package:provider/provider.dart';

class RecommendSong extends StatefulWidget {
  final BuildContext buildContext;

  const RecommendSong({super.key, required this.buildContext});

  @override
  _RecommendSongState createState() => _RecommendSongState();
}

class _RecommendSongState extends State<RecommendSong> {
  List<MusicModel>? _musicData;
  Future<List<MusicModel>>? _futureBuilderFuture;

  @override
  void initState() {
    super.initState();

    _futureBuilderFuture = _getSong();

    setState(() {
      _musicData = PersonalizedService.cachedPersonalizedSong();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SizedBox(
      // color: Colors.white,
      width: ScreenUtil().setWidth(686),
      child: Column(
        children: <Widget>[
          _title(),
          _songSection(context),
        ],
      ),
    ));
  }

  Widget _title() {
    return Container(
        margin: const EdgeInsets.fromLTRB(8, 30, 0, 10),
        // height: ScreenUtil().setHeight(100),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: ScreenUtil().setWidth(555),
              child: Text(
                '猜你喜欢这些单曲',
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(32),
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ));
  }

  // 推荐单区
  Widget _songSection(context) {
    return FutureBuilder<List<MusicModel>>(
        initialData: _musicData,
        future: _futureBuilderFuture,
        builder: (context, snapshot) {
          return (_musicData == null || _musicData!.isEmpty)
              ? Text('${snapshot.error}')
              : ListView.builder(
                  itemCount: _musicData!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          context
                              .read<KugeAudioPlayer>()
                              .play(_musicData![index]);
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
                                  _musicData![index].picUrl!),
                              placeholder:
                                  const AssetImage('assets/images/song.png'),
                            ),
                          ),
                          title: Text(_musicData![index].name!, maxLines: 1),
                          subtitle:
                              Text(_musicData![index].singerName!, maxLines: 1),
                          trailing: IconButton(
                              icon: const Icon(Icons.play_circle_outline,
                                  color: Colors.grey),
                              onPressed: () {
                                context
                                    .read<KugeAudioPlayer>()
                                    .play(_musicData![index]);
                                Navigator.pushNamed(context, Routes.playerPage);
                              }),
                        ));
                  },
                );
        });
  }

  Future<List<MusicModel>> _getSong() async {
    print('------------------推荐单曲------------------------');

    final resp = await PersonalizedService.personalizedSong();
    print('------------------推荐单曲:$resp');
    if (resp.isError == false) {
      setState(() {
        _musicData = resp.asValue!.value;
      });
    }

    return resp.asFuture;
  }
}
