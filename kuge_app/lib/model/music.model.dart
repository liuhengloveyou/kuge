import 'package:json_annotation/json_annotation.dart';

part 'music.model.g.dart';

@JsonSerializable()
class MusicUrlModel {
  String? url;
  int? size;
  String? md5;
  String? encode_type;

  MusicUrlModel(
    this.url,
    this.size,
    this.md5,
    this.encode_type,
  );

  factory MusicUrlModel.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicUrlModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicUrlModelToJson(this);
}

@JsonSerializable(createToJson: null)
class MusicModel {
  int? id;
  @JsonKey(name: 'data_id')
  String? dataId;
  String? name;
  @JsonKey(name: 'pic_name')
  String? picUrl;
  @JsonKey(name: 'album_name')
  String? albumName = '';
  @JsonKey(name: 'singer_name')
  String? singerName = '';
  @JsonKey(name: 'write_name')
  String? writerName;
  String? tags;
  String? words;
  @JsonKey(name: 'urls', toJson: _urlsToJson)
  Map<String, MusicUrlModel> urls = {};
  // List<Artist> artists;
  // List<Album> albums;
  // List<String> rate;
  // String fileType;
  String? songLength;
  String? loadlPath; // 本地下载文件的路径

  // 命名构造函数
  MusicModel.origin();

  MusicModel(
    this.id,
    this.dataId,
    this.name,
    this.picUrl,
    this.albumName,
    this.singerName,
    this.writerName,
    this.tags,
  );

  factory MusicModel.fromJson(Map<String, dynamic> srcJson) =>
      _$MusicModelFromJson(srcJson);
  Map<String, dynamic> toJson() => _$MusicModelToJson(this);

  static Map<String, dynamic> _urlsToJson(Map<String, MusicUrlModel> urls) {
    Map<String, dynamic> rst = <String, dynamic>{};

    if (urls.isEmpty) {
      return rst;
    }

    urls.forEach((key, value) {
      rst[key] = value.toJson();
    });

    return rst;
  }
  // String get artistString {
  //   if (artists != null) {
  //     return artists.map((e) => e.name).join('/');
  //   } else {
  //     return "让音乐陪伴生活";
  //   }
  // }

  String? get getTitle {
    if (name != "") {
      return name;
    } else {
      return "";
    }
  }

  String? get subTitle {
    if (singerName!.isNotEmpty) {
      return "$singerName <$albumName>";
    }
    return null;
  }

  String? get downloadUrl {
    if (urls == null) {
      return "";
    }
    if (urls["sq"] != null) {
      return urls["sq"]!.url;
    } else if (urls["hq"] != null) {
      return urls["hq"]!.url;
    } else if (urls["bq"] != null) {
      return urls["bq"]!.url;
    }
    return null;
  }

  String? get downloadName {
    if (urls == null) {
      return "";
    }
    if (urls["sq"] != null) {
      return "$id.${urls["sq"]!.url!.split(".").last}";
    } else if (urls["hq"] != null) {
      return "$id.${urls["hq"]!.url!.split(".").last}";
    } else if (urls["bq"] != null) {
      return "$id.${urls['bq']!.url!.split('.').last}";
    }
    return null;
  }
}
