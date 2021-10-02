import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'music_info.dart';

class AlbumArtRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> addItem(MusicInfo musicInfo, String imageUrl) async {
    await runZonedGuarded<Future<void>>(() async {
      await firebaseFirestore
          .collection('music')
          .doc(_auth.currentUser!.uid)
          .collection(musicInfo.artist)
          .doc(musicInfo.albumTitle)
          .set(<String, dynamic>{
        'artistName': musicInfo.artist,
        'albumTitle': musicInfo.albumTitle,
        'iconImageUrl': imageUrl,
        'imageUrl': imageUrl,
        'subscribedDate': FieldValue.serverTimestamp(),
      });
    }, FirebaseCrashlytics.instance.recordError);
  }

  Future<DocumentSnapshot<Object?>?>? getItem(
      String artist, String albumTitle) async {
    final _musicDocSnap =
        await runZonedGuarded<Future<DocumentSnapshot<Object?>>>(() async {
      return firebaseFirestore
          .collection('music')
          .doc(_auth.currentUser!.uid)
          .collection(artist)
          .doc(albumTitle)
          .get();
    }, FirebaseCrashlytics.instance.recordError);
    return _musicDocSnap;
  }

  Future<bool> existsItem(DocumentSnapshot<Object?> musicDocSnap) async {
    final _musicDocSnapExists = musicDocSnap.exists;
    return _musicDocSnapExists;
  }

  Future<String> getImageUrl(DocumentSnapshot<Object?> musicDocSnap) async {
    final _musicDocSnapImageUrl = musicDocSnap['imageUrl'] as String;
    return _musicDocSnapImageUrl;
  }
}
