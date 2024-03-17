// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HiveImageModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveImageModelAdapter extends TypeAdapter<HiveImageModel> {
  @override
  final int typeId = 0;

  @override
  HiveImageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveImageModel(
      tag: fields[0] as String,
      id: fields[1] as int,
      data: fields[2] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, HiveImageModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.tag)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveImageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
