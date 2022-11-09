class FindSwiperModel {
  List<Banners>? banners;
  int? code;

  FindSwiperModel(this.banners, this.code);

  FindSwiperModel.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners!.add(Banners.fromJson(v));
      });
    }
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['banners'] = banners!.map((v) => v.toJson()).toList();
    data['code'] = code;
    return data;
  }
}

class Banners {
  String? imageUrl;
  int? targetId;
  void adid;
  int? targetType;
  String? titleColor;
  String? typeTitle;
  String? url;
  bool? exclusive;
  void monitorImpress;
  void monitorClick;
  void monitorType;
  void monitorImpressList;
  void monitorClickList;
  void monitorBlackList;
  void extMonitor;
  void extMonitorInfo;
  void adSource;
  void adLocation;
  String? encodeId;
  void program;
  void event;
  void video;
  void song;
  String? scm;

  Banners(
      {this.imageUrl,
      this.targetId,
      this.adid,
      this.targetType,
      this.titleColor,
      this.typeTitle,
      this.url,
      this.exclusive,
      this.monitorImpress,
      this.monitorClick,
      this.monitorType,
      this.monitorImpressList,
      this.monitorClickList,
      this.monitorBlackList,
      this.extMonitor,
      this.extMonitorInfo,
      this.adSource,
      this.adLocation,
      this.encodeId,
      this.program,
      this.event,
      this.video,
      this.song,
      this.scm});

  Banners.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    targetId = json['targetId'];
    adid = json['adid'];
    targetType = json['targetType'];
    titleColor = json['titleColor'];
    typeTitle = json['typeTitle'];
    url = json['url'];
    exclusive = json['exclusive'];
    monitorImpress = json['monitorImpress'];
    monitorClick = json['monitorClick'];
    monitorType = json['monitorType'];
    monitorImpressList = json['monitorImpressList'];
    monitorClickList = json['monitorClickList'];
    monitorBlackList = json['monitorBlackList'];
    extMonitor = json['extMonitor'];
    extMonitorInfo = json['extMonitorInfo'];
    adSource = json['adSource'];
    adLocation = json['adLocation'];
    encodeId = json['encodeId'];
    program = json['program'];
    event = json['event'];
    video = json['video'];
    song = json['song'];
    scm = json['scm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['targetId'] = targetId;
    // data['adid'] = adid;
    data['targetType'] = targetType;
    data['titleColor'] = titleColor;
    data['typeTitle'] = typeTitle;
    data['url'] = url;
    data['exclusive'] = exclusive;
    // data['monitorImpress'] = monitorImpress;
    // data['monitorClick'] = monitorClick;
    // data['monitorType'] = monitorType;
    // data['monitorImpressList'] = monitorImpressList;
    // data['monitorClickList'] = monitorClickList;
    // data['monitorBlackList'] = monitorBlackList;
    // data['extMonitor'] = extMonitor;
    // data['extMonitorInfo'] = extMonitorInfo;
    // data['adSource'] = adSource;
    // data['adLocation'] = adLocation;
    // data['encodeId'] = encodeId;
    // data['program'] = program;
    // data['event'] = event;
    // data['video'] = video;
    // data['song'] = song;
    data['scm'] = scm;
    return data;
  }
}
