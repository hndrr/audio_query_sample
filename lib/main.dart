import 'package:audio_query_sample/app.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'album_list/album_list_model.dart';
import 'artist_list/artist_list_model.dart';

final albumListModelProvider = ChangeNotifierProvider(
  (ref) => AlbumListModel(),
);
final artistListModelProvider = ChangeNotifierProvider(
  (ref) => ArtistListModel(),
);

void main() {
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}
