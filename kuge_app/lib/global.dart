import 'dart:io';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:audio_service/audio_service.dart';

import 'package:kuge_app/service/play_history.service.dart';
import 'package:kuge_app/provider/liked_song.provider.dart';

class Global {
  static late AudioHandler audioHandler;

  static String APP_VERSION = 'APP_VERSION';
  static String localPath = '';

  static Future init(VoidCallback callback) async {
    if (Platform.isAndroid) {
      var dir = await getExternalStorageDirectory();
      Global.localPath = dir!.path;
    } else {
      var dir = await getApplicationDocumentsDirectory();
      Global.localPath = dir.path;
    }

    ///初始化sp数据
    await SpUtil.getInstance();
    LikeSong.loadCache();
    PlayHistory.loadCache();

    callback();
  }
}
