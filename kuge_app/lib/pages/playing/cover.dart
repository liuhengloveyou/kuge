import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kuge_app/model/music.model.dart';


///播放页面歌曲封面
class AlbumCover extends StatefulWidget {
  final MusicModel music;

  const AlbumCover({Key? key, required this.music}) : super(key: key);

  @override
  State createState() => _AlbumCoverState();
}

class _AlbumCoverState extends State<AlbumCover> with TickerProviderStateMixin {
  //cover needle controller
  late AnimationController _needleController;

  //cover needle in and out animation
  late Animation<double> _needleAnimation;

  ///music change transition animation;
  late AnimationController _translateController;

  bool _needleAttachCover = false;

  bool _coverRotating = false;

  ///专辑封面X偏移量
  ///[-screenWidth/2,screenWidth/2]
  /// 0 表示当前播放音乐封面
  /// -screenWidth/2 - 0 表示向左滑动 |_coverTranslateX| 距离，即滑动显示后一首歌曲的封面
  double _coverTranslateX = 0;

  final bool _beDragging = false;

  bool _previousNextDirty = true;

  ///滑动切换音乐效果上一个封面
  MusicModel? _previous;

  ///当前播放中的音乐
  MusicModel? _current;

  ///滑动切换音乐效果下一个封面
   MusicModel? _next;

  // MusicPlayer _player;

  @override
  void initState() {
    super.initState();

    // _player = context.player;
    // _needleAttachCover = _player.playbackState.isPlaying;
    _needleController = AnimationController(
        /*preset need position*/
        value: _needleAttachCover ? 1.0 : 0.0,
        vsync: this,
        duration: const Duration(milliseconds: 500),
        animationBehavior: AnimationBehavior.normal);
    _needleAnimation =
        Tween<double>(begin: -1 / 12, end: 0).chain(CurveTween(curve: Curves.easeInOut)).animate(_needleController);

    _current = widget.music;
    _invalidatePn();
    // _player.addListener(_checkNeedleAndCoverStatus);
    _checkNeedleAndCoverStatus();
  }

