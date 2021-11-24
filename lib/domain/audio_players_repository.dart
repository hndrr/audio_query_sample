import 'package:audio_query_sample/domain/music_info.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioPlayersRepository {
  AudioPlayer audioPlayer = AudioPlayer();

  void initPlayer() {
    audioPlayer = AudioPlayer();
  }

  Future<void> playAudio(MusicInfo songlist) async {
    await audioPlayer.play(songlist.filePath!);
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
