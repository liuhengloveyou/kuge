import 'dart:convert';

import 'package:async/async.dart';
import 'package:kuge_app/http/api.dart';
import 'package:kuge_app/http/http_util.dart';
import 'package:kuge_app/model/music.model.dart';

class SongService {
  static Future<Result<List<MusicModel>>?> Infos(List ids) async {
    final resp = await HttpUtil.getInstance()
        .get(Api.SONGS_INFO_API_URL, parameters: {'ids': json.encode(ids)});
    if (resp == null) {
      return null;
    }
    if (resp.data['data'] == null) {
      return null;
    }

    var albumList = (resp.data["data"] as List)
        .cast<Map<String, dynamic>>()
        .map((e) => MusicModel.fromJson(e))
        .toList();

    return Result.value(albumList);
  }
}
