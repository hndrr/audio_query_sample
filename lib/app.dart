import 'package:audio_query_sample/file_picker.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';

import 'album_list/album_list.dart';
import 'artist_list/artist_list.dart';

// ignore: use_key_in_widget_constructors
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<FabCircularMenuState> fabKey = GlobalKey();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _widgetList = <Widget>[
      // _audioQueryBody(context),
      const AlbumListPage(),
      const ArtistListPage(),
      FilePickerDemo(),
    ];

    return MaterialApp(
      home: Scaffold(
        body: _widgetList.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.album_rounded), label: 'album'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_search_rounded), label: 'artist'),
            BottomNavigationBarItem(
                icon: Icon(Icons.insert_drive_file), label: 'FilePicker'),
          ],
          currentIndex: _selectedIndex,
          fixedColor: Colors.blueAccent,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
//         floatingActionButton: Builder(
//           builder: (context) => FabCircularMenu(
//             key: fabKey,
//             alignment: Alignment.bottomRight,
//             ringColor: Colors.grey.withAlpha(60),
//             ringDiameter: 205,
//             ringWidth: 70,
//             fabSize: 64,
//             fabElevation: 8,
//             fabIconBorder: const CircleBorder(),
//             fabColor: Colors.white,
//             fabOpenIcon: Icon(Icons.menu, color: Colors.grey[600]),
//             fabCloseIcon: Icon(Icons.close, color: Colors.grey[600]),
//             fabMargin: const EdgeInsets.all(16),
//             animationDuration: const Duration(milliseconds: 100),
//             animationCurve: Curves.easeInOutCirc,
//             onDisplayChange: (isOpen) {
// //              _showSnackBar(
// //                  context, "The menu is ${isOpen ? "open" : "closed"}");
//               debugPrint(isOpen ? 'open' : 'closed');
//               setState(() {
//                 _visible = !isOpen;
//               });
//             },
//             children: <Widget>[
//               RawMaterialButton(
//                 onPressed: () async {
// //              _showSnackBar(context, "You pressed 1");
//                   await audioPlayer.seek(const Duration(milliseconds: 1200));
//                 },
//                 shape: const CircleBorder(),
//                 padding: const EdgeInsets.all(24),
//                 child: Icon(Icons.skip_previous, color: Colors.grey[500]),
//               ),
//               RawMaterialButton(
//                 onPressed: () {
//                   if (_isPlaying == true) {
//                     pauseAudio();
//                     setState(() {
//                       _isPlaying = false;
//                     });
//                   } else {
//                     resumeAudio();
//                     setState(() {
//                       _isPlaying = true;
//                     });
//                   }
//                 },
//                 shape: const CircleBorder(),
//                 padding: const EdgeInsets.all(24),
//                 child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
//                     color: Colors.grey[500]),
//               ),
//               RawMaterialButton(
//                 onPressed: () async {
//                   await audioPlayer.seek(const Duration(milliseconds: -1200),
//                    );
//                 },
//                 shape: const CircleBorder(),
//                 padding: const EdgeInsets.all(24),
//                 child: Icon(Icons.skip_next, color: Colors.grey[500]),
//               ),
//             ],
//  ),
//         ),
      ),
    );
  }
}
