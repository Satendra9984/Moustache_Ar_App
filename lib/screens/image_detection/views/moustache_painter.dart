import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';


class FacePainter extends CustomPainter {
  final List<Face> faceRects;
  final ui.Image imageFile;
  final ui.Image? moustacheImage;

  FacePainter({
    required this.faceRects,
    required this.imageFile,
    this.moustacheImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw the image with the specified destination rectangle
    // Size size = Size(imageFile.width.toDouble(), imageFile.height.toDouble());

    canvas.drawImageRect(
      imageFile,
      Rect.fromLTWH(0, 0, imageFile.width.toDouble(),
          imageFile.height.toDouble()), // Source rectangle (full image)
      Rect.fromLTWH(0, 0, size.width,
          size.height), // Destination rectangle (size of the canvas)
      Paint(),
    );

    Size sizeF = Size(imageFile.width.toDouble(), imageFile.height.toDouble());
    // size = sizeF;
    debugPrint(
        '[log] : dimesion canvas: ${size}, image:  ${imageFile.height} ${imageFile.width}');

    // Calculate scaling factors for width and height
    double scaleX = size.width / imageFile.width.toDouble();
    double scaleY = size.height / imageFile.height.toDouble();
    debugPrint('[log] : ${scaleX} ${scaleY}');

    // Draw rectangles around faces
    for (Face face in faceRects) {
      final Rect faceRect = face.boundingBox;
      final Size faceDimensions = faceRect.size;

      // Rect scaledFaceRect = Rect.fromLTRB(
      //   faceRect.left * scaleX,
      //   faceRect.top * scaleY,
      //   faceRect.right * scaleX,
      //   faceRect.bottom * scaleY,
      // );
      // canvas.drawRect(
      //   scaledFaceRect,
      //   Paint()
      //     ..color = Colors.teal
      //     ..strokeWidth = 6.0
      //     ..style = PaintingStyle.stroke,
      // );

      /// Moustache area
      final FaceLandmark? leftMouth =
          face.landmarks[FaceLandmarkType.leftMouth];
      final FaceLandmark? rightMouth =
          face.landmarks[FaceLandmarkType.rightMouth];
      final FaceLandmark? noseBase = face.landmarks[FaceLandmarkType.noseBase];

      // Draw rectangle around right eye
      if (leftMouth == null && rightMouth == null) return;

      final Offset mouthCenterPoints = getMoustacheCenter(
        leftMouth?.position,
        rightMouth?.position,
        scaleX,
        scaleY,
      );

      // Now the moustache area
      final Offset moustacheCenterPoints = getMoustacheCenter(
        noseBase?.position,
        Point<num>(
          (mouthCenterPoints.dx) / scaleX,
          (mouthCenterPoints.dy + 10.0*scaleY) / scaleY,
        ),
        scaleX,
        scaleY,
      );
      final num moustacheWidth = getMoustacheDimensions(
        leftMouth?.position.x,
        rightMouth?.position.x,
      );

      final num moustacheHeight = getMoustacheDimensions(
        leftMouth?.position.y,
        moustacheCenterPoints.dy / scaleY,
      );
      if (moustacheImage != null) {
        
        debugPrint('[log] : moustache_dimen => ${moustacheWidth} ${moustacheHeight}');


        canvas.drawImageRect(
          moustacheImage!,
          Rect.fromLTRB(0, 0, moustacheImage!.width.toDouble(),
              moustacheImage!.height.toDouble()),
          Rect.fromCenter(
            center: moustacheCenterPoints,
            width: moustacheWidth.toDouble(),
            height: moustacheHeight.toDouble() ,
          ), // Adjust rectangle size as needed
          Paint()
            ..color = Colors.green
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke,
        );
      } else {
        canvas.drawRect(
          Rect.fromCenter(
            center: moustacheCenterPoints,
            width: moustacheWidth.toDouble(),
            height: moustacheHeight.toDouble() ,
          ), // Adjust rectangle size as needed
          Paint()
            ..color = Colors.green
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke,
        );
      }
    }
  }

  Offset getMoustacheCenter(
    Point<num>? leftL,
    Point<num>? rightL,
    double sx,
    double sy,
  ) {
    Offset leftO = Offset.zero;
    Offset rightO = Offset.zero;

    if (leftL != null) {
      leftO = Offset(leftL.x * sx, leftL.y * sy);
    }

    if (rightL != null) {
      rightO = Offset(rightL.x * sx, rightL.y * sy);
    }

    double cx = (rightO.dx + leftO.dx) / 2;
    double cy = (rightO.dy + leftO.dy) / 2;

    Offset centerp = Offset(cx, cy);

    return centerp;
  }

  num getMoustacheDimensions(num? leftL, num? rightL) {
    leftL ??= 0.0;

    rightL ??= 0.0;

    return (rightL - leftL).abs();
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

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false; // Return true if you want to repaint when properties change
  }
}