  /// invalidate previous and next music cover...
  /// TODO should invalidate on playMode change.
  void _invalidatePn() async {
    if (!_previousNextDirty) {
      return;
    }
    _previousNextDirty = false;
    // _previous = (await _player.getPreviousMusic(_current.metadata)).toMusic();
    // _next = (await _player.getNextMusic(_current.metadata)).toMusic();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(AlbumCover oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_current == widget.music) {
      _invalidatePn();
      return;
    }
    double offset = 0;
    if (widget.music == _previous) {
      offset = MediaQuery.of(context).size.width;
    } else if (widget.music == _next) {
      offset = -MediaQuery.of(context).size.width;
    }
    _animateCoverTranslateTo(offset, onCompleted: () {
      setState(() {
        _coverTranslateX = 0;
        _current = widget.music;
        _invalidatePn();
      });
    });
  }

  // update needle and cover for current player state
  void _checkNeedleAndCoverStatus() {
    // final state = _player.playbackState;

    // needle is should attach to cover
    // bool attachToCover = state.isPlaying && !_beDragging && _translateController == null;
    // _rotateNeedle(attachToCover);

    //handle album cover animation
    // var _isPlaying = state.isPlaying;
    setState(() {
      _coverRotating = true; // _isPlaying && _needleAttachCover;
    });
  }

  ///rotate needle to (un)attach to cover image
  void _rotateNeedle(bool attachToCover) {
    if (_needleAttachCover == attachToCover) {
      return;
    }
    _needleAttachCover = attachToCover;
    if (attachToCover) {
      _needleController.forward(from: _needleController.value);
    } else {
      _needleController.reverse(from: _needleController.value);
    }
  }

  @override
  void dispose() {
    // _player.removeListener(_checkNeedleAndCoverStatus);
    _needleController.dispose();
    _translateController.dispose();

    super.dispose();
  }

  void _animateCoverTranslateTo(double des, {required void Function() onCompleted}) {
    _translateController.dispose();
    _translateController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    final animation = Tween(begin: _coverTranslateX, end: des).animate(_translateController);
    animation.addListener(() {
      setState(() {
        _coverTranslateX = animation.value;
      });
    });
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _translateController.dispose();
        onCompleted();
      }
    });
    _translateController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ClipRect(child: Padding(
        padding: const EdgeInsets.only(bottom: 10, top: 10),
        child: _build(context, constraints.maxWidth),
      ));
    });
  }

  Widget _build(BuildContext context, double layoutWidth) {
    return Stack(
      alignment: Alignment.center, 
      children: <Widget>[
        const SizedBox(height: 190.0,
          width: 190.0,child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(180)),
          child: FadeInImage(
            placeholder: AssetImage("assets/images/gg.png"),
            image: AssetImage('assets/images/gg.png'),
            fit: BoxFit.cover)),
        ),
        GestureDetector(
          // onHorizontalDragStart: (detail) {
          //   _beDragging = true;
          //   _checkNeedleAndCoverStatus();
          // },
          // onHorizontalDragUpdate: (detail) {
          //   if (_beDragging) {
          //     setState(() {
          //       _coverTranslateX += detail.primaryDelta;
          //     });
          //   }
          // },
          // onHorizontalDragEnd: (detail) {
          //   _beDragging = false;

          //   //左右切换封面滚动速度阈值
          //   final vThreshold = 1.0 / (0.050 * MediaQuery.of(context).devicePixelRatio);

          //   final sameDirection = (_coverTranslateX > 0 && detail.primaryVelocity > 0) ||
          //       (_coverTranslateX < 0 && detail.primaryVelocity < 0);
          //   if (_coverTranslateX.abs() > layoutWidth / 2 ||
          //       (sameDirection && detail.primaryVelocity.abs() > vThreshold)) {
          //     var des = MediaQuery.of(context).size.width;
          //     if (_coverTranslateX < 0) {
          //       des = -des;
          //     }
          //     _animateCoverTranslateTo(des, onCompleted: () {
          //       setState(() {
          //         //reset translateX to 0 when animation complete
          //         _coverTranslateX = 0;
          //         if (des > 0) {
          //           _current = _previous;
          //           // context.transportControls.skipToPrevious();
          //         } else {
          //           _current = _next;
          //           // context.transportControls.skipToNext();
          //         }
          //         _previousNextDirty = true;
          //       });
          //     });
          //   } else {
          //     //animate [_coverTranslateX] to 0
          //     _animateCoverTranslateTo(0, onCompleted: () {
          //       _checkNeedleAndCoverStatus();
          //     });
          //   }
          // },
          child: Container(
              color: Colors.transparent,
              padding: const EdgeInsets.only(left: 60, right: 60),
              child: Stack(
                children: <Widget>[
                  Transform.scale(
                    scale: 1.035,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipOval(
                        child: Container(
                          color: Colors.white10,
                        ),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(_coverTranslateX - layoutWidth, 0),
                    child: _RotationCoverImage(rotating: false, music: _previous!),
                  ),
                  Transform.translate(
                    offset: Offset(_coverTranslateX, 0),
                    child: _RotationCoverImage(rotating: _coverRotating && !_beDragging, music: _current!),
                  ),
                  Transform.translate(
                    offset: Offset(_coverTranslateX + layoutWidth, 0),
                    child: _RotationCoverImage(rotating: false, music: _next!),
                  ),
                ],
              )),
        )
      ],
    );
  }
}

class _RotationCoverImage extends StatefulWidget {
  final bool rotating;
  final MusicModel music;

  const _RotationCoverImage({Key? key, required this.rotating, required this.music})
      : super(key: key);

  @override
  _RotationCoverImageState createState() => _RotationCoverImageState();
}

class _RotationCoverImageState extends State<_RotationCoverImage> with SingleTickerProviderStateMixin {
  //album cover rotation
  double rotation = 0;

  //album cover rotation animation
  late AnimationController controller;

  @override
  void didUpdateWidget(_RotationCoverImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.rotating) {
      controller.forward(from: controller.value);
    } else {
      controller.stop();
    }
    if (widget.music != oldWidget.music) {
      controller.value = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 20), animationBehavior: AnimationBehavior.normal)
          ..addListener(() {
            setState(() {
              rotation = controller.value * 2 * pi;
            });
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed && controller.value == 1) {
              controller.forward(from: 0);
            }
          });
    if (widget.rotating) {
      controller.forward(from: controller.value);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image;
    if (widget.music.picUrl == null) {
      image = const AssetImage("assets/images/play/disc.png");
    } else {
      image = CachedNetworkImageProvider(widget.music.picUrl.toString());
    }
    return Transform.rotate(
      angle: rotation,
      child: Material(
        elevation: 3,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(500),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(20),
            foregroundDecoration:const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/play/disc.png"))),
            child: ClipOval(
              child: Image(image: image, fit: BoxFit.fill),
            ),
          ),
        ),
      ),
    );
  }
}
