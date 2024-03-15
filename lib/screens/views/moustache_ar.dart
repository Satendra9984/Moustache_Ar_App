import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class AddMoustacheScreen extends StatefulWidget {
  const AddMoustacheScreen({super.key});

  @override
  State<AddMoustacheScreen> createState() => _AddMoustacheScreenState();
}

class _AddMoustacheScreenState extends State<AddMoustacheScreen> {
  late final InputImage? inputImage;
  late final FaceDetectorOptions options;
  late final FaceDetector faceDetector;

  @override
  void initState() {
    options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moustache'),
      ),
      body: Column(
        children: [],
      ),
    );
  }

  Future<void> _detectFaces() async {
    // Pick Image
    if (inputImage == null) return;
    final List<Face> faces = await faceDetector.processImage(inputImage!);

    for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;

      final double? rotX =
          face.headEulerAngleX; // Head is tilted up and down rotX degrees
      final double? rotY =
          face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double? rotZ =
          face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):
      final FaceLandmark? leftMouth =
          face.landmarks[FaceLandmarkType.leftMouth];
      final FaceLandmark? rightMouth =
          face.landmarks[FaceLandmarkType.rightMouth];

      if (leftMouth == null && rightMouth == null) return;

      var leftMp, rightMp = getBothPositions(leftMouth, rightMouth);
    }
  }

  (Point<int>, Point<int>) getBothPositions(
      FaceLandmark? leftM, FaceLandmark? rightM) {
    Point<int>? leftMP, rightMP;

    if (leftM != null && rightM == null) {
      leftMP = leftM.position;
      // [TODO]: INFER right position
      rightMP = leftMP;
      return (leftMP, rightMP!);
    } else if (rightM != null && leftM == null) {
      rightMP = rightM.position;

      // [TODO] : INFER LEFT POSITION
      leftMP = rightMP;
      return (leftMP!, rightMP);
    }

    // Both are not null
    leftMP = leftM!.position;
    rightMP = rightM!.position;

    return (leftMP, rightMP);
  }
}
