// part of 'moustache_cubit.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:moustache_ar/models/HiveImageModel.dart';

class MoustacheState extends Equatable {
  //

  final List<HiveImageModel> allImages;

  //
  final LoadingState imageLoadingState;
  final ui.Image? selectedImage;
  final LoadingState faceDetectedState;
  final List<Face> rect;
  final LoadingState moustacheLoadingState;
  final ui.Image? moustacheImage;

  const MoustacheState({
    this.allImages = const [],
    this.imageLoadingState = LoadingState.initial,
    this.selectedImage,
    this.faceDetectedState = LoadingState.initial,
    this.rect = const [],
    this.moustacheLoadingState = LoadingState.initial,
    this.moustacheImage,
  });

  MoustacheState copyWith({
    List<HiveImageModel>? allImages,
    LoadingState? imageLoadingState,
    ui.Image? selectedImage,
    LoadingState? faceDetectedState,
    List<Face>? rect,
    LoadingState? moustacheLoadingState,
    ui.Image? moustacheImage,
  }) {
    return MoustacheState(
      allImages: allImages ?? this.allImages,
      imageLoadingState: imageLoadingState ?? this.imageLoadingState,
      selectedImage: selectedImage ?? this.selectedImage,
      faceDetectedState: faceDetectedState ?? this.faceDetectedState,
      rect: rect ?? this.rect,
      moustacheLoadingState:
          moustacheLoadingState ?? this.moustacheLoadingState,
      moustacheImage: moustacheImage ?? this.moustacheImage,
    );
  }

  @override
  List<Object?> get props => [
        allImages,
        imageLoadingState,
        selectedImage,
        faceDetectedState,
        rect,
        moustacheLoadingState,
        moustacheImage,
      ];
}

enum LoadingState {
  initial,
  loaded,
  loading,
  errorLoading,
}
