import 'dart:isolate';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/audio_player/bottomPlayerBar.dart';
import 'package:kuge_app/model/music.model.dart';
import 'package:kuge_app/service/downloaderManager.dart';
import 'package:provider/provider.dart';

class DownLoadMangerPage extends StatefulWidget with WidgetsBindingObserver {
  late final TargetPlatform platform;

  @override
  _DownLoadMangerPageState createState() => _DownLoadMangerPageState();
}

class _DownLoadMangerPageState extends State<DownLoadMangerPage> {
  List _tasks = [];
  bool _isLoading = false;
  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');

    _registerCallback();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  _registerCallback() async {
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      final task = _tasks.firstWhere((task) => task.taskId == id);
      if (task != null) {
        if (status == DownloadTaskStatus.failed) {
          showToast("<${task.meta['name']}> 下载出错", position: StyledToastPosition.center);
        }

        setState(() {
          task.status = status;
          task.progress = progress;
        });
      }
    });

    await _loadDownTasks();

    FlutterDownloader.registerCallback(DownloaderManager.downloadCallback);
  }

  _loadDownTasks() async {
    if (_isLoading == true) {
      return null;
    }
    _isLoading = true;

    _tasks = await DownloaderManager.getInstance().downloadTasks();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.platform = Theme.of(context).platform;

    return Scaffold(
      appBar: AppBar(
        title: const Text("本地音乐"),
        elevation: 0,
      ),
      body: Builder(builder: (context) {
        if (_isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          children: _tasks.map((item) {
            MusicModel music = MusicModel.fromJson(item.meta);
            return item.taskId == null
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                          fontSize: 18.0),
                    ),
                  )
                : InkWell(
                    onTap: () async {
                      MusicModel music = MusicModel.fromJson(item.meta);
                      String path =
                          await DownloaderManager.getPhoneLocalPath(context);
                      String? name = music.downloadName;
                      music.loadlPath = "$path$name";
                      await context.read<KugeAudioPlayer>().play(music);
                    },
                    child: ListTile(
                        leading: Stack(alignment: Alignment.center, children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(Radius.circular(30)),
                            child: FadeInImage(
                              placeholder: const AssetImage("assets/images/song.png"),
                              image: CachedNetworkImageProvider(music.picUrl!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          (item.status == DownloadTaskStatus.running ||
                                  item.status == DownloadTaskStatus.enqueued)
                              ? SizedBox(
                                  height: 56.0,
                                  width: 56.0,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      value: (item.progress + 1) / 100, //0~1的浮点数，用来表示进度多少;如果 value 为 null 或空，则显示一个动画，否则显示一个定值
                                      backgroundColor: Colors.grey[200],
                                      valueColor:const AlwaysStoppedAnimation<Color>(Colors.red)))
                              : const SizedBox(width: 0, height: 0),
                          IconButton(
                            icon:Icon(item.getStatuIcon, color: Colors.white70),
                            onPressed: () => DownloaderManager.getInstance().retryDownload(item),
                          )
                        ]),
                        title: Text(music.name!),
                        subtitle: Text("${music.subTitle}"),
                        trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              DownloaderManager.getInstance().deleteDownloadFile(item);
                              _loadDownTasks();
                            })));
          }).toList(),
        );
      }),
      bottomNavigationBar: BottomControllerBar(),
    );
  }
}
