import 'music.model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'album.model.g.dart';

@JsonSerializable()
class AlbumModel {
  int? id = 0;
  @JsonKey(name: 'data_id')
  String? dataID = "";
  String? name;
  @JsonKey(name: 'singer')
  String? singerName = "";
  @JsonKey(name: 'thumb_img')
  String? thumbImg = "";
  String? companies = "";
  @JsonKey(name: 'release_time')
  String? releaseTime = "";
  String? intro = "";
  List<MusicModel> songs = [];

  AlbumModel();

  factory AlbumModel.fromJson(Map<String, dynamic> srcJson) =>
      _$AlbumModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$AlbumModelToJson(this);

  String get getCoverImg => thumbImg!;
  String get getName => name!;
  String get getSubTitle => "$companies  ${releaseTime!.split("T")[0]}";
}
