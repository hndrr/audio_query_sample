import 'dart:io';
import 'dart:typed_data';

import 'package:audio_query_sample/domain/audio_players_repository.dart';
import 'package:audio_query_sample/domain/audio_query_repository.dart';
import 'package:audio_query_sample/domain/music_info.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AlbumListModel extends ChangeNotifier {
  final AudioPlayersRepository _audioPlayersRepository =
      AudioPlayersRepository();
  final AudioQueryRepository _audioQueryRepository = AudioQueryRepository();

  List<AlbumModel> _albumList = <AlbumModel>[];
  List<AlbumModel> get albumList => _albumList;

  List<SongModel> _songList = <SongModel>[];
  List<SongModel> get songList => _songList;

  List<MusicInfo> _viewList = <MusicInfo>[];
  List<MusicInfo> get viewList => _viewList;

  // List<MusicInfo> _viewSongList = <MusicInfo>[];
  // List<MusicInfo> get viewSongList => _viewSongList;

  OnAudioQuery audioQuery = OnAudioQuery();

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
    _audioPlayersRepository.resumeAudio();
    notifyListeners();
  }

  void pausePlaying() {
    isPlaying = false;
    _audioPlayersRepository.pauseAudio();
    notifyListeners();
  }

  Future<void> init() async {
    startLoading();
    if (Platform.isAndroid) {
      debugPrint('AlbumListModel: called init()');
      _audioQueryRepository.requestPermission();
      _audioPlayersRepository.initPlayer();
      _albumList = await getAlbum();
      _viewList =
          _audioQueryRepository.toMusicInfoListFromAlbumList(_albumList);
    }
    endLoading();
    notifyListeners();
  }

  Future<void> playAudio(AsyncSnapshot<List<SongModel>> item, int index) async {
    await _audioPlayersRepository.playAudio(item, index);
  }

  Future<List<AlbumModel>> getAlbum() async {
    return _albumList = await _audioQueryRepository.fetchLocalAlbum();
    // if (artist != null) {
    //  return _albumList.where((element) => element.artist == artist).toList();
    // }
  }

  Future<List<dynamic>> getArtistAlbum(String? artist) async {
    if (artist == null) {
      return _audioQueryRepository.fetchLocalAlbum();
    }
    return _audioQueryRepository.fetchArtistAlbums(artist);
  }

  Future<List<SongModel>> getSongsSortAlbums() async {
    return _audioQueryRepository.fetchSongFromAlbum();
  }

  Future<List<ArtistModel>> getArtists() async {
    return _audioQueryRepository.fetchArtists();
  }

  Future<List<SongModel>> getSongsSpecificAlbum(int id) async {
    _songList = await _audioQueryRepository.fetchSongFromAlbum();
    final _selectSongList = _songList
        .where((element) => element.albumId == id)
        .toList()
      ..sort((a, b) => a.track!.toInt().compareTo(b.track!.toInt()));
    return _selectSongList;
  }

  Future<List<SongModel>> getSongsSortArtists() async {
    return _audioQueryRepository.fetchSongFromArtists();
  }

  Future<Uint8List?> getSongsArtwork(
    AsyncSnapshot<List<SongModel>> item,
    int index,
  ) async {
    return _audioQueryRepository.getArtworkByByte(
      item.data![index].id,
      ArtworkType.AUDIO,
    );
  }

  Future<Uint8List?> getArtistAlbumArtwork(
      List<AlbumModel> albums, int index) async {
    return _audioQueryRepository.getArtworkByByte(
      albums[index].id,
      ArtworkType.ALBUM,
    );
  }

  Future<Uint8List?> getAlbumArtwork(List<MusicInfo> albums, int index) async {
    return _audioQueryRepository.getArtworkByByte(
      albums[index].id,
      ArtworkType.ALBUM,
    );
  }

  // Future<Uint8List?> getAlbumArtwork(
  //     AsyncSnapshot<List<AlbumModel>> item, int index) async {
  //   return _audioQueryRepository.getArtworkByByte(
  //     item.data![index].id,
  //     ArtworkType.ALBUM,
  //   );
  // }

  Future<Uint8List?> getArtistArtwork(
      AsyncSnapshot<List<ArtistModel>> item, int index) async {
    return _audioQueryRepository.getArtworkByByte(
      item.data![index].id,
      ArtworkType.ARTIST,
    );
  }
}
