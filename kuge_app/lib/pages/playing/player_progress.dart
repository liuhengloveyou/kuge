import 'package:flutter/material.dart';
import 'package:kuge_app/audio_player/audioPlayer.dart';
import 'package:kuge_app/utils/time.dart';
import 'package:provider/provider.dart';

/// A seek bar for current position.
class DurationProgressBar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DurationProgressBarState();
}

class DurationProgressBarState extends State<DurationProgressBar> {
  double currPosition = 0;
  double currDuration = 0;
  double trackingPosition = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {    
    KugeAudioPlayer player = context.watch<KugeAudioPlayer>();
    if (player.curDuration != null && player.curPosition != null) {
      currPosition = player.curPosition.toDouble();
      currDuration = player.curDuration.toDouble();  
    }     

    double curValue = trackingPosition > 0 ? trackingPosition : currPosition.toDouble();
    if (curValue < 0) {
      curValue = 0;
    } else if (curValue > currDuration.toDouble()) {
      curValue = currDuration.toDouble();
    } 

    Widget progressIndicator = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        Slider(
          value: curValue,
          min: 0.0,
          max: currDuration.toDouble(),
          activeColor: Colors.white.withOpacity(0.75),
          inactiveColor: Colors.white.withOpacity(0.3),
          onChangeStart: (value) {
            setState(() {
              trackingPosition = value;
            });
          },
          onChanged: (value) {         
            setState(() {
              trackingPosition = value;
            });
          },
          onChangeEnd: (value) async {
            player.seek(Duration(seconds: value.toInt()));
            setState(() {
              trackingPosition = -1;
            });
          },
        ),
      ],
    );

    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 1,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7)
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Text(getTimeStamp(currPosition.toInt() * 1000), style: TextStyle(color: Colors.white)),
            Padding(padding: EdgeInsets.only(left: 4)),
            Expanded(child: progressIndicator),
            Padding(padding: EdgeInsets.only(left: 4)),
            Text(getTimeStamp(currDuration.toInt() * 1000), style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
