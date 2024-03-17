import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';

class FileUtils {
  Future<Uint8List?> pickFileBytesFromDevice() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    Uint8List bytes = await image.readAsBytes();

    return bytes;
  }

  Future<ui.Image?> getUiImageFromAssets(String assetPath) async {
    // Load the image bytes from the asset bundle
    ui.Image? mi;
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      mi = await convertBytestoUiImage(bytes);
    } catch (e) {
      debugPrint('[log] : ${e.toString()}');
    }

    return mi;
  }

  Future<(ui.Image?, String?)> getUiImageFromGallery() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return (null, null);
    final Uint8List bytes = await image.readAsBytes();

    ui.Image? imagedata = await convertBytestoUiImage(bytes);

    return (imagedata, image.path);
  }

  Future<InputImage?> convertUiImagetoInputImage(ui.Image uiimage) async {
    InputImage? inputImage;

    try {
      ByteData? bytedata = await uiimage.toByteData();
      if (bytedata == null) return null;

      Uint8List bytes = bytedata.buffer.asUint8List();
      int width = uiimage.width;
      int bytesPerPixel = 4; // BGRA8888 format uses 4 bytes per pixel
      int bytesPerRow = width * bytesPerPixel;

      inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(uiimage.width.toDouble(), uiimage.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.bgra8888,
          bytesPerRow: bytesPerRow,
        ),
      );
    } catch (e) {
      debugPrint('[log] : ${e}');
    }

    return inputImage;
  }

  Future<ui.Image?> convertBytestoUiImage(Uint8List bytes) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return await completer.future;
  }

  Future<Uint8List?> convertUiImageToBytes(ui.Image image) async {
    try {
      ByteData? bytes = await image.toByteData();

      if (bytes == null) return null;

      Uint8List? int8data = bytes.buffer.asUint8List();

      return int8data;
    } catch (e) {
      debugPrint('[log] : $e');
      return null;
    }
  }
}
