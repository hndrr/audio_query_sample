import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

import 'album_list_model.dart';

class AlbumDetailPage extends StatelessWidget {
  const AlbumDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  final int id;

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumListModel>(
      builder: (
        BuildContext context,
        AlbumListModel model,
        Widget? child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('OnAudioQueryDetail'),
            elevation: 2,
          ),
          body: SafeArea(
            top: false,
            child: FutureBuilder<List<SongModel>>(
              future: model.getSongsSpecificAlbum(id),
              builder: (context, item) {
                // Loading content
                if (item.data == null) {
                  return const CircularProgressIndicator();
                }

                // When you try "query"
                // without asking for [READ] or [Library] permission
                // the plugin will return a [Empty] list.
                if (item.data!.isEmpty) {
                  return const Text('Nothing found!');
                }

                // You can use [item.data!] direct or you can create a:
                // List<SongModel> songs = item.data!;
                return ListView.builder(
                  itemCount: item.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.data![index].album!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${item.data![index].track! - 1000}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                item.data![index].title,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Text(item.data![index].artist ?? 'No Artist'),
                      // trailing: const Icon(Icons.play_arrow),
                      // This Widget will query/load image. Just add the id and type.
                      // You can use/create your own widget/method using [queryArtwork].
                      leading: FutureBuilder<Uint8List?>(
                          future: model.getSongsArtwork(item, index),
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
                      onTap: () async {
                        await model.playAudio(item, index);

                        if (model.isPlaying == true) {
                          await model.pauseAudio();
                          model.pausePlaying();
                        } else {
                          await model.resumeAudio();
                          model.startPlaying();
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
