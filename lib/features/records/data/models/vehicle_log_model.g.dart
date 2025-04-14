// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleLogModelAdapter extends TypeAdapter<VehicleLogModel> {
  @override
  final int typeId = 2;

  @override
  VehicleLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleLogModel(
      plateNumber: fields[0] as String,
      checkIn: fields[1] as DateTime,
      vehicleType: fields[5] as String?,
      checkOut: fields[2] as DateTime?,
      totalCost: fields[3] as double?,
      discount: fields[4] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.plateNumber)
      ..writeByte(1)
      ..write(obj.checkIn)
      ..writeByte(2)
      ..write(obj.checkOut)
      ..writeByte(3)
      ..write(obj.totalCost)
      ..writeByte(4)
      ..write(obj.discount)
      ..writeByte(5)
      ..write(obj.vehicleType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
