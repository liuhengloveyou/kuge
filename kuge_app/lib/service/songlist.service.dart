import 'package:async/async.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/model/playlist.model.dart';
import 'package:sp_util/sp_util.dart';

class SonglistService {
  static Future<Result<List<SonglistModel>>?> list(
      {String tag = "", int offset = 0, int limit = 21}) async {
    final resp = await HttpUtil.getInstance().get(Api.PLAYLIST_API_URL,
        parameters: {'tag': tag, 'limit': limit, 'offset': offset});
    if (resp == null) {
      return null;
    }
    if (resp.data['data'] == null) {
      return null;
    }

    var list = (resp.data["data"] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => SonglistModel.fromJson(e))
        .toList();

    if (offset == 0) {
      SpUtil.putObjectList("cachedSongList", list);
    }

    return Result.value(list);
  }

  static List<SonglistModel>? cachedSongList() {
    var cacheData = SpUtil.getObjectList("cachedSongList");
    if (null == cacheData) {
      return null;
    }

    return cacheData
        .cast<Map<String, dynamic>>()
        .map((item) => SonglistModel.fromJson(item))
        .toList();
  }

  // 歌单详情
  static Future<Result<SonglistModel>?> songlistDetail(int id,
      { int s = 5}) async {
    final resp = await HttpUtil.getInstance()
        .get(Api.PLAYLIST_DETAIL_API_URL, parameters: {'id': id});
    if (resp == null) {
      return null;
    }
    if (resp.data['data'] == null) {
      return null;
    }

    return Result.value(SonglistModel.fromJson(resp.data['data']));
  }
}
