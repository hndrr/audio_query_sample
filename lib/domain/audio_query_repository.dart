import 'dart:typed_data';

import 'package:on_audio_query/on_audio_query.dart';

import 'music_info.dart';

class AudioQueryRepository {
  // create a FlutterAudioQuery instance.
  final OnAudioQuery _audioQuery = OnAudioQuery();

  Future<List<AlbumModel>> fetchLocalAlbum() async {
    return _audioQuery.queryAlbums(
      sortType: AlbumSortType.ARTIST,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
  }

  Future<List<SongModel>> fetchSongFromAlbum(MusicInfo musicInfo) async {
    final songList = await _audioQuery.querySongs(
      sortType: SongSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
    );
    return songList;
  }

  List<MusicInfo> toMusicInfoListFromAlbumList(List<AlbumModel> albumInfoList) {
    final albums = albumInfoList
        .map((AlbumModel item) => MusicInfo(
              item.albumId.toString(),
              item.album,
              item.album, // 曲と共用してるのでAlbumはtitleと同じものを入れた
              item.artist!,
            ))
        .toList();
    return albums;
  }

  List<MusicInfo> toMusicInfoListFromSongList(
      List<SongModel> songInfoList, String albumTitle) {
    final songs = songInfoList
        .map(
          (SongModel song) => MusicInfo(
            song.id.toString(),
            song.title,
            albumTitle,
            song.artist!,
            track: song.track,
          ),
        )
        .toList()
      ..sort(
          (MusicInfo a, MusicInfo b) => a.track!.compareTo(b.track!.toInt()));
    return songs;
  }

  Future<AlbumModel> getAlbumInfoById(String id) async {
    final albums = await fetchLocalAlbum();
    final result = albums
        .singleWhere((AlbumModel albumInfo) => albumInfo.id.toString() == id);
    return result;
  }

  MusicInfo? toMusicInfoFromAlbumInfo(AlbumModel? albumInfo) {
    return albumInfo != null
        ? MusicInfo(
            albumInfo.id.toString(),
            albumInfo.album,
            albumInfo.album, // 曲と共用してるのでAlbumはtitleと同じものを入れた
            albumInfo.artist!,
          )
        : null;
  }

  // audioQuery.getArtworkのラッパー
  Future<Uint8List?> getArtworkByByte(
    ArtworkType artworkType,
    int id,
  ) async {
    final rawData = await _audioQuery.queryArtwork(
      id,
      artworkType,
      format: ArtworkFormat.PNG,
      size: 200,
    );
    return rawData;
  }
}
