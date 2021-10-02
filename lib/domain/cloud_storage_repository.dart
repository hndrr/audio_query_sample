import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'music_info.dart';

// usage ::
// https://firebase.flutter.dev/docs/storage/usage/
// https://stackoverflow.com/questions/58410497/how-to-handle-firebase-storage-storageexception
class CloudStorageRepository {
  // create a FirebaseCloudStorage instance.
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<String?> uploadFile(MusicInfo musicInfo, File file) async {
    final ref = _storage.ref(
        'artists/${Uri.encodeComponent(musicInfo.artist)}/${Uri.encodeComponent(musicInfo.albumTitle)}.jpg');
    String dlpath;
    final uploadTask = ref.putFile(file);
    await uploadTask.whenComplete(() async {
      dlpath = await uploadTask.snapshot.ref.getDownloadURL();
      return dlpath;
    });
  }

  Future<String?> uploadRawData(MusicInfo musicInfo, Uint8List rawData) async {
    final ref = _storage.ref(
        'artists/${Uri.encodeComponent(musicInfo.artist)}/${Uri.encodeComponent(musicInfo.albumTitle)}.jpg');

    String dlpath;
    if (rawData.isNotEmpty) {
      final uploadTask = ref.putData(rawData);
      await uploadTask.whenComplete(() async {
        dlpath = await uploadTask.snapshot.ref.getDownloadURL();
        return dlpath;
      });
    } else {
      return null;
    }
  }

  Future<String?> downloadPath(MusicInfo musicInfo) async {
    final ref = _storage.ref(
        'artists/${Uri.encodeComponent(musicInfo.artist)}/${Uri.encodeComponent(musicInfo.albumTitle)}.jpg');
    String dlpath;
    try {
      dlpath = await ref.getDownloadURL();
    } on Exception {
      return null;
    } on Error {
      return null;
    }

    return dlpath;
  }
}
