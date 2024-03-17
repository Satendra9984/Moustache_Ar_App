import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moustache_ar/models/HiveImageModel.dart';
import 'package:moustache_ar/screens/image_detection/moustache_bloc/moustache_cubit.dart';
import 'package:moustache_ar/screens/image_detection/moustache_bloc/moustache_state.dart';
import 'package:moustache_ar/screens/image_detection/views/moustache_viewer_screen.dart';
import 'package:moustache_ar/utils/file_utils.dart';

class MoustacheHomeScreen extends StatefulWidget {
  const MoustacheHomeScreen({super.key});

  @override
  State<MoustacheHomeScreen> createState() => _MoustacheHomeScreenState();
}

class _MoustacheHomeScreenState extends State<MoustacheHomeScreen> {
  @override
  void initState() {
    context.read<MoustacheCubit>().initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Moustache App'),
      ),
      body: BlocConsumer<MoustacheCubit, MoustacheState>(
        listener: (ctx, state) {
          if (state.imageLoadingState == LoadingState.loading) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => const MoustacheViewerScreen(),
              ),
            );
          }
        },
        builder: (ctx, state) {
          // var cubit = context.read<MoustacheCubit>();

          return Container(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: GridView.builder(
              itemCount: state.allImages.length,
              itemBuilder: (ctx, index) {
                HiveImageModel imageModel = state.allImages[index];
                return GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (ctx) {
                        return Image.memory(
                          imageModel.data,
                          fit: BoxFit.contain,
                        );
                      },
                    );
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AspectRatio(
                          aspectRatio: 1.0,
                          child: Image.memory(
                            imageModel.data,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text('#${imageModel.tag}'),
                    ],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 0.9,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.read<MoustacheCubit>().pickImageAndDetectFaces(),
        child: const Icon(Icons.add_a_photo_rounded),
      ),
    );
  }
}
