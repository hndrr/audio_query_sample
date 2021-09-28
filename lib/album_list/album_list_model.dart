import 'dart:io';

import 'package:flutter/material.dart';

class AlbumListModel extends ChangeNotifier {
  // List<MusicInfo> _viewList = <MusicInfo>[];
  // List<MusicInfo> get viewList => _viewList;

  // List<AlbumInfo> _albumList = <AlbumInfo>[];
  // List<AlbumInfo> get albumList => _albumList;

  // List<SongInfo> _songList = <SongInfo>[];
  // List<SongInfo> get songList => _songList;

  // List<MusicInfo> _viewSongList = <MusicInfo>[];
  // List<MusicInfo> get viewSongList => _viewSongList;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> init() async {
    startLoading();
    if (Platform.isAndroid) {
      debugPrint('AlbumListModel: called init()');
      // _albumList = await _audioQueryRepository.fetchLocalAlbum();
      // _viewList =
      //     _audioQueryRepository.toMusicInfoListFromAlbumList(_albumList);
    }
    endLoading();
    notifyListeners();
  }
}
