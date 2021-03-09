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
  bool disposed = false;
  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
    disposed = true;
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    audioPlayer.onDurationChanged.listen((Duration d) {
      if (!disposed)
        setState(() {
          duration = d;
        });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration p) {
      if (!disposed)
        setState(() {
          position = p;
        });
    });
    audioPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      if (!disposed)
        setState(() {
          playerState = s;
          if (_isPlaying)
            _animationController.forward();
          else
            _animationController.reverse();
        });
    });
    audioPlayer.onPlayerError.listen((msg) {
      if (!disposed)
        setState(() {
          playerState = AudioPlayerState.STOPPED;
          duration = const Duration(seconds: 0);
          position = const Duration(seconds: 0);
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: ListTile(
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _animationController,
                size: 30,
              ),
              onPressed: _isPlaying
                  ? () => audioPlayer.pause()
                  : () => audioPlayer.play(widget.audio.url, stayAwake: true),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Slider(
                activeColor: Theme.of(context).primaryColorDark,
                inactiveColor: Theme.of(context).primaryColor,
                min: 0,
                max: duration?.inMilliseconds?.toDouble() ?? 0,
                value: position?.inMilliseconds?.toDouble() ?? 0,
                onChanged: (double value) async => await audioPlayer
                    .seek(Duration(milliseconds: value.toInt())),
              ),
            ),
          ],
        ),
        title: Container(
            transform: Matrix4.translationValues(0, 5, 0),
            child: Text(widget.audio.name)),
      ),
    );
  }
}
