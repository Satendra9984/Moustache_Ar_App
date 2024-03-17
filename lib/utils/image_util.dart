import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as imglib;

class ImageUtils {
// Function to convert CameraImage to InputImage

  InputImage cameraImageToInputImage(
    CameraImage cameraImage,
    CameraDescription cameraDescription,
  ) {
    // Assuming the camera image is in YUV420 format.
    // This might need to be adjusted based on your camera settings.
    const InputImageFormat inputImageFormat = InputImageFormat.yuv420; // for

    final imageRotation = cameraSensorOrientationToImageRotation(
      cameraDescription.sensorOrientation,
    );

    // Create InputImage from bytes
    final inputImage = InputImage.fromBytes(
      bytes: concatenatePlanes(cameraImage.planes),
      metadata: InputImageMetadata(
        size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: cameraImage.planes[0].bytesPerRow,
      ),
    );

    return inputImage;
  }

  // imglib.Image _convertYUV420(CameraImage image) {
  // try {
  //   final int width = image.width;
  //   final int height = image.height;
  //   final int uvRowStride = image.planes[1].bytesPerRow;
  //   final int uvPixelStride = image.planes[1].bytesPerPixel;

  //   print("uvRowStride: " + uvRowStride.toString());
  //   print("uvPixelStride: " + uvPixelStride.toString());

  //   // imgLib -> Image package from https://pub.dartlang.org/packages/image
  //   var img = imglib.Image(width: width, height: height); // Create Image buffer
  //   Uint8List byteData = img.data?.buffer.asUint8List() ?? Uint8List(0);

  //   // Fill image buffer with plane[0] from YUV420_888
  //   for (int x = 0; x < width; x++) {
  //     for (int y = 0; y < height; y++) {
  //       final int uvIndex = uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
  //       final int index = y * width + x;

  //       final yp = image.planes[0].bytes[index];
  //       final up = image.planes[1].bytes[uvIndex];
  //       final vp = image.planes[2].bytes[uvIndex];
  //       // Calculate pixel color
  //       int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
  //       int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91).round().clamp(0, 255);
  //       int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
  //       // color: 0x FF  FF  FF  FF
  //       //           A   B   G   R
  //       img.data[index] = shift | (b << 16) | (g << 8) | r;
  //     }
  //   }

  // imglib.PngEncoder pngEncoder =  imglib.PngEncoder(level: 0, filter: 0);
  // List<int> png = pngEncoder.encodeImage(img);
  // muteYUVProcessing = false;
  // return Image.memory(png);
//   } catch (e) {
//     print(">>>>>>>>>>>> ERROR:" + e.toString());
//   }
//   return null;
// }
// Helper function to concatenate bytes from the image planes
  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();
    for (var plane in planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return allBytes.done().buffer.asUint8List();
  }

// Helper function to convert camera sensor orientation to ML Kit image rotation
  InputImageRotation cameraSensorOrientationToImageRotation(
      int sensorOrientation) {
    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  Future<Uint8List?> getUint8ListFromImage(ui.Image image) async {
    ByteData? byteData = await image.toByteData();

    if (byteData == null) return null;
    return byteData.buffer.asUint8List();
  }
}
