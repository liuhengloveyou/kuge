import 'package:async/async.dart' show Result;
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/model/album.model.dart';
import 'package:kuge_app/model/artist.model.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/model/playlist.model.dart';

class SearchService {
// 查询单曲
  static Future<Result<List<MusicModel>>> searchMusic(String k,
      {int offset = 0, int limit = 21}) async {
    final resp = await HttpUtil.getInstance().get(Api.SEARCH_API_URL,
        parameters: {'t': "B", 'k': k, 'limit': limit, 'offset': offset});
    return Result.value((resp.data['data'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => MusicModel.fromJson(e))
        .toList());
  }

// 查询歌单
  static Future<Result<List<SonglistModel>>> searchPlaylist(String k,
      {int offset = 0, int limit = 21}) async {
    final resp = await HttpUtil.getInstance().get(Api.SEARCH_API_URL,
        parameters: {"t": "D", "k": k, "limit": limit, "offset": offset});
    return Result.value((resp.data['data'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => SonglistModel.fromJson(e))
        .toList());
  }

  static Future<Result<List<ArtistModel>>> searchSingers(String k,
      {int offset = 0, int limit = 21}) async {
    final resp = await HttpUtil.getInstance().get(Api.SEARCH_API_URL,
        parameters: {"t": "A", "k": k, "limit": limit, "offset": offset});
    return Result.value((resp.data['data'] as List)
        .cast<Map>()
        .map((e) => ArtistModel.fromJson(e))
        .toList());
  }

  static Future<Result<List<AlbumModel>>> searchAlbums(String k,
      {int offset = 0, int limit = 21}) async {
    final resp = await HttpUtil.getInstance().get(Api.SEARCH_API_URL,
        parameters: {"t": "C", "k": k, "limit": limit, "offset": offset});

    return Result.value((resp.data['data'] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => AlbumModel.fromJson(e))
        .toList());
  }
}
