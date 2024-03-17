import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moustache_ar/screens/image_detection/moustache_bloc/moustache_cubit.dart';
import 'package:moustache_ar/screens/image_detection/moustache_bloc/moustache_state.dart';
import 'package:moustache_ar/screens/image_detection/views/moustache_painter.dart';
import 'package:moustache_ar/screens/widgets/add_tag_widget.dart';
import 'package:moustache_ar/screens/widgets/moustache_options_selection_widget.dart';
import 'package:moustache_ar/utils/image_util.dart';

class MoustacheViewerScreen extends StatefulWidget {
  const MoustacheViewerScreen({super.key});

  @override
  State<MoustacheViewerScreen> createState() => _MoustacheViewerScreenState();
}

class _MoustacheViewerScreenState extends State<MoustacheViewerScreen> {
  final GlobalKey _widgetKey = GlobalKey();

  @override
  void initState() {
    debugPrint('[moustache] : called');
    // context.read<MoustacheCubit>().loadInitialMoustacheImage();f

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MoustacheCubit, MoustacheState>(
      listener: (ctx, state) {
        // Do not call cubit methods here only ui methods else causes error
        // if (state.moustacheLoadingState == LoadingState.initial ) {
        //   context.read<MoustacheCubit>().loadInitialMoustacheImage();
        // }
        state;

        if (state.imageLoadingState == LoadingState.errorLoading) {
          // [TODO] : SHOW SNACKBAR
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Center(
              child: Builder(
                builder: (ctx) {
                  if (state.moustacheLoadingState == LoadingState.initial) {
                    context.read<MoustacheCubit>().loadInitialMoustacheImage();
                  }

                  if (state.imageLoadingState == LoadingState.loading ||
                      state.faceDetectedState == LoadingState.loading ||
                      state.moustacheLoadingState == LoadingState.loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state.faceDetectedState == LoadingState.loaded &&
                      state.moustacheLoadingState == LoadingState.loaded) {
                    return Column(
                      children: [
                        AppBar(
                          actions: [
                            IconButton(
                              onPressed: () {
                                context.read<MoustacheCubit>().refresh();
                              },
                              icon: const Icon(Icons.refresh_rounded),
                            ),
                            IconButton(
                              onPressed: () async {
                                await _captureScreenshot().then((ss) async {
                                  if (ss == null) return;

                                  await showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return Dialog(
                                          child: AddTagWidget(),
                                        );
                                      }).then((value) async {
                                    debugPrint('[poped] : $value');
                                    if (value == null) return;
                                    await context
                                        .read<MoustacheCubit>()
                                        .saveMoustachedImage(
                                            ss, value.toString())
                                        .then((value) {
                                      Navigator.pop(context);
                                    });
                                  });
                                });
                              },
                              icon: const Icon(Icons.save_alt_rounded),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height-86.0,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              RepaintBoundary(
                                key: _widgetKey,
                                child: Center(
                                  child: AspectRatio(
                                    aspectRatio:
                                        state.selectedImage!.width /
                                            state.selectedImage!.height,
                                    child: CustomPaint(
                                      painter: FacePainter(
                                        faceRects: state.rect,
                                        imageFile: state.selectedImage!,
                                        moustacheImage:
                                            state.moustacheImage,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 80.0,
                                child: MoustacheSelectionWidget(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  if (state.imageLoadingState == LoadingState.loaded) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: state.selectedImage!.width /
                            state.selectedImage!.height,
                        child: FutureBuilder<Uint8List?>(
                          future: ImageUtils()
                              .getUint8ListFromImage(state.selectedImage!),
                          builder: (ctx, snap) {
                            if (snap.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snap.hasError) {
                              return const Text('Something Went Wrong');
                            }

                            return Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: state.selectedImage!.width /
                                      state.selectedImage!.height,
                                  child: Image.memory(
                                    snap.data!,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  }

                  return const Center(
                    child: Text('Something Went Wrong'),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List?> _captureScreenshot() async {
    try {
      RenderRepaintBoundary boundary = _widgetKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(
          pixelRatio: MediaQuery.of(context).devicePixelRatio);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List screenshotBytes = byteData!.buffer.asUint8List();

      return screenshotBytes;
    } catch (e) {
      print('Error capturing screenshot: $e');
      // Handle error
    }
    return null;
  }
}
