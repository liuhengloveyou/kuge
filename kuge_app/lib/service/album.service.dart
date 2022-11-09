import 'package:async/async.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/model/album.model.dart';
import 'package:sp_util/sp_util.dart';

class AlbumService {
  static Future<Result<List<AlbumModel>>?> listAlbum({int offset = 0, int limit = 21}) async {
    final resp = await HttpUtil.getInstance().get(Api.ALBUM_API_URL, parameters: {'limit': limit, 'offset': offset});
    if (resp == null) {
      return null;
    }
    if (resp.data['data'] == null) {
      return null;
    }

    var albumList =  (resp.data["data"] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => AlbumModel.fromJson(e))
        .toList();

    if (offset ==0) {
      SpUtil.putObjectList("cachedAlbumList", albumList);
    }
    
    return Result.value(albumList);
  }

  static List<AlbumModel>? cachedAlbumList() {
    var cacheData = SpUtil.getObjectList("cachedAlbumList");
    if (null == cacheData) {
      return null;
    }

    return cacheData.cast<Map<String, dynamic>>().map((item) => AlbumModel.fromJson(item)).toList();
  }

  // 歌单详情
  static Future<Result<AlbumModel>?> albumDetail(int id) async {
    final resp = await HttpUtil.getInstance().get(Api.ALBUM_DETAIL_API_URL, parameters: {'id': id});
    if (resp == null) {
      return null;
    }
    if (resp.data['data'] == null) {
      return null;
    }
    return Result.value(AlbumModel.fromJson(resp.data["data"]));
  }
}
