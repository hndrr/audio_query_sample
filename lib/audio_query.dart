import 'dart:io';
import 'dart:typed_data';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';

// UNUSED
// ignore: use_key_in_widget_constructors
class AudioQuery extends StatefulWidget {
  @override
  _AudioQueryState createState() => _AudioQueryState();
}

class _AudioQueryState extends State<AudioQuery> {
  OnAudioQuery audioQuery = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SongModel>>(
      future: OnAudioQuery().querySongs(
        sortType: SongSortType.DEFAULT,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
      ),
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
              title: Text(item.data![index].title),
              subtitle: Text(item.data![index].artist ?? 'No Artist'),
              // trailing: const Icon(Icons.play_arrow),
              // This Widget will query/load image. Just add the id and type.
              // You can use/create your own widget/method using [queryArtwork].
              leading: FutureBuilder<Uint8List?>(
                  future: OnAudioQuery().queryArtwork(
                    item.data![index].id,
                    ArtworkType.AUDIO,
                    format: ArtworkFormat.JPEG,
                    size: 200,
                  ),
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
                await audioPlayer.play(
                  Platform.isAndroid
                      ? item.data![index].data
                      : item.data![index].uri!,
                );

                if (fabKey.currentState!.isOpen) {
                  fabKey.currentState!.close();
                } else {
                  fabKey.currentState!.open();
                }
              },
            );
          },
        );
      },
    );
  }
}
