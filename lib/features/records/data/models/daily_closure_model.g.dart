// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_closure_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyClosureModelAdapter extends TypeAdapter<DailyClosureModel> {
  @override
  final int typeId = 4;

  @override
  DailyClosureModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyClosureModel(
      date: fields[0] as DateTime,
      totalIncome: fields[1] as double,
      totalVehicles: fields[2] as int,
      vehiclesByType: (fields[3] as Map).cast<String, int>(),
      incomeByPaymentMethod: (fields[4] as Map).cast<String, double>(),
    );
  }

  @override
  void write(BinaryWriter writer, DailyClosureModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalIncome)
      ..writeByte(2)
      ..write(obj.totalVehicles)
      ..writeByte(3)
      ..write(obj.vehiclesByType)
      ..writeByte(4)
      ..write(obj.incomeByPaymentMethod);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyClosureModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
