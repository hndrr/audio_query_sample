import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

// usage ::
// https://flutter.dev/docs/cookbook/persistence/reading-writing-files
class LocalStorageRepository {
  // UNUSED
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> saveLocalImage(Uint8List uint8List, String fileName) async {
    final path = await localPath;
    final imagePath = '$path/$fileName.jpg';
    // if (File(imagePath).path.isNotEmpty) {
    //   return File(imagePath);
    // }
    final savedFile = await File(imagePath).writeAsBytes(uint8List);
    return savedFile;
  }

  Future<File> loadLocalImage(String fileName) async {
    final path = await localPath;
    final imagePath = '$path/$fileName.jpg';

    return File(imagePath);
  }
}
