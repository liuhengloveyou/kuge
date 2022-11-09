
import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';


// // NOTE: Your entrypoint MUST be a top-level function.
// void audioPlayerTaskEntrypoint() async {
//   AudioServiceBackground.run(() => AudioPlayerBackgroundTask());
// }

/// This task defines logic for playing a list of podcast episodes.
class AudioPlayerBackgroundTask extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  late AudioProcessingState _skipState;
  late StreamSubscription<PlaybackEvent> _eventSubscription;

  // 当前播放下标
  int _currentIndex = 0;
  int _tone = 1;
  int _playMode = 0;

  // @override
  // Future<void> onStart(Map<String, dynamic> params) async {
    // We configure the audio session for speech since we're playing a podcast.
    // You can also put this in your app's initialisation if your app doesn't
    // switch between two types of audio as this example does.
    // final session = await AudioSession.instance;
    // await session.configure(AudioSessionConfiguration.speech());
    // Broadcast media item changes.
    // _player.currentIndexStream.listen((index) {
    //   print("currentIndexStream>>>>>>$index");
    //   if (index != null) AudioServiceBackground.setMediaItem(queue[index]);
    // });
    // Propagate all events from the audio player to AudioService clients.
    // _eventSubscription = _player.playbackEventStream.listen((event) {
    //   _broadcastState();
    // });
    // // Special processing for state transitions.
    // _player.processingStateStream.listen((state) {
    //   switch (state) {
    //     case ProcessingState.completed:
    //       if (_playMode == PlayMode.single.index) {
    //         Future.delayed(const Duration(seconds: 1))
    //             .then((value) => onPlay());
    //       } else if (_playMode == PlayMode.sequence.index) {
    //         if (_currentIndex < AudioServiceBackground.queue.length - 1) {
    //           _currentIndex++;
    //           onPlay();
    //         }
    //       } else {
    //         _currentIndex =
    //             Random().nextInt(AudioServiceBackground.queue.length - 1);
    //         onPlay();
    //       }
    //       break;
    //     default:
    //       break;
    //   }
    // });

    // Load and broadcast the queue
    // AudioServiceBackground.setQueue(queue);
    // try {
    //   await _player.setAudioSource(ConcatenatingAudioSource(
    //     children:queue.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
    //   ));
    //   // In this example, we automatically start playing on start.
    //   // onPlay();
    // } catch (e) {
    //   print("Error: $e");
    // }
  // }

  // @override
  // Future<void> onSkipToQueueItem(String mediaId) async {
  //   // Then default implementations of onSkipToNext and onSkipToPrevious will
  //   // delegate to this method.
  //   final newIndex = queue.indexWhere((item) => item.id == mediaId);
  //   if (newIndex == -1) return;
  //   // During a skip, the player may enter the buffering state. We could just
  //   // propagate that state directly to AudioService clients but AudioService
  //   // has some more specific states we could use for skipping to next and
  //   // previous. This variable holds the preferred state to send instead of
  //   // buffering during a skip, and it is cleared as soon as the player exits
  //   // buffering (see the listener in onStart).
  //   _skipState = newIndex > index
  //       ? AudioProcessingState.skippingToNext
  //       : AudioProcessingState.skippingToPrevious;
  //   // This jumps to the beginning of the queue item at newIndex.
  //   _player.seek(Duration.zero, index: newIndex);
  // }

  @override
  Future onCustomAction(String name, arguments) async {
    switch (name) {
      case "getCurrentDuration":
        if (_player.duration != null) {
          return _player.duration!.inSeconds;
        }
        break;
      case "setCurrentIndex":
        _currentIndex = arguments;
        return _currentIndex;
      case "setTone":
        _tone = arguments;
        return _tone;
      case "setPlayMode":
        _playMode = arguments;
        return _playMode;
    }
    return null;
  }

  @override
  Future<void> onPlay() async {
    if (_player.processingState == ProcessingState.ready &&
        _player.position.inSeconds > 0 &&
        _player.duration != null &&
        _player.duration!.inSeconds > 0) {
      _player.play();
      return;
    }

    // if (AudioServiceBackground.queue == null ||
    //     AudioServiceBackground.queue.isEmpty) {
    //   return;
    // }
    // if (_currentIndex >= AudioServiceBackground.queue.length) {
    //   _currentIndex = AudioServiceBackground.queue.length - 1;
    // } else if (_currentIndex < 0) {
    //   _currentIndex = 0;
    // }

    // MediaItem task = AudioServiceBackground.queue[_currentIndex];
    // MusicModel music = MusicModel.fromJson(json.decode(task.extras["raw"]));
    // bool isLocal = false;
    // String url = getUrlByTone(music);

    // // 如果存在本地文件
    // if (music.loadlPath != "") {
    //   File file = File(music.loadlPath);
    //   if (file.existsSync()) {
    //     isLocal = true;
    //     url = music.loadlPath;
    //   }
    // }

    // if (isLocal) {
    //   await _player.setFilePath(url);
    // } else {
    //   await _player.setUrl(url);
    // }

    // AudioServiceBackground.setMediaItem(task);
    // await _player.play();
  }

  @override
  Future<void> onPause() async {
    await _player.pause();
  }

  @override
  Future<void> onSkipToNext() async {
    await _player.stop();
    Future.delayed(const Duration(milliseconds: 200)).then((value) => onPlay());
  }

  @override
  Future<void> onSkipToPrevious() async {
    await _player.stop();
    Future.delayed(const Duration(milliseconds: 200)).then((value) => onPlay());
  }

  // @override
  // Future<void> onSeekForward(bool begin) {
  //   print(">>>onSeekForward");
  // }

  @override
  Future<void> onClick(MediaButton button) async {
    print(">>>onClick$button");
    switch (button) {
      case MediaButton.next:
        _currentIndex++;
        await _player.stop();
        Future.delayed(const Duration(milliseconds: 200))
            .then((value) => onPlay());
        break;
      case MediaButton.previous:
        _currentIndex--;
        await _player.stop();
        Future.delayed(const Duration(milliseconds: 200))
            .then((value) => onPlay());
        break;
      default:
        break;
    }
  }

  @override
  Future<void> onSeekTo(Duration position) => _player.seek(position);

  @override
  Future<void> onStop() async {
    await _player.stop();
    // await _player.dispose();
    // _eventSubscription.cancel();
    // // It is important to wait for this state to be broadcast before we shut
    // // down the task. If we don't, the background task will be destroyed before
    // // the message gets sent to the UI.
    // await _broadcastState();
    // // Shut down this task
    // await super.onStop();
  }

  @override
  Future<void> onUpdateQueue(List<MediaItem> queue) async {
    // await _player.stop();
    // await AudioServiceBackground.setQueue(queue);
    // _currentIndex = 0;
  }

  // @override
  // Future<void> onFastForward() => _seekRelative(fastForwardInterval);

  // @override
  // Future<void> onRewind() => _seekRelative(-rewindInterval);

  /// Jumps away from the current position by [offset].
  Future<void> _seekRelative(Duration offset) async {
    var newPosition = _player.position + offset;
    // Make sure we don't jump out of bounds.
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    // if (newPosition > mediaItem.duration) newPosition = mediaItem.duration;
    // Perform the jump via a seek.
    await _player.seek(newPosition);
  }

  /// Broadcasts the current state to all clients.
  // Future<void> _broadcastState() async {
  //   await AudioServiceBackground.setState(
  //     controls: [
  //       MediaControl.skipToPrevious,
  //       if (_player.playing) MediaControl.pause else MediaControl.play,
  //       MediaControl.stop,
  //       MediaControl.skipToNext,
  //     ],
  //     systemActions: [
  //       MediaAction.seekTo,
  //       MediaAction.seekForward,
  //       MediaAction.seekBackward,
  //     ],
  //     androidCompactActions: [0, 1, 3],
  //     processingState: _getProcessingState(),
  //     playing: _player.playing,
  //     position: _player.position,
  //     bufferedPosition: _player.bufferedPosition,
  //     speed: _player.speed,
  //   );
  // }

  /// Maps just_audio's processing state into into audio_service's playing
  /// state. If we are in the middle of a skip, we use [_skipState] instead.
  // AudioProcessingState _getProcessingState() {
  //   return _skipState;
  //   switch (_player.processingState) {
  //     case ProcessingState.idle:
  //       return AudioProcessingState.stopped;
  //     case ProcessingState.loading:
  //       return AudioProcessingState.connecting;
  //     case ProcessingState.buffering:
  //       return AudioProcessingState.buffering;
  //     case ProcessingState.ready:
  //       return AudioProcessingState.ready;
  //     case ProcessingState.completed:
  //       return AudioProcessingState.completed;
  //     default:
  //       throw Exception("Invalid state: ${_player.processingState}");
  //   }
  // }

  // getUrlByTone(MusicModel music) {
  //   List<String> toneStrs = ["bq", "hq", "sq"];

  //   for (var i = _tone - 1; i >= 0; i--) {
  //     if (music.urls[toneStrs[i]] != null &&
  //         music.urls[toneStrs[i]].url != "") {
  //       return music.urls[toneStrs[i]].url;
  //     }
  //   }

  //   return "";
  // }
}
