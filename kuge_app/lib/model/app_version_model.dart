import 'package:json_annotation/json_annotation.dart';

part 'app_version_model.g.dart';

@JsonSerializable(createToJson: null, nullable: false)
class AppVersionModel {
  final String id;
  final String content;
  final String url;
  final String version;
  final int appType;
  final int isUpdate;
  final int isSensitive;

  AppVersionModel({
    required this.id,
    required this.content,
    required this.url,
    required this.version,
    required this.appType,
    required this.isUpdate,
    required this.isSensitive,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> srcJson) => _$AppVersionModelFromJson(srcJson);

  Map<String, dynamic> toJson() => _$AppVersionModelToJson(this);
}
