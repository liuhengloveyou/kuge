// ignore_for_file: unnecessary_null_comparison

// @JsonSerializable()
import 'package:azlistview/azlistview.dart';
import 'package:kuge_app/model/album.model.dart';
import 'package:kuge_app/model/music.model.dart';

class ArtistModel extends ISuspensionBean {
  int id = 0;
  String dataId = "";
  String name = "";
  String avatarURL = "";
  String intro = "";
  String la = "";
  String cat = "";
  String ft = "";
  String picUrl = "";
  int musicSize = 0;
  int albumSize = 0;
  List<MusicModel> hot_songs = [];
  List<AlbumModel> albums = [];

  ArtistModel();

  static ArtistModel fromJson(Map map) {
    var artist = ArtistModel();

    artist.id = map["id"];
    artist.dataId = map["data_id"];
    artist.name = map["name"];
    if (map.containsKey("avatar_url")) {
      artist.avatarURL = map["avatar_url"];
    }
    if (map.containsKey("hot_songs")) {
      artist.hot_songs = (map['hot_songs'] as List<MusicModel>)
          .map((e) => MusicModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (map.containsKey("albums")) {
      artist.albums = (map['albums'] as List)
          .map((e) => AlbumModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    artist.intro = map["intro"];
    artist.la = map["la"];
    artist.cat = map["cat"];
    artist.ft = map["ft"];

    artist.musicSize = map['musicSize'];
    artist.albumSize = map['albumSize'];

    return artist;
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
      "avatar_url": avatarURL,
      "intro": intro,
      "la": la,
      "cat": cat,
      "ft": ft,
      'musicSize': musicSize,
      'albumSize': albumSize,
    };
  }

  @override
  String getSuspensionTag() {
    return ft;
  }
}
