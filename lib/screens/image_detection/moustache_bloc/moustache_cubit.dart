import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:moustache_ar/models/HiveImageModel.dart';
import 'package:moustache_ar/screens/image_detection/moustache_bloc/moustache_state.dart';
import 'package:moustache_ar/utils/file_utils.dart';
import 'package:moustache_ar/utils/local_storage_utils.dart';
import 'package:moustache_ar/utils/ml_vision_util.dart';

class MoustacheCubit extends Cubit<MoustacheState> {
  MoustacheCubit()
      : super(
          const MoustacheState(),
        );

  Future<void> initialize() async {
    debugPrint('[log]:[All Images Length] ${LocalStorageUtils().retrieveAllMyData().length}');
    emit(
      state.copyWith(
        selectedImage: null,
        imageLoadingState: LoadingState.initial,
        faceDetectedState: LoadingState.initial,
        rect: const [],
        allImages: LocalStorageUtils().retrieveAllMyData(),
      ),
    );
  }

  Future<void> refresh() async {
    emit(
      state.copyWith(
        allImages: LocalStorageUtils().retrieveAllMyData(),
        selectedImage: null,
        imageLoadingState: LoadingState.initial,
        faceDetectedState: LoadingState.initial,
        rect: const [],
      ),
    );
  }

  Future<void> pickImageAndDetectFaces() async {
    emit(state.copyWith(imageLoadingState: LoadingState.loading));

    (ui.Image?, String?) gimagedata = await FileUtils().getUiImageFromGallery();
    ui.Image? galleryImage = gimagedata.$1;
    String? galleryImagePath = gimagedata.$2;

    if (galleryImage == null) {
      emit(state.copyWith(imageLoadingState: LoadingState.errorLoading));
      return;
    }

    emit(state.copyWith(
      selectedImage: galleryImage,
      imageLoadingState: LoadingState.loaded,
      faceDetectedState: LoadingState.loading,
    ));

    try {
      final List<Face> faces = await MlVisionFaceDetectorUtil()
          .detectFaceFromImage(galleryImagePath!);

      emit(
        state.copyWith(
          faceDetectedState: LoadingState.loaded,
          rect: faces,
        ),
      );
    } catch (e) {
      debugPrint('[log]: ${e.toString()}');
      emit(
        state.copyWith(
          faceDetectedState: LoadingState.errorLoading,
        ),
      );
    }
  }

  Future<void> loadInitialMoustacheImage() async {
    debugPrint('[moustache] : called');
    emit(state.copyWith(
      moustacheLoadingState: LoadingState.loading,
    ));
    try {
      ui.Image? mimage = await FileUtils().getUiImageFromAssets(
        'assets/images/moustaches-collection/moustache_7.png',
      );

      
      if (mimage == null) {
        emit(
          state.copyWith(
            moustacheImage: mimage,
            moustacheLoadingState: LoadingState.errorLoading,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          moustacheImage: mimage,
          moustacheLoadingState: LoadingState.loaded,
        ),
      );
    } catch (e) {
      debugPrint('[log] : moustacheloadingerror $e');
      emit(
        state.copyWith(
          moustacheLoadingState: LoadingState.errorLoading,
        ),
      );
    }
  }

  Future<void> changeMoustacheImage(String path) async {
    debugPrint('[moustache] : called');
    emit(state.copyWith(
      moustacheLoadingState: LoadingState.loading,
    ));
    try {
      ui.Image? mimage = await FileUtils().getUiImageFromAssets(path);

      mimage;
      if (mimage == null) {
        emit(
          state.copyWith(
            moustacheImage: mimage,
            moustacheLoadingState: LoadingState.errorLoading,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          moustacheImage: mimage,
          moustacheLoadingState: LoadingState.loaded,
        ),
      );
    } catch (e) {
      debugPrint('[log] : moustacheloadingerror $e');
      emit(
        state.copyWith(
          moustacheLoadingState: LoadingState.errorLoading,
        ),
      );
    }
  }

  Future<void> saveMoustachedImage(Uint8List mImage, String tag) async {
    List<HiveImageModel> allms = [...state.allImages];

    HiveImageModel newim =
        HiveImageModel(tag: tag, id: allms.length, data: mImage);

    allms.add(newim);

    await LocalStorageUtils().storeMyData(newim).then((value) {
      emit(state.copyWith(
        allImages: allms,
      ));
    });
  }
}
