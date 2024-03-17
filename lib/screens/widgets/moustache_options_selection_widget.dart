import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moustache_ar/screens/image_detection/moustache_bloc/moustache_cubit.dart';

class MoustacheSelectionWidget extends StatelessWidget {
  const MoustacheSelectionWidget({super.key});

  final List<String> _moustachesAssetsList = const [
    'assets/images/moustaches-collection/moustache_7.png',
    'assets/images/moustaches-collection/moustache_7.png',
    'assets/images/moustaches-collection/moustache_7.png',
    'assets/images/moustaches-collection/moustache_7.png',
    'assets/images/moustaches-collection/moustache_7.png',
    'assets/images/moustaches-collection/moustache_7.png',
    'assets/images/moustaches-collection/moustache_7.png',
    'assets/images/moustaches-collection/moustache_7.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _moustachesAssetsList.length,
      itemBuilder: (ctx, index) {
        return GestureDetector(
          onTap: () {
            // [TODO] : CHANGE MOUSTACHES
            context
                .read<MoustacheCubit>()
                .changeMoustacheImage(_moustachesAssetsList[index]);
          },
          child: Container(
            // height: 10.0,
            width: 80.0,
            margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
            padding:
                const EdgeInsets.symmetric(horizontal: 4.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(500.0),
              shape: BoxShape.rectangle,
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.asset(
                _moustachesAssetsList[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
