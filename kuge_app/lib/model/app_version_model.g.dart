// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionModel _$AppVersionModelFromJson(Map<String, dynamic> json) =>
    AppVersionModel(
      id: json['id'] as String,
      content: json['content'] as String,
      url: json['url'] as String,
      version: json['version'] as String,
      appType: json['appType'] as int,
      isUpdate: json['isUpdate'] as int,
      isSensitive: json['isSensitive'] as int,
    );

Map<String, dynamic> _$AppVersionModelToJson(AppVersionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'url': instance.url,
      'version': instance.version,
      'appType': instance.appType,
      'isUpdate': instance.isUpdate,
      'isSensitive': instance.isSensitive,
    };
