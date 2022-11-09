import 'package:async/async.dart' show Result;
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/model/playlist.model.dart';
import 'package:sp_util/sp_util.dart';

class PersonalizedService {
  static Future<Result<List<SonglistModel>>?> personalizedPlaylist(
      {int limit = 6}) async {
    try {
      final resp = await HttpUtil.getInstance()
          .get(Api.PERSONALIZED_PLAYLIST_API, parameters: {'limit': limit});
      if (resp == null) {
        return null;
      }
      if (resp.data['data'] == null) {
        return null;
      }

      List<SonglistModel> songlistLiss = (resp.data['data'] as List)
          .cast<Map<String, dynamic>>()
          .map((item) => SonglistModel.fromJson(item))
          .toList();
      SpUtil.putObjectList("personalizedPlaylist", songlistLiss);

      return Result.value(songlistLiss);
    } catch (e) {
      print('personalizedPlaylist==>$e');
      return Result.error(e);
    }
  }

  static List<SonglistModel>? cachedPersonalizedPlaylist() {
    try {
      var cacheData = SpUtil.getObjectList("personalizedPlaylist");
      if (null == cacheData) {
        return null;
      }

      return cacheData
          .cast<Map<String, dynamic>>()
          .map((item) => SonglistModel.fromJson(item))
          .toList();
    } catch (e) {
      return null;
    }
  }

  // 推荐单曲
  static Future<Result<List<MusicModel>>> personalizedSong(
      {int limit = 10}) async {
    try {
      final resp = await HttpUtil.getInstance()
          .get(Api.PERSONALIZED_SONG_API, parameters: {'limit': 10});

      if (resp.data['data'] == null) {
        return Result.value([]);
      }

      var songList = (resp.data['data'] as List)
          .cast<Map<String, dynamic>>()
          .map((e) => MusicModel.fromJson(e))
          .toList();
      SpUtil.putObjectList("personalizedSong", songList);

      return Result.value(songList);
    } catch (e) {
      print('personalizedSong==>$e');
      return Result.error(e);
    }
  }

  static List<MusicModel>? cachedPersonalizedSong() {
    var cacheData = SpUtil.getObjectList("personalizedSong");
    if (null == cacheData) {
      return null;
    }

    return cacheData
        .cast<Map<String, dynamic>>()
        .map((item) => MusicModel.fromJson(item))
        .toList();
  }
}
