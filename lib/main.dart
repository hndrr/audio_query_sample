import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(Songs());
}

class Songs extends StatefulWidget {
  @override
  _SongsState createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  OnAudioQuery audioQuery = OnAudioQuery();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  dynamic requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      final permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      setState(() {
        //
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("OnAudioQueryExample"),
          elevation: 2,
        ),
        body: FutureBuilder<List<SongModel>>(
          future: OnAudioQuery().querySongs(
            sortType: SongSortType.DEFAULT,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
          ),
          builder: (context, item) {
            // Loading content
            if (item.data == null) return CircularProgressIndicator();

            // When you try "query" without asking for [READ] or [Library] permission
            // the plugin will return a [Empty] list.
            if (item.data!.isEmpty) return Text("Nothing found!");

            // You can use [item.data!] direct or you can create a:
            // List<SongModel> songs = item.data!;
            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(item.data![index].title),
                  subtitle: Text(item.data![index].artist ?? "No Artist"),
                  trailing: Icon(Icons.arrow_forward_rounded),
                  // This Widget will query/load image. Just add the id and type.
                  // You can use/create your own widget/method using [queryArtwork].
                  leading: QueryArtworkWidget(
                    id: item.data![index].id,
                    type: ArtworkType.AUDIO,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
