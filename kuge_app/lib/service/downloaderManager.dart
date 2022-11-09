import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';

class DownloaderManager {
  static DownloaderManager? _completer;

  String _localPath = "";
   Database? _db;
   StoreRef? _store;

  DownloaderManager._internal();

  static DownloaderManager getInstance() {
    _completer ??= DownloaderManager._internal();

    return _completer!;
  }

  prepare(BuildContext context) async {
    if (_localPath != "") {
      return;
    }

    final permiss = await _checkPermissFunction(context);
    if (false == permiss) {
      print("!!!!!!!!!!!!!!!!!!!!!!!!down permiss err.");
      showToast("下载需要存储权限");
      return null;
    }

    // 获取存储路径
    if (_localPath == "") {
      _localPath = await getPhoneLocalPath(context);
      final savedDir = Directory(_localPath);
      // 判断下载路径是否存在
      bool hasExisted = savedDir.existsSync();
      // 不存在就新建路径
      if (!hasExisted) {
        savedDir.createSync(recursive: true);
      }
    }

    _db = await databaseFactoryIo.openDatabase(join(_localPath, 'meta.db'));
    _store = intMapStoreFactory.store('downloadFiles');

    FlutterDownloader.registerCallback(DownloaderManager.downloadCallback);
  }

  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  download(BuildContext context, String downloadUrl, String fileName, Map<String, dynamic> meta) async {
    if (null == _db) {
      return -1;
    }

    if (downloadUrl == "" || fileName == "") {
      return -3;
    }

    // 去重
    var records = await _store!.findFirst(_db!, finder: Finder(filter: Filter.equals("meta.id", meta['id'])));
    if (records != null) {
      return -2;
    }

    final taskID = await _downloadFile(downloadUrl, _localPath, fileName);

    var taskInfo = DownloadTaskInfo();
    taskInfo.meta = meta;
    taskInfo.taskId = taskID;
    taskInfo.name = fileName;
    taskInfo.link = downloadUrl;

    final key = await _store!.add(_db!, taskInfo.toJson());
    print("download: $key $downloadUrl $_localPath ${taskInfo.toJson()}");
  }

  void retryDownload(DownloadTaskInfo task) async {
    try {
      await FlutterDownloader.remove(taskId: task.taskId);
    } catch (e) {
      print("FlutterDownloader.remove ERR $e");
    }

    try {
      await _store!.record(task.dbKey).delete(_db!);      
    } catch (e) {
      print("store.delete ERR $e");
    }
    
    task.taskId = await _downloadFile(task.link, _localPath, task.name);

    final key = await _store!.record(task.dbKey).put(_db!, task.toJson());
    print(":::retryDownload: key:$key; taskid: ${task.taskId}; ${task.toJson()}");
  }

  // 根据 downloadUrl 和 savePath 下载文件
  _downloadFile(String downloadUrl, String saveDir, String fileName) async {
    // TODO
    // downloadUrl = "http://music.alokuge.com/public/music/60075021223-SQ.flac";
    // downloadUrl = 'http://tyst.migu.cn/public/product8th/product40/2020/05/2600/2020%E5%B9%B405%E6%9C%8825%E6%97%A518%E7%82%B902%E5%88%86%E7%B4%A7%E6%80%A5%E5%86%85%E5%AE%B9%E5%87%86%E5%85%A5%E5%8D%8E%E7%BA%B36%E9%A6%96289273/%E6%AD%8C%E6%9B%B2%E4%B8%8B%E8%BD%BD/MP3_40_16_Stero/6005752DXKE004545.mp3';

    return await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: saveDir,
      fileName: fileName,
      showNotification: true, // show download progress in status bar (for Android)
      openFileFromNotification: false, // click on notification to open downloaded file (for Android)
    );
  }

  downloadTasks() async {
    print("!!!_localPath:$_localPath; _db:$_db");
    if (null == _db) {
      return [];
    }

    final tasks = await FlutterDownloader.loadTasks(); // 下载任务
    
    var records = await _store!.find(_db!);
    return records.cast<RecordSnapshot>().map((e) {
      var taskInfo = DownloadTaskInfo.fromJson(e.value);
      taskInfo!.dbKey = e.key;

      for (var task in tasks!) {
        if (taskInfo.taskId == task.taskId) {
          taskInfo.timeCreated = task.timeCreated;
          taskInfo.status = task.status;
          taskInfo.progress = task.progress;
        }
      }
      
      return taskInfo;
    }).toList();
  }

  deleteDownloadFile(DownloadTaskInfo taskInfo) async {
    // 删除数据库记录
    await _store!.record(taskInfo.dbKey).delete(_db!);

    // 删除下载任务
    try {
      await FlutterDownloader.remove(taskId: taskInfo.taskId, shouldDeleteContent: true);  
    } catch (e) {
      print("$e");
    }

    // 删除文件
    try {
      File file = File("$_localPath${taskInfo.name}");
      file.deleteSync();    
    } catch (e) {
      print("$e");
    }
  }

  ///获取手机的存储目录路径
  /// getExternalStorageDirectory() 获取的是  android 的外部存储 （External Storage）
  /// getApplicationDocumentsDirectory 获取的是 ios 的Documents` or `Downloads` 目录
  static Future<String> getPhoneLocalPath(BuildContext context) async {
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return '${directory!.path}/Downloads/';
  }

  ///PermissionGroup.storage 对应的是
  ///android 的外部存储 （External Storage）
  ///ios 的Documents` or `Downloads`
  static _checkPermissFunction(BuildContext context) async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      var status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        return true;
      }
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      var status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        return true;
      }
    }

    return true;
  }

}

// 下载任务结构
class DownloadTaskInfo {
  String taskId = "";
  String name = "";
  String link = "";
  int dbKey = -1;

  Map<String, dynamic> meta = {};
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
  int timeCreated = -1;

  get getStatuIcon {
    if (status == DownloadTaskStatus.running || status == DownloadTaskStatus.complete) {
      return null;
    } else if (status == DownloadTaskStatus.enqueued) {
      return Icons.hourglass_bottom_rounded;
    } else if (status == DownloadTaskStatus.failed || status == DownloadTaskStatus.undefined || status == DownloadTaskStatus.paused || status == DownloadTaskStatus.canceled) {
      return Icons.file_download;
    } 
  }

  static DownloadTaskInfo? fromJson(Map map) {
    if (!map.containsKey("meta")) {
      return null;
    }

    var task = DownloadTaskInfo();
    task.taskId = map['taskId'];
    task.dbKey = map['dbKey'];
    task.name = map['name'];
    task.link = map['link'];
    task.meta = map['meta'];

    return task;
  }

  Map toJson() {
    return {
      "taskId": taskId,
      "name": name,
      "link": link,
      "timeCreated": timeCreated,
      "meta": meta,
    };
  }
}
