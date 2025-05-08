// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_setup_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessSetupModelAdapter extends TypeAdapter<BusinessSetupModel> {
  @override
  final int typeId = 1;

  @override
  BusinessSetupModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BusinessSetupModel(
      businessName: fields[0] as String,
      businessBrand: fields[1] as String,
      carHourCost: fields[2] as double,
      motorcycleHourCost: fields[3] as double,
      carMonthlyCost: fields[4] as double,
      motorcycleMonthlyCost: fields[5] as double,
      carDayCost: fields[6] as double,
      motorcycleDayCost: fields[7] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessSetupModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.businessName)
      ..writeByte(1)
      ..write(obj.businessBrand)
      ..writeByte(2)
      ..write(obj.carHourCost)
      ..writeByte(3)
      ..write(obj.motorcycleHourCost)
      ..writeByte(4)
      ..write(obj.carMonthlyCost)
      ..writeByte(5)
      ..write(obj.motorcycleMonthlyCost)
      ..writeByte(6)
      ..write(obj.carDayCost)
      ..writeByte(7)
      ..write(obj.motorcycleDayCost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessSetupModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
