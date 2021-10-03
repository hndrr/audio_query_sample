import 'dart:typed_data';

import 'package:audio_query_sample/album_list/album_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'artist_list_model.dart';

class ArtistListPage extends StatelessWidget {
  const ArtistListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistListModel>(
      builder: (
        BuildContext context,
        ArtistListModel model,
        Widget? child,
      ) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('OnAudioQueryList'),
            elevation: 2,
          ),
          body: ListView.builder(
            itemCount: model.artistList.length,
            itemBuilder: (context, index) {
              final artistList = model.artistList[index];
              return ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artistList.artist,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                leading: FutureBuilder<Uint8List?>(
                    future: model.getArtistArtwork(artistList),
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
                  Navigator.of(context).push<dynamic>(
                    MaterialPageRoute<dynamic>(
                      builder: (context) =>
                          AlbumListPage(artist: artistList.artist),
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
