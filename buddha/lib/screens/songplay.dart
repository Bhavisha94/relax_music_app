// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class SongPlay extends StatefulWidget {
  bool play;
  String song;
  int index;
  SongPlay(this.play, this.song, this.index, {super.key});

  @override
  State<SongPlay> createState() => _SongPlayState();
}

class _SongPlayState extends State<SongPlay> {
  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        setState(() {
          widget.play = !widget.play;
        });
        // widget.player.setUrl(widget.song);
        // widget.player.play();
        await player.setUrl(widget.song);
        player.play();
      },
      child: widget.play ? const Icon(Icons.close) : const Icon(Icons.check),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
