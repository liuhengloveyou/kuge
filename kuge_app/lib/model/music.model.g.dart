// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicUrlModel _$MusicUrlModelFromJson(Map<String, dynamic> json) =>
    MusicUrlModel(
      json['url'] as String?,
      json['size'] as int?,
      json['md5'] as String?,
      json['encode_type'] as String?,
    );

Map<String, dynamic> _$MusicUrlModelToJson(MusicUrlModel instance) =>
    <String, dynamic>{
      'url': instance.url,
      'size': instance.size,
      'md5': instance.md5,
      'encode_type': instance.encode_type,
    };

MusicModel _$MusicModelFromJson(Map<String, dynamic> json) => MusicModel(
      json['id'] as int?,
      json['data_id'] as String?,
      json['name'] as String?,
      json['pic_name'] as String?,
      json['album_name'] as String?,
      json['singer_name'] as String?,
      json['write_name'] as String?,
      json['tags'] as String?,
    )
      ..words = json['words'] as String?
      ..urls = (json['urls'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, MusicUrlModel.fromJson(e as Map<String, dynamic>)),
      )
      ..songLength = json['songLength'] as String?
      ..loadlPath = json['loadlPath'] as String?;

Map<String, dynamic> _$MusicModelToJson(MusicModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'data_id': instance.dataId,
      'name': instance.name,
      'pic_name': instance.picUrl,
      'album_name': instance.albumName,
      'singer_name': instance.singerName,
      'write_name': instance.writerName,
      'tags': instance.tags,
      'words': instance.words,
      'urls': MusicModel._urlsToJson(instance.urls),
      'songLength': instance.songLength,
      'loadlPath': instance.loadlPath,
    };
