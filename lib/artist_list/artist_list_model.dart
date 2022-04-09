import 'dart:typed_data';

import 'package:audio_query_sample/domain/audio_query_repository.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ArtistListModel extends ChangeNotifier {
  final AudioQueryRepository _audioQueryRepository = AudioQueryRepository();

  List<ArtistModel> _artistList = <ArtistModel>[];
  List<ArtistModel> get artistList => _artistList;

  OnAudioQuery audioQuery = OnAudioQuery();

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
    // startLoading();
    _audioQueryRepository.requestPermission();
    // Artistのリストを取得
    await getArtists();
    // endLoading();
    notifyListeners();
  }

  Future<void> getArtists() async {
    _artistList = await _audioQueryRepository.fetchArtists();
  }

  Future<List<SongModel>> getSongsSortArtists() async {
    return _audioQueryRepository.fetchSongFromArtists();
  }

  Future<Uint8List?> getArtistArtwork(ArtistModel artistList) async {
    return _audioQueryRepository.getArtworkByByte(
      artistList.id,
      ArtworkType.ARTIST,
    );
  }
}
