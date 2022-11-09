class RecommendSongListModel {
  bool? hasTaste;
  int? code;
  int? category;
  List<Result>? result;

  RecommendSongListModel(
      {required this.hasTaste,
      required this.code,
      required this.category,
      required this.result});

  RecommendSongListModel.fromJson(Map<String, dynamic> json) {
    hasTaste = json['hasTaste'];
    code = json['code'];
    category = json['category'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasTaste'] = hasTaste;
    data['code'] = code;
    data['category'] = category;
    data['result'] = result!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Result {
  int? id;
  int? type;
  String? name;
  String? copywriter;
  String? picUrl;
  bool? canDislike;
  int? playCount;
  int? trackCount;
  bool? highQuality;
  String? alg;

  Result(
      this.id,
      this.type,
      this.name,
      this.copywriter,
      this.picUrl,
      this.canDislike,
      this.playCount,
      this.trackCount,
      this.highQuality,
      this.alg);

  Result.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    copywriter = json['copywriter'];
    picUrl = json['picUrl'];
    canDislike = json['canDislike'];
    playCount = json['playCount'];
    trackCount = json['trackCount'];
    highQuality = json['highQuality'];
    alg = json['alg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    data['copywriter'] = copywriter;
    data['picUrl'] = picUrl;
    data['canDislike'] = canDislike;
    data['playCount'] = playCount;
    data['trackCount'] = trackCount;
    data['highQuality'] = highQuality;
    data['alg'] = alg;
    return data;
  }
}
