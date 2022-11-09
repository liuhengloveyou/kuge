import 'package:flutter/foundation.dart';

import 'package:sp_util/sp_util.dart';
import 'package:audio_service/audio_service.dart';

import 'package:kuge_app/service/play_history.service.dart';
import 'package:kuge_app/audio_player/play_mode.dart';
import 'package:kuge_app/audio_player/tone_option.dart';
import 'package:kuge_app/model/music.model.dart';

class KugeAudioPlayer with ChangeNotifier, DiagnosticableTreeMixin {
  final playingListCacheKey = "playingListCacheKey";
  final currentPlayingIndexCacheKey = "currentPlayingIndexCacheKey";

  static KugeAudioPlayer? _instance;

  // 音质选择
  late ToneOption tone;
  // 播放模式
  late PlayMode playMode;

  List<MusicModel> _songList = [];
  int currentIndex = 0;

  int curPosition = 0;
  int curDuration = 0;
  int processingState = 0; // stop: 0; playing :1;  2: buffing..

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  KugeAudioPlayer._internal() {
    // 加载currentIndex
    // currentIndex = SpUtil.getInt(currentPlayingIndexCacheKey)!;
    // final cacheSongList = SpUtil.getObjectList(playingListCacheKey);
    // if (null != cacheSongList) {
    //   for (var value in cacheSongList) {
    //     _songList.add(MusicModel.fromJson(value));
    //   }
    // }

    // 加载playmode
    playMode = PlayMode(SpUtil.getInt("playMode")!);
    // AudioService.customAction("setPlayMode", playMode);
    // AudioHandler.customAction("setPlayMode", playMode.index);

    // 加载playtone
    int playToneVal = SpUtil.getInt("playTone")!;
    if (playToneVal <= ToneOption.standard.index ||
        playToneVal > ToneOption.lossless.index) {
      playToneVal = ToneOption.standard.index;
    }
    tone = ToneOption(playToneVal);

    // Listen to changes to the current playback position:
    // AudioService.positionStream.listen((Duration position) async {
    //   if (position == null) {
    //     return;
    //   }

    //   if (position.inSeconds > 0 && position.inSeconds <= 2) {
    //     curDuration = await AudioService.customAction("getCurrentDuration", 0);
    //   }
    //   if (position.inSeconds != curPosition) {
    //     curPosition = position.inSeconds;

    //     notifyListeners();
    //   }
    // });

    // Listen to changes to the currently playing item:
    // AudioService.currentMediaItemStream.listen((MediaItem item) {
    //   // printpp(">>>>>currentMediaItemStream: ${item.id}");
    //   if (item == null) {
    //     return;
    //   }
    //   for (int i = 0; i < _songList.length; i++) {
    //     if (item.id == _songList[i].dataId) {
    //       setCurrentIndex(i);
    //       break;
    //     }
    //   }
    //   notifyListeners();
    // });

    // Listening to state changes
    // AudioService.playbackStateStream.listen((PlaybackState state) {
    //   if (state == null) {
    //     return;
    //   }
    //   // print(">>>>>>playbackStateStream: ${state.playing} ${state.processingState.toString()}");
    //   switch (state.processingState) {
    //     case AudioProcessingState.connecting:
    //     case AudioProcessingState.buffering:
    //       processingState = 2;
    //       notifyListeners();
    //       break;
    //     case AudioProcessingState.ready:
    //       if (state.playing) {
    //         processingState = 1;
    //       } else {
    //         processingState = 0;
    //       }

    //       notifyListeners();
    //       break;
    //     case AudioProcessingState.skippingToPrevious:
    //     case AudioProcessingState.skippingToNext:
    //     case AudioProcessingState.skippingToQueueItem:
    //       break;
    //     case AudioProcessingState.stopped:
    //     case AudioProcessingState.error:
    //       processingState = 0;
    //       curDuration = 0;
    //       curDuration = 0;
    //       notifyListeners();
    //       break;
    //     case AudioProcessingState.completed:
    //       processingState = 0;
    //       curDuration = 0;
    //       curDuration = 0;

    //       // // 自动播放下一首
    //       // if (playMode == PlayMode.single) {
    //       //   // 音曲循环
    //       //   play(null);
    //       // } else if (playMode == PlayMode.sequence) {
    //       //   // 列表循环
    //       //   next(1);
    //       // } else {
    //       //   // 随机
    //       //   playAt(Random().nextInt(_songList.length - 1));
    //       // }
    //       break;
    //     default:
    //       return;
    //   }
    // });
  }
  static KugeAudioPlayer _getInstance() {
    _instance ??= KugeAudioPlayer._internal();
    return _instance!;
  }

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory KugeAudioPlayer.getInstance() => _getInstance();

