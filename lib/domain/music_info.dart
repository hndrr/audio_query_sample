import 'package:flutter/material.dart';

/// リスト表示用の曲情報
class MusicInfo {
  // ignore: lines_longer_than_80_chars
  MusicInfo(this.id, this.title, this.albumTitle, this.artist,
      {this.artworkUri, this.track, this.filePath}) {
    _playState = PlayState.none;
  }

  // id
  int id;

  // 曲名orアルバム名
  String title;

  // アルバム名
  String albumTitle;

  // アーティスト名
  String artist;

  // artworkUri
  String? artworkUri;

  // artworkのWidget
  Widget? artwork;

  // 曲情報を保持する場合の曲順
  int? track;

  String? filePath;

  PlayState? _playState;

  PlayState? get playState => _playState;

  void changePlayState(PlayState playState) {
    _playState = playState;
  }
}

enum PlayState {
  none,
  pause,
  playing,
}
