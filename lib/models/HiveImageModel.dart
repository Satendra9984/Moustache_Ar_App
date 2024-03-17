import 'dart:typed_data';

import 'package:hive/hive.dart';
part 'HiveImageModel.g.dart';

@HiveType(typeId: 0) // HiveType annotation is required to register the class with Hive.
class HiveImageModel extends HiveObject {
  @HiveField(0)
  String tag;

  @HiveField(1)
  int id;

  @HiveField(2)
  Uint8List data;

  HiveImageModel({required this.tag, required this.id, required this.data});
}
