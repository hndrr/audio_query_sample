import 'package:audio_query_sample/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'album_list/album_list_model.dart';
import 'artist_list/artist_list_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        ChangeNotifierProvider<AlbumListModel>(
          create: (BuildContext context) => AlbumListModel()..init(),
        ),
        ChangeNotifierProvider<ArtistListModel>(
          create: (BuildContext context) => ArtistListModel()..init(),
        ),
      ],
      child: const App(),
    ),
  );
}
