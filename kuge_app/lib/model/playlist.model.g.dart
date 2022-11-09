// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playlist.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SonglistModel _$SonglistModelFromJson(Map<String, dynamic> json) =>
    SonglistModel(
      json['id'] as int,
      json['data_id'] as String?,
      json['name'] as String?,
      json['cover_img_name'] as String?,
      json['tags'] as String?,
      json['intro'] as String?,
      json['share_count'] as int,
      json['play_count'] as int,
    )..songs = (json['track_ids'] as List<dynamic>)
        .map((e) => MusicModel.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$SonglistModelToJson(SonglistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data_id': instance.dataId,
      'name': instance.name,
      'cover_img_name': instance.coverImg,
      'tags': instance.tags,
      'intro': instance.intro,
      'share_count': instance.shareCount,
      'play_count': instance.playCount,
      'track_ids': instance.songs,
    };
