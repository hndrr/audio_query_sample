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

  List<MusicInfo> _viewArtistAlbumList = <MusicInfo>[];
  List<MusicInfo> get viewArtistAlbumList => _viewArtistAlbumList;

  List<MusicInfo> _viewSongList = <MusicInfo>[];
  List<MusicInfo> get viewSongList => _viewSongList;

  List<MusicInfo> _selectSongList = <MusicInfo>[];
  List<MusicInfo> get selectSongList => _selectSongList;

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
    debugPrint('AlbumListModel: called init()');
    _audioQueryRepository.requestPermission();
    _audioPlayersRepository.initPlayer();
    // Albumのリストを取得
    await getAlbum();
    // 曲のリストを取得
    await getSongsSortAlbums();
    // _viewSongList =
    //     _audioQueryRepository.toMusicInfoListFromSongList(_songList);
    endLoading();
    notifyListeners();
  }

  Future<void> playAudio(MusicInfo songList) async {
    await _audioPlayersRepository.playAudio(songList);
  }

  Future<void> getAlbum() async {
    _albumList = await _audioQueryRepository.fetchLocalAlbum();
    _viewList = _audioQueryRepository.toMusicInfoListFromAlbumList(_albumList);
  }

  Future<void> getArtistAlbum(String artist) async {
    _viewArtistAlbumList =
        _viewList.where((element) => element.artist == artist).toList();
  }

  // Future<List<dynamic>> getArtistAlbum(String artist) async {
  //   return _audioQueryRepository.fetchArtistAlbums(artist);
  // }

  Future<void> getSongsSortAlbums() async {
    _songList = await _audioQueryRepository.fetchSongFromAlbum();
    _viewSongList =
        _audioQueryRepository.toMusicInfoListFromSongList(_songList);
  }

  List<MusicInfo> getSongsSpecificAlbum(int id) {
    // _songList = await _audioQueryRepository.fetchSongFromAlbum();
    _selectSongList = _viewSongList
        .where((element) => element.id == id)
        .toList()
      ..sort((a, b) => a.track!.toInt().compareTo(b.track!.toInt()));
    notifyListeners();
    return _selectSongList;
  }

  Future<Uint8List?> getAlbumArtwork(MusicInfo album) async {
    return _audioQueryRepository.getArtworkByByte(
      album.id,
      ArtworkType.ALBUM,
    );
  }

  Future<Uint8List?> getSongsArtwork(MusicInfo song) async {
    return _audioQueryRepository.getArtworkByByte(
      song.id,
      ArtworkType.ALBUM,
    );
  }
}
