import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../providers/place.dart';

class AudioWidget extends StatefulWidget {
  AudioWidget(this.audio);
  final Media audio;
  @override
  _AudioWidgetState createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();

  Duration duration;
  Duration position;
  AudioPlayerState playerState;

  bool get _isPlaying => playerState == AudioPlayerState.PLAYING;

  AnimationController _animationController;

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    audioPlayer.onDurationChanged.listen((Duration d) {
      print('Max duration: $d');
      setState(() {
        duration = d;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() {
        position = p;
      });
    });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      print('Current player state: $s');
      setState(() {
        playerState = s;
        if (_isPlaying)
          _animationController.forward();
        else
          _animationController.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _animationController,
              ),
              onPressed: _isPlaying
                  ? () => audioPlayer.pause()
                  : () => audioPlayer.play(widget.audio.url, stayAwake: true),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Slider(
                min: 0,
                max: duration?.inMilliseconds?.toDouble() ?? 0,
                value: position?.inMilliseconds?.toDouble() ?? 0,
                onChanged: (double value) async => await audioPlayer
                    .seek(Duration(milliseconds: value.toInt())),
              ),
            ),
          ],
        ),
        title: Text(widget.audio.name),
      ),
    );
  }
}
