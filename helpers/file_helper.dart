import 'dart:convert';
import 'dart:io';

class FileHelper {
  FileHelper._();

  static Future<String> convertToBase64(File file) async {
    return base64Encode(file.readAsBytesSync());
  }
}
