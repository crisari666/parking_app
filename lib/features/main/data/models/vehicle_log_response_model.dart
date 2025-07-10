enum PaymentMethod {
  cash(0),
  transfer(1),
  credit(2),
  debit(3),
  other(4);

  bool get isCash => this == PaymentMethod.cash;
  bool get isTransfer => this == PaymentMethod.transfer;
  bool get isCredit => this == PaymentMethod.credit;
  bool get isDebit => this == PaymentMethod.debit;
  bool get isOther => this == PaymentMethod.other;

  final int value;
  const PaymentMethod(this.value);

  static PaymentMethod fromValue(int value) {
    return PaymentMethod.values.firstWhere(
      (method) => method.value == value,
      orElse: () => PaymentMethod.other,
    );
  }

  bool get isValid => this != PaymentMethod.other;
}

class VehicleLogResponseModel {
  final String vehicleId;
  final String businessId;
  final String vehicleType;
  final DateTime entryTime;
  final DateTime? exitTime;
  final int duration;
  final int cost;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final PaymentMethod? paymentMethod;

  VehicleLogResponseModel({
    required this.vehicleId,
    required this.businessId,
    required this.vehicleType,
    required this.entryTime,
    this.exitTime,
    required this.duration,
    required this.cost,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.paymentMethod,
  });

  factory VehicleLogResponseModel.fromJson(Map<String, dynamic> json) {
    return VehicleLogResponseModel(
      vehicleId: json['vehicleId'] as String,
      businessId: json['businessId'] as String,
      vehicleType: json['vehicleType'] as String,
      entryTime: DateTime.parse(json['entryTime'] as String),
      exitTime: json['exitTime'] != null ? DateTime.parse(json['exitTime'] as String) : null,
      duration: json['duration'] as int,
      cost: json['cost'] as int,
      id: json['_id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      v: json['__v'] as int,
      paymentMethod: json['paymentMethod'] != null 
          ? PaymentMethod.fromValue(json['paymentMethod'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'vehicleId': vehicleId,
    'businessId': businessId,
    'vehicleType': vehicleType,
    'entryTime': entryTime.toIso8601String(),
    'exitTime': exitTime?.toIso8601String(),
    'duration': duration,
    'cost': cost,
    '_id': id,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    '__v': v,
    'paymentMethod': paymentMethod?.value,
  };
} 