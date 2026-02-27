// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_printer_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StoredPrinterModelAdapter extends TypeAdapter<StoredPrinterModel> {
  @override
  final int typeId = 11;

  @override
  StoredPrinterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StoredPrinterModel(
      macAddress: fields[0] as String,
      name: fields[1] as String,
      createdAt: fields[2] as DateTime,
      updatedAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, StoredPrinterModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.macAddress)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoredPrinterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
