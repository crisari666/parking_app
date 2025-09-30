class FinancialResumeModel {
  final DateTime date;
  final FinancialSummary summary;
  final FinancialStatistics statistics;
  final VehicleBreakdown vehicleBreakdown;

  FinancialResumeModel({
    required this.date,
    required this.summary,
    required this.statistics,
    required this.vehicleBreakdown,
  });

  factory FinancialResumeModel.fromJson(Map<String, dynamic> json) {
    return FinancialResumeModel(
      date: DateTime.parse(json['date'] as String),
      summary: FinancialSummary.fromJson(json['summary'] as Map<String, dynamic>),
      statistics: FinancialStatistics.fromJson(json['statistics'] as Map<String, dynamic>),
      vehicleBreakdown: VehicleBreakdown.fromJson(json['vehicleBreakdown'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'summary': summary.toJson(),
    'statistics': statistics.toJson(),
    'vehicleBreakdown': vehicleBreakdown.toJson(),
  };
}

class FinancialSummary {
  final double totalPaidByVehicles;
  final double totalReceivedByMemberships;
  final double totalRevenue;

  FinancialSummary({
    required this.totalPaidByVehicles,
    required this.totalReceivedByMemberships,
    required this.totalRevenue,
  });

  factory FinancialSummary.fromJson(Map<String, dynamic> json) {
    return FinancialSummary(
      totalPaidByVehicles: (json['totalPaidByVehicles'] as num).toDouble(),
      totalReceivedByMemberships: (json['totalReceivedByMemberships'] as num).toDouble(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalPaidByVehicles': totalPaidByVehicles,
    'totalReceivedByMemberships': totalReceivedByMemberships,
    'totalRevenue': totalRevenue,
  };
}

class FinancialStatistics {
  final int totalVehiclesProcessed;
  final int totalActiveMemberships;
  final double averageVehiclePayment;
  final double averageMembershipValue;

  FinancialStatistics({
    required this.totalVehiclesProcessed,
    required this.totalActiveMemberships,
    required this.averageVehiclePayment,
    required this.averageMembershipValue,
  });

  factory FinancialStatistics.fromJson(Map<String, dynamic> json) {
    return FinancialStatistics(
      totalVehiclesProcessed: json['totalVehiclesProcessed'] as int,
      totalActiveMemberships: json['totalActiveMemberships'] as int,
      averageVehiclePayment: (json['averageVehiclePayment'] as num).toDouble(),
      averageMembershipValue: (json['averageMembershipValue'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalVehiclesProcessed': totalVehiclesProcessed,
    'totalActiveMemberships': totalActiveMemberships,
    'averageVehiclePayment': averageVehiclePayment,
    'averageMembershipValue': averageMembershipValue,
  };
}

class VehicleBreakdown {
  final VehicleTypeData car;
  final VehicleTypeData motorcycle;

  VehicleBreakdown({
    required this.car,
    required this.motorcycle,
  });

  factory VehicleBreakdown.fromJson(Map<String, dynamic> json) {
    return VehicleBreakdown(
      car: VehicleTypeData.fromJson(json['car'] as Map<String, dynamic>),
      motorcycle: VehicleTypeData.fromJson(json['motorcycle'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'car': car.toJson(),
    'motorcycle': motorcycle.toJson(),
  };
}

class VehicleTypeData {
  final int count;
  final double totalCost;

  VehicleTypeData({
    required this.count,
    required this.totalCost,
  });

  factory VehicleTypeData.fromJson(Map<String, dynamic> json) {
    return VehicleTypeData(
      count: json['count'] as int,
      totalCost: (json['totalCost'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'count': count,
    'totalCost': totalCost,
  };
}
