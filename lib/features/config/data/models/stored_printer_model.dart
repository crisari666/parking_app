import 'package:hive/hive.dart';
part 'stored_printer_model.g.dart';

@HiveType(typeId: 11)
class StoredPrinterModel extends HiveObject {
  @HiveField(0)
  final String macAddress;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final DateTime updatedAt;

  StoredPrinterModel({
    required this.macAddress,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  StoredPrinterModel copyWith({
    String? macAddress,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StoredPrinterModel(
      macAddress: macAddress ?? this.macAddress,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() =>
      'StoredPrinterModel(macAddress: $macAddress, name: $name)';
}
