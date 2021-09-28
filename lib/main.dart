import 'package:audio_query_sample/app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'album_list/album_list_model.dart';

void main() {
  runApp(
    MultiProvider(
      providers: <SingleChildWidget>[
        // ChangeNotifierProvider<FabCircularAudioModel>(
        //   create: (BuildContext context) => FabCircularAudioModel(),
        // ),
        ChangeNotifierProvider<AlbumListModel>(
          create: (BuildContext context) => AlbumListModel()..init(),
        ),
      ],
      child: App(),
    ),
  );
}
