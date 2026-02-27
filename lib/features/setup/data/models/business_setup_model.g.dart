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
      name: fields[0] as String?,
      businessName: fields[1] as String,
      businessBrand: fields[2] as String,
      carHourCost: fields[3] as double,
      motorcycleHourCost: fields[4] as double,
      carMonthlyCost: fields[5] as double,
      motorcycleMonthlyCost: fields[6] as double,
      carDayCost: fields[7] as double,
      motorcycleDayCost: fields[8] as double,
      carNightCost: fields[9] as double,
      motorcycleNightCost: fields[10] as double,
      studentMotorcycleHourCost: fields[11] as double,
      footer: fields[17] as String?,
      businessId: fields[12] as String?,
      businessNit: fields[13] as String,
      businessResolution: fields[14] as String,
      address: fields[15] as String,
      schedule: fields[16] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BusinessSetupModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.businessName)
      ..writeByte(2)
      ..write(obj.businessBrand)
      ..writeByte(3)
      ..write(obj.carHourCost)
      ..writeByte(4)
      ..write(obj.motorcycleHourCost)
      ..writeByte(5)
      ..write(obj.carMonthlyCost)
      ..writeByte(6)
      ..write(obj.motorcycleMonthlyCost)
      ..writeByte(7)
      ..write(obj.carDayCost)
      ..writeByte(8)
      ..write(obj.motorcycleDayCost)
      ..writeByte(9)
      ..write(obj.carNightCost)
      ..writeByte(10)
      ..write(obj.motorcycleNightCost)
      ..writeByte(11)
      ..write(obj.studentMotorcycleHourCost)
      ..writeByte(12)
      ..write(obj.businessId)
      ..writeByte(13)
      ..write(obj.businessNit)
      ..writeByte(14)
      ..write(obj.businessResolution)
      ..writeByte(15)
      ..write(obj.address)
      ..writeByte(16)
      ..write(obj.schedule)
      ..writeByte(17)
      ..write(obj.footer);
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
