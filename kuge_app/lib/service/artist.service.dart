import 'package:async/async.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/model/artist.model.dart';
import 'package:sp_util/sp_util.dart';

class ArtistService {
  static Future<Result<List<ArtistModel>>?> listArtist({int offset = 0, int limit = 21}) async {
    final resp = await HttpUtil.getInstance().get(Api.ARTIST_API_URL, parameters: {'limit': limit, 'offset': offset});
    if (resp == null) {
      return null;
    }
    if (resp.data['data'] == null) {
      return null;
    }

    var list = (resp.data['data'] as List).cast<Map>().map((e) => ArtistModel.fromJson(e)).toList();
    if (offset == 0) {
      SpUtil.putObjectList("cachedArtistList", list);
    }  
    
    return Result.value(list);
  }

  static List<ArtistModel>? cachedArtistList() {
    var cacheData = SpUtil.getObjectList("cachedArtistList");
    if (null == cacheData) {
      return null;
    }

    return cacheData.cast<Map>().map((item) => ArtistModel.fromJson(item)).toList();
  }

  static Future<Result<ArtistModel>> artistDetail(int id) async {
    final resp = await HttpUtil.getInstance().get(Api.ARTIST_DETAIL_API_URL, parameters: {'id': id});
    return Result.value(ArtistModel.fromJson(resp.data['data']));
  }
}