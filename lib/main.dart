import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moustache_ar/models/HiveImageModel.dart';
import 'package:moustache_ar/screens/image_detection/moustache_bloc/moustache_cubit.dart';
import 'package:moustache_ar/screens/image_detection/views/mstc_home.dart';
import 'package:hive/hive.dart';
import 'package:moustache_ar/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);

  Hive.registerAdapter(HiveImageModelAdapter());
  // Open the Hive box
  await Hive.openBox<HiveImageModel>(hiveMoustachedImageBox);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MoustacheCubit()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const AddMoustacheScreen(),
        home: const MoustacheHomeScreen(),
      ),
    );
  }
}

// https://pub.dev/publishers/flutter-ml.dev/packages
// https://stackoverflow.com/questions/57603146/how-to-convert-camera-image-to-image