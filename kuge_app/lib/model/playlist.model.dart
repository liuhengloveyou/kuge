// ignore_for_file: non_constant_identifier_names,library_prefixes
import 'package:json_annotation/json_annotation.dart';
import 'package:kuge_app/model/music.model.dart';

part 'playlist.model.g.dart';

@JsonSerializable(createToJson: null, nullable: false)
class SonglistModel {
   int id;
  @JsonKey(name: 'data_id', nullable: false)
   String? dataId;
   String? name;
  @JsonKey(name: 'cover_img_name', nullable: false)
   String? coverImg;
   String? tags;
   String? intro;
  @JsonKey(name: 'share_count')
   int shareCount;
  @JsonKey(name: 'play_count')
   int playCount;
  @JsonKey(name: 'track_ids', nullable: true)
   List<MusicModel> songs = [];

  SonglistModel(
      this.id,
      this.dataId,
      this.name,
      this.coverImg,
      this.tags,
      this.intro,
      this.shareCount,
      this.playCount);

  String? get getName => name;
  String? get getSubTitle => tags!.replaceAll('"', '').replaceAll(',', ' ').replaceAll("[", "").replaceAll("]", "");
  String? get getTags => tags!.replaceAll('"', '').replaceAll(',', ' ').replaceAll("[", "").replaceAll("]", "");

  factory SonglistModel.fromJson(Map<String, dynamic> srcJson) => _$SonglistModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$SonglistModelToJson(this);

  // static PlaylistDetail fromJson(Map map) {
  //   if (map == null) {
  //     return null;
  //   }

  //   var playlistDetail = PlaylistDetail(
  //       map['id'],
  //       map['name'],
  //       map['intro']
  //   );

  //   playlistDetail.dataId = map["data_id"];
  //   playlistDetail.coverImg = map["cover_img_name"];
  //   playlistDetail.tags = map["tags"];
  //   if (map.containsKey("track_ids")) {
  //     playlistDetail.musicList = (map['track_ids'] as List).cast<Map>().map((m) => Music.fromJson(m)).toList();
  //   }

  //   return playlistDetail;
  // }

  // Map toJson() {
  //   return {
  //     'id': id,
  //     "data_id": dataId,
  //     'name': name,
  //     "cover_img_name": coverImg,
  //     'track_ids': musicList?.map((m) => m.toJson())?.toList(),
  //     'intro': intro,
  //     'shareCount': shareCount,
  //     'playCount': playCount,
  //     'tags': tags,
  //   };
  // }
}
