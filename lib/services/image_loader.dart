import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ImageLoader {
  static Future<File> loadImage(String imageURL) async {
    final http.Response responseData = await http.get(imageURL);
    Uint8List uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();

    //imageCache.clear();
    File file = await File('${tempDir.path}/img}').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    final FileImage provider = FileImage(file);
    await provider.evict();
    return file;
  }
}
