import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayersRepository {
  AudioPlayer audioPlayer = AudioPlayer();

  void initPlayer() {
    audioPlayer = AudioPlayer();

    // audioPlayer.durationHandler = (d) => setState(
    //       () {
    //         _duration = d;
    //       },
    //     );
    // audioPlayer.positionHandler = (p) => setState(
    //       () {
    //         _position = p;
    //       },
    //     );
  }

  Future<void> playAudio(AsyncSnapshot<List<SongModel>> item, int index) async {
    await audioPlayer.play(
      Platform.isAndroid ? item.data![index].data : item.data![index].uri!,
    );
  }

  void seekToSecond(int second) {
    final newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  Future<void> pauseAudio() async {
    final response = await audioPlayer.pause();
    if (response == 1) {
      // success

    } else {
      // ignore: avoid_print
      print('Some error occured in pausing');
    }
  }

  Future<void> stopAudio() async {
    final response = await audioPlayer.stop();
    if (response == 1) {
      // success

    } else {
      // ignore: avoid_print
      print('Some error occured in stopping');
    }
  }

  Future<void> resumeAudio() async {
    final response = await audioPlayer.resume();
    if (response == 1) {
      // success

    } else {
      // ignore: avoid_print
      print('Some error occured in resuming');
    }
  }
}
