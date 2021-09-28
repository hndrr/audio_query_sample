import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumListModel extends ChangeNotifier {
  // List<MusicInfo> _viewList = <MusicInfo>[];
  // List<MusicInfo> get viewList => _viewList;

  List<SongModel> _albumList = <SongModel>[];
  List<SongModel> get albumList => _albumList;

  // List<SongInfo> _songList = <SongInfo>[];
  // List<SongInfo> get songList => _songList;

  // List<MusicInfo> _viewSongList = <MusicInfo>[];
  // List<MusicInfo> get viewSongList => _viewSongList;

  OnAudioQuery audioQuery = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();

  bool isLoading = false;
  bool isPlaying = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  void startPlaying() {
    isPlaying = true;
    notifyListeners();
  }

  void pausePlaying() {
    isPlaying = false;
    notifyListeners();
  }

  Future<void> init() async {
    startLoading();
    if (Platform.isAndroid) {
      debugPrint('AlbumListModel: called init()');
      requestPermission();
      initPlayer();

      // _albumList = await _audioQueryRepository.fetchLocalAlbum();
      // _albumList = await getAlbum();
      // _viewList =
      //     _audioQueryRepository.toMusicInfoListFromAlbumList(_albumList);
    }
    endLoading();
    notifyListeners();
  }

  dynamic requestPermission() async {
    final permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    // setState(() {
    //   //
    // });
  }

  Future<List<SongModel>> getAlbum() async {
    return OnAudioQuery().querySongs(
      sortType: SongSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
  }

  Future<List<SongModel>> getArtist() async {
    return OnAudioQuery().querySongs(
      sortType: SongSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
  }

  Future<Uint8List?> getArtwork(
      AsyncSnapshot<List<SongModel>> item, int index) async {
    return OnAudioQuery().queryArtwork(
      item.data![index].id,
      ArtworkType.AUDIO,
      format: ArtworkFormat.JPEG,
      size: 200,
    );
  }

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