  play(MusicModel? music) async {
    int index = await add(music);
    if (index < 0) {
      return -1; // 播放列表空
    }

    // await AudioService.updateQueue(mediaItems);
    // await setCurrentIndex(index);

    // if (AudioService.playbackState.processingState == AudioProcessingState.ready && curDuration > 0 && curPosition > 0) {
    //   AudioService.play();
    // } else {
    //   // await AudioService.updateQueue(mediaItems);
    //   // await AudioService.customAction("setCurrentIndex", currentIndex);
    //   AudioService.play();
    // }

    // 更新播放历史
    PlayHistory.add(music);
    notifyListeners();
    return;
  }

  playMusicList(List<MusicModel> musics) async {
    await addMusicList(musics);
    // if (queueLength <= 0) {
    //   return;
    // }

    play(_songList[0]);
  }

  pause() => AudioService.pause();
  seek(Duration position) => AudioService.seekTo(position);

  next(int direction) async {
    final m = await nextMusic(direction);
    if (direction > 0) {
      AudioService.skipToNext();
    } else {
      AudioService.skipToPrevious();
    }
    
    notifyListeners();
  }

  setPlayMode() async {
    playMode = playMode.next;
    await SpUtil.putInt('playMode', playMode.index);
    // await AudioService.customAction("setPlayMode", playMode.index);
    notifyListeners();
  }

  setPlayTone(ToneOption newTone) async {
    tone = newTone;
    await SpUtil.putInt('playTone', tone.index);
    // AudioService.customAction("setTone", tone.index);
    notifyListeners();
  }

  /////////////////////////////////////////////////////////////////////////////
  /// AudioMediaLibrary
  /////////////////////////////////////////////////////////////////////////////
  int get queueLength => _songList.length;
  // List<MediaItem> get mediaItems => _songList
  //     .cast<MusicModel>()
  //     .map((e) => MediaItem(
  //         id: e.dataId,
  //         album: e.albumName,
  //         title: e.name,
  //         artist: e.singerName,
  //         artUri: e.picUrl,
  //         extras: {"raw": json.encode(e.toJson())}))
  //     .toList();

  // setCurrentIndex(int value) async {
  //   currentIndex = value;
  //   await AudioService.customAction("setCurrentIndex", currentIndex);
  //   await SpUtil.putInt(currentPlayingIndexCacheKey, currentIndex);
  // }

  // 添加到播放列表
  add(MusicModel? music) async {
    if (music == null) {
      return -1;
    }
    if (music.getTitle!.isEmpty) {
      return -1;
    }

    // 去重
    for (int i = 0; i < _songList.length; i++) {
      if (_songList[i].id == music.id) {
        return i;
      }
    }

    _songList.insert(0, music);
    await SpUtil.putObjectList(playingListCacheKey, _songList);
    // await setCurrentIndex(0);

    return currentIndex;
  }

  addMusicList(List<MusicModel> musics) async {
    _songList = [];
    for (int i = musics.length-1; i >= 0; i--) {
      add(musics[i]);
    }
  }

  MusicModel? currentMusic() {
    if (_songList.isEmpty || _songList.isEmpty) {
      return null;
    }

    if (currentIndex < 0 || currentIndex >= _songList.length) {
      currentIndex = 0;
    }

    return _songList[currentIndex];
  }

  Future<MusicModel?> nextMusic(int direction) async {
    if (_songList.isEmpty || _songList.isEmpty) {
      return null;
    }

    currentIndex += direction;
    if (currentIndex >= _songList.length) {
      currentIndex = _songList.length - 1;
    } else if (currentIndex < 0) {
      currentIndex = 0;
    }
    // setCurrentIndex(currentIndex);

    return _songList[currentIndex];
  }

  MusicModel? musicAt(int index) {
    if (currentIndex < 0 || currentIndex >= _songList.length) {
      return null;
    }

    return _songList[index];
  }

  removeAt(int index) async {
    _songList.removeAt(index);
    await SpUtil.putObjectList(playingListCacheKey, _songList);
    // await AudioService.updateQueue(mediaItems);

    if (currentIndex < 0 || currentIndex >= _songList.length) {
      // await setCurrentIndex(0);
    }

    notifyListeners();
  }

  cleanQueue() async {
    _songList.clear();
    await SpUtil.remove(playingListCacheKey);
    // await setCurrentIndex(0);
    // await AudioService.updateQueue([]);
    // await AudioService.customAction("setCurrentIndex", 0);

    notifyListeners();
  }
}
