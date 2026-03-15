import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class SignatureFileHelper {
  /// Converts base64 signature data to a File with 8-bit PNG format
  ///
  /// [base64Data] - The base64 string (with or without data URI prefix)
  /// [filename] - Optional filename, defaults to timestamp-based name
  ///
  /// Returns a File object that can be used for multipart upload
  /// The file is guaranteed to be 8-bit depth for FPDF compatibility
  static Future<Uint8List> base64ToBytes(
    String base64Data, {
    String? filename,
  }) async {
    // Remove data URI prefix if present (e.g., "data:image/png;base64,")
    String base64String = base64Data;
    if (base64Data.contains(',')) {
      base64String = base64Data.split(',').last;
    }

    // Decode base64 to bytes
    final bytes = base64Decode(base64String);

    // Convert to 8-bit PNG to ensure FPDF compatibility
    final convertedBytes = await to8BitPngPreserveColor(bytes);

    return convertedBytes;
  }

  static Future<File> base64ToFile(
    String base64Data, {
    String? filename,
  }) async {
    // Remove data URI prefix if present (e.g., "data:image/png;base64,")
    String base64String = base64Data;
    if (base64Data.contains(',')) {
      base64String = base64Data.split(',').last;
    }

    // Decode base64 to bytes
    final bytes = base64Decode(base64String);

    // Convert to 8-bit PNG to ensure FPDF compatibility
    final convertedBytes = await to8BitPngPreserveColor(bytes);

    // Get temporary directory
    final tempDir = await getTemporaryDirectory();

    // Generate filename if not provided
    final String fileName =
        filename ?? 'signature_${DateTime.now().millisecondsSinceEpoch}.png';

    // Create file path
    final filePath = '${tempDir.path}/$fileName';

    // Write bytes to file
    final file = File(filePath);
    await file.writeAsBytes(convertedBytes);

    return file;
  }

  static Future<Uint8List> to8BitPngPreserveColor(Uint8List inputBytes) async {
    if (inputBytes.isEmpty) {
      throw const FormatException('Empty image bytes');
    }

    // Decode with Flutter's codec (often succeeds where pure Dart decoders fail).
    final codec = await ui.instantiateImageCodec(inputBytes);
    final frame = await codec.getNextFrame();
    final uiImage = frame.image;

    // Get raw 8-bit RGBA pixels.
    final byteData = await uiImage.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (byteData == null) {
      throw const FormatException(
        'Failed to extract RGBA bytes from decoded image',
      );
    }

    final rgba = byteData.buffer.asUint8List();

    // Encode to standard PNG (8-bit per channel).
    final imglib = img.Image.fromBytes(
      width: uiImage.width,
      height: uiImage.height,
      bytes: rgba.buffer,
      numChannels: 4,
    );

    return Uint8List.fromList(img.encodePng(imglib));
  }

  /// Cleans up temporary signature files
  static Future<void> deleteSignatureFile(File file) async {
    if (await file.exists()) {
      await file.delete();
    }
  }
}
