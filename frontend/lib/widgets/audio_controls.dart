import 'package:flutter/material.dart';

class AudioControls extends StatelessWidget {
  final VoidCallback onPlay;
  final VoidCallback onPause;
  final VoidCallback onStop;
  final bool isPlaying;

  const AudioControls({
    Key? key,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    required this.isPlaying,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPlay,
          icon: const Icon(Icons.play_arrow),
          color: Colors.green,
          iconSize: 32,
          tooltip: 'Play',
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: onPause,
          icon: const Icon(Icons.pause),
          color: Colors.blue,
          iconSize: 32,
          tooltip: 'Pause',
        ),
        const SizedBox(width: 16),
        IconButton(
          onPressed: onStop,
          icon: const Icon(Icons.stop),
          color: Colors.red,
          iconSize: 32,
          tooltip: 'Stop',
        ),
      ],
    );
  }
}
