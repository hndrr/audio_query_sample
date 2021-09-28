import 'dart:io';
import 'dart:typed_data';

import 'package:audio_query_sample/file_picker.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:audioplayers/audioplayers.dart';

// ignore: use_key_in_widget_constructors
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  OnAudioQuery audioQuery = OnAudioQuery();
  AudioPlayer audioPlayer = AudioPlayer();
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  bool _isPlaying = false;
  bool _visible = false;
  String filedataPath = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    requestPermission();
    initPlayer();
  }

  dynamic requestPermission() async {
    final permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    setState(() {
      //
    });
  }

  void initPlayer() {
    audioPlayer = AudioPlayer();

    // audioPlayer.durationHandler = (d) => setState(
    //       () {
    //         _duration = d;
    //       },
    //     );
    // audioPlayer.positionHandler = (p) => setState(
    //       () {
    //         _position = p;
    //       },
    //     );
  }

  void seekToSecond(int second) {
    final newDuration = Duration(seconds: second);
    audioPlayer.seek(newDuration);
  }

  Future<void> pauseAudio() async {
    final response = await audioPlayer.pause();
    if (response == 1) {
      // success

    } else {
      // ignore: avoid_print
      print('Some error occured in pausing');
    }
  }

  Future<void> stopAudio() async {
    final response = await audioPlayer.stop();
    if (response == 1) {
      // success

    } else {
      // ignore: avoid_print
      print('Some error occured in stopping');
    }
  }

  Future<void> resumeAudio() async {
    final response = await audioPlayer.resume();
    if (response == 1) {
      // success

    } else {
      // ignore: avoid_print
      print('Some error occured in resuming');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _widgetList = <Widget>[
      _audioQueryBody(context),
      FilePickerDemo(),
    ];

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('OnAudioQueryExample'),
          elevation: 2,
        ),
        body: _widgetList.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'audioQuery'),
            BottomNavigationBarItem(
                icon: Icon(Icons.photo_album), label: 'FilePicker'),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blueAccent,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButton: Builder(
          builder: (context) => FabCircularMenu(
            key: fabKey,
            alignment: Alignment.bottomRight,
            ringColor: Colors.grey.withAlpha(60),
            ringDiameter: 205,
            ringWidth: 70,
            fabSize: 64,
            fabElevation: 8,
            fabIconBorder: const CircleBorder(),
            fabColor: Colors.white,
            fabOpenIcon: Icon(Icons.menu, color: Colors.grey[600]),
            fabCloseIcon: Icon(Icons.close, color: Colors.grey[600]),
            fabMargin: const EdgeInsets.all(16),
            animationDuration: const Duration(milliseconds: 100),
            animationCurve: Curves.easeInOutCirc,
            onDisplayChange: (isOpen) {
//              _showSnackBar(
//                  context, "The menu is ${isOpen ? "open" : "closed"}");
              debugPrint(isOpen ? 'open' : 'closed');
              setState(() {
                _visible = !isOpen;
              });
            },
            children: <Widget>[
              RawMaterialButton(
                onPressed: () async {
//              _showSnackBar(context, "You pressed 1");
                  await audioPlayer.seek(const Duration(milliseconds: 1200));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
                child: Icon(Icons.skip_previous, color: Colors.grey[500]),
              ),
              RawMaterialButton(
                onPressed: () {
                  if (_isPlaying == true) {
                    pauseAudio();
                    setState(() {
                      _isPlaying = false;
                    });
                  } else {
                    resumeAudio();
                    setState(() {
                      _isPlaying = true;
                    });
                  }
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
                child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.grey[500]),
              ),
              RawMaterialButton(
                onPressed: () async {
                  await audioPlayer.seek(const Duration(milliseconds: -1200));
                },
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(24),
                child: Icon(Icons.skip_next, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _audioQueryBody(BuildContext context) {
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