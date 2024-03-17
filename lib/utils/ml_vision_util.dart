import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MlVisionFaceDetectorUtil {
  Future<List<Face>> detectFaceFromImage(String galleryImagePath) async {
    final options = FaceDetectorOptions(
      enableLandmarks: true,
      enableTracking: true,
    );
    final faceDetector = FaceDetector(options: options);

    List<Face> faces = [];
    try {
      File file = File(galleryImagePath);
      InputImage? inputImage = InputImage.fromFile(file);

      faces = await faceDetector.processImage(inputImage);
    } catch (e) {
      debugPrint('[faceerror]: ${e.toString()}');
    }

    return faces;
  }

  Future<List<Face>> detectFaceFromInputImage(InputImage inputImage) async {
    final options = FaceDetectorOptions(
      enableLandmarks: true,
      enableTracking: true,
    );
    final faceDetector = FaceDetector(options: options);

    List<Face> faces = [];
    try {
      // File file = File(galleryImagePath);
      
      // InputImage? inputImage = InputImage.fromFile(file);
      faceDetector.processImage(inputImage);
      faces = await faceDetector.processImage(inputImage);
    } catch (e) {
      debugPrint('[faceerror]: ${e.toString()}');
    }

    return faces;
  }
  Future<List<Face>> detectFaceFromRawData(Uint8List rawimage) async {
    final options = FaceDetectorOptions(
      enableLandmarks: true,
      enableTracking: true,
    );
    final faceDetector = FaceDetector(options: options);

    List<Face> faces = [];
    try {
      File file = File.fromRawPath(rawimage);
      InputImage inputImage = InputImage.fromFile(file);
      faceDetector.processImage(inputImage);
      faces = await faceDetector.processImage(inputImage);
    } catch (e) {
      debugPrint('[faceerror]: ${e.toString()}');
    }

    return faces;
  }
}
