import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'album_detail.dart';
import 'album_list_model.dart';

class AlbumListPage extends StatelessWidget {
  const AlbumListPage({
    Key? key,
    this.artist,
  }) : super(key: key);

  final String? artist;

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumListModel>(
      builder: (
        BuildContext context,
        AlbumListModel model,
        Widget? child,
      ) {
        if (artist != null) {
          model.getArtistAlbum(artist!);
        }
        final musicInfos =
            artist == null ? model.viewList : model.viewArtistAlbumList;

        return Scaffold(
          appBar: AppBar(
            title: const Text('OnAudioQueryList'),
            elevation: 2,
          ),
          body: musicInfos.isEmpty
              ? model.isLoading
                  ? Container(
                      color: Colors.black.withOpacity(0.1),
                      child: const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    )
                  : const SizedBox()
              : ListView.builder(
                  cacheExtent: 10000,
                  scrollDirection: Axis.vertical,
                  itemCount: musicInfos.length,
                  itemBuilder: (context, index) {
                    final musicInfo = musicInfos[index];

                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            musicInfo.albumTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(musicInfo.artist),
                      // trailing: const Icon(Icons.play_arrow),
                      // This Widget will query/load image. Just add the id and type.
                      // You can use/create your own widget/method using [queryArtwork].
                      leading: FutureBuilder<Uint8List?>(
                          future: model.getAlbumArtwork(musicInfo),
                          builder: (context, item) {
                            if (item.data != null && item.data!.isNotEmpty) {
                              return ClipRRect(
                                // borderRadius: BorderRadius.circular(50),
                                clipBehavior: Clip.antiAlias,
                                child: Image.memory(
                                  item.data!,
                                  gaplessPlayback: false,
                                  repeat: ImageRepeat.noRepeat,
                                  scale: 1,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  // color: artworkColor,
                                  // colorBlendMode: artworkBlendMode,
                                  filterQuality: FilterQuality.low,
                                ),
                              );
                            } else {
                              return const Icon(
                                Icons.image_not_supported,
                                size: 50,
                              );
                            }
                          }),
                      // QueryArtworkWidget(
                      //   artworkBorder: BorderRadius.zero,
                      //   id: item.data![index].id,
                      //   type: ArtworkType.AUDIO,
                      // ),
                      // ignore: avoid_print
                      onTap: () {
                        model.getSongsSpecificAlbum(musicInfo.id);
                        Navigator.of(context).push<dynamic>(
                          MaterialPageRoute<dynamic>(
                            builder: (context) => AlbumDetailPage(
                                albumTitle: musicInfo.albumTitle),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
