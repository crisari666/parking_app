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
  final bool hasMembership;
  final String? membershipId;

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
    required this.hasMembership,
    this.membershipId,
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
      hasMembership: json['hasMembership'] as bool? ?? false,
      membershipId: json['membershipId'] as String?,
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
    'hasMembership': hasMembership,
    'membershipId': membershipId,
  };
}

/// Consolidated data structure for checkout operations
/// This ensures consistent data for printing and UI display
class CheckOutData {
  final String plateNumber;
  final String vehicleType;
  final DateTime checkInTime;
  final DateTime checkOutTime;
  final int durationMinutes;
  final double totalCost;
  final double? discount;
  final String? paymentMethod;
  final String parkingTimeString;
  final VehicleLogResponseModel originalResponse;

  CheckOutData({
    required this.plateNumber,
    required this.vehicleType,
    required this.checkInTime,
    required this.checkOutTime,
    required this.durationMinutes,
    required this.totalCost,
    this.discount,
    this.paymentMethod,
    required this.parkingTimeString,
    required this.originalResponse,
  });

  /// Create CheckOutData from VehicleLogResponseModel and additional checkout info
  factory CheckOutData.fromVehicleLogResponse(
    VehicleLogResponseModel response,
    DateTime checkOutTime,
    double? discount,
    String? paymentMethod,
    String parkingTimeString,
  ) {
    return CheckOutData(
      plateNumber: response.vehicleId,
      vehicleType: response.vehicleType,
      checkInTime: response.entryTime,
      checkOutTime: checkOutTime,
      durationMinutes: response.duration,
      totalCost: response.cost.toDouble(),
      discount: discount,
      paymentMethod: paymentMethod ?? response.paymentMethod?.name,
      parkingTimeString: parkingTimeString,
      originalResponse: response,
    );
  }

  /// Get the final cost after discount
  double get finalCost {
    if (discount != null && discount! > 0) {
      return totalCost - discount!;
    }
    return totalCost;
  }

  /// Get formatted duration string
  String get formattedDuration {
    final hours = durationMinutes ~/ 60;
    final minutes = durationMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get payment method display name
  String get paymentMethodDisplay {
    switch (paymentMethod?.toLowerCase()) {
      case 'cash':
        return 'EFECTIVO';
      case 'transfer':
        return 'TRANSFERENCIA';
      case 'credit':
        return 'CREDITO';
      case 'debit':
        return 'DEBITO';
      case 'other':
        return 'OTRO';
      default:
        return paymentMethod?.toUpperCase() ?? 'EFECTIVO';
    }
  }
} 