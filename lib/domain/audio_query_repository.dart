import 'dart:io';
import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

import 'music_info.dart';

class AudioQueryRepository {
  // create a FlutterAudioQuery instance.
  final OnAudioQuery _audioQuery = OnAudioQuery();

  dynamic requestPermission() async {
    final permissionStatus = await _audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await _audioQuery.permissionsRequest();
    }
    // setState(() {
    //   //
    // });
  }

  Future<List<AlbumModel>> fetchLocalAlbum() async {
    return _audioQuery.queryAlbums(
      sortType: AlbumSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
  }

  Future<List<ArtistModel>> fetchArtists() async {
    return _audioQuery.queryArtists(
      sortType: ArtistSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
  }

  Future<List<dynamic>> fetchArtistAlbums(String artist) async {
    return _audioQuery.queryWithFilters(
      artist,
      WithFiltersType.ALBUMS,
      args: AlbumsArgs.ARTIST,
    );
  }

  Future<List<SongModel>> fetchSongFromAlbum() async {
    final songList = await _audioQuery.querySongs(
      sortType: SongSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    return songList;
  }

  Future<List<SongModel>> fetchSongFromArtists() async {
    final songList = await _audioQuery.querySongs(
      sortType: SongSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    return songList;
  }

  Future<AlbumModel> getAlbumInfoById(String id) async {
    final albums = await fetchLocalAlbum();
    final result = albums
        .singleWhere((AlbumModel albumInfo) => albumInfo.id.toString() == id);
    return result;
  }

  List<MusicInfo> toMusicInfoListFromAlbumList(List<AlbumModel> albumInfoList) {
    final albums = albumInfoList
        .map((AlbumModel item) => MusicInfo(
              item.albumId,
              item.album,
              item.album, // 曲と共用してるのでAlbumはtitleと同じものを入れた
              item.artist!,
            ))
        .toList();
    return albums;
  }

  List<MusicInfo> toMusicInfoListFromSongList(List<SongModel> songInfoList,
      {String? albumTitle}) {
    final songs = songInfoList
        .map(
          (SongModel song) => MusicInfo(
            song.albumId!,
            song.title,
            albumTitle ?? '',
            song.artist!,
            track: Platform.isAndroid ? song.track! - 1000 : song.track,
            filePath: Platform.isAndroid ? song.data : song.uri,
          ),
        )
        .toList()
      ..sort(
          (MusicInfo a, MusicInfo b) => a.track!.compareTo(b.track!.toInt()));
    return songs;
  }

  MusicInfo? toMusicInfoFromAlbumInfo(AlbumModel? albumInfo) {
    return albumInfo != null
        ? MusicInfo(
            albumInfo.id,
            albumInfo.album,
            albumInfo.album, // 曲と共用してるのでAlbumはtitleと同じものを入れた
            albumInfo.artist!,
          )
        : null;
  }

  // audioQuery.getArtworkのラッパー
  Future<Uint8List?> getArtworkByByte(
    int id,
    ArtworkType artworkType,
  ) async {
    final rawData = await _audioQuery.queryArtwork(
      id,
      artworkType,
      format: ArtworkFormat.JPEG,
      size: 200,
    );
    return rawData;
  }
}
