import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/service/user.service.dart';
import 'package:sp_util/sp_util.dart';

String playHistoryKey = "PlayHistory";
List<MusicModel> historySongs = [];

class PlayHistory {
  static List<MusicModel> get songs => historySongs;

  static loadCache() {
    historySongs.clear();

    try {
      final cacheList = SpUtil.getObjectList(playHistoryKey);
      for (int i = 0; i < cacheList!.length; i ++) {
        historySongs.add(MusicModel.fromJson(cacheList[i].cast()));
      }
    } catch (e) {

    }
  }

  static setCache(List<MusicModel> musics) {
    historySongs = musics;
    SpUtil.putObjectList(playHistoryKey, historySongs);
  }

  static add(MusicModel? music) {
    if (music == null) {
      return;
    }

    music.words = "";

    for (int i = 0; i < historySongs.length; i++) {
      if (music.id == historySongs[i].id) {
        historySongs.removeAt(i);
        break;
      }
    }
    if (historySongs.length > 100) {
      historySongs.removeLast();
    }

    historySongs.insert(0, music);

    SpUtil.putObjectList(playHistoryKey, historySongs);

    UsersService.updateSongPlayHistory(historySongs.map((e) => e.id!).toList());
  }
}