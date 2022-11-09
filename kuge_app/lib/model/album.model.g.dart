// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlbumModel _$AlbumModelFromJson(Map<String, dynamic> json) => AlbumModel()
  ..id = json['id'] as int?
  ..dataID = json['data_id'] as String?
  ..name = json['name'] as String?
  ..singerName = json['singer'] as String?
  ..thumbImg = json['thumb_img'] as String?
  ..companies = json['companies'] as String?
  ..releaseTime = json['release_time'] as String?
  ..intro = json['intro'] as String?
  ..songs = (json['songs'] as List<dynamic>)
      .map((e) => MusicModel.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$AlbumModelToJson(AlbumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data_id': instance.dataID,
      'name': instance.name,
      'singer': instance.singerName,
      'thumb_img': instance.thumbImg,
      'companies': instance.companies,
      'release_time': instance.releaseTime,
      'intro': instance.intro,
      'songs': instance.songs,
    };
