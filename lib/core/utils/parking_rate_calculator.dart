import 'package:quantum_parking_flutter/features/setup/data/models/business_setup_model.dart';

/// Service for calculating parking rates and billable hours
/// 
/// Business Rules:
/// - Minimum charge is 1 hour
/// - 10 minutes grace period after each hour
/// - For times ≤ 70 minutes (1 hour + 10 min grace): charge 1 hour
/// - For times > 70 charge additional hours with grace periods
/// 
/// Examples:
/// - 65 min → 1 hour charge
/// - 90 min → 2 hours charge
/// - 121 min → 2 hours charge
/// - 130 min → 2 hours charge
/// - 131 min → 3 hours charge
class ParkingRateCalculator {
  static const int _gracePeriodMinutes = 10;
  static const int _minimumBillableMinutes = 60;
  static const int _firstHourWithGrace = _minimumBillableMinutes + _gracePeriodMinutes; // 70 min

  /// Calculate billable hours based on total parking minutes
  static int calculateBillableHours(int totalMinutes) {
    if (totalMinutes <= _firstHourWithGrace) {
      // If total time is 70 minutes or less (1 hour + 10 min grace), charge 1 hour
      return 1;
    } else {
      // For times over 70 minutes, calculate additional hours
      // Subtract the first 70 minutes (1 hour + 10 min grace)
      final remainingMinutes = totalMinutes - _firstHourWithGrace;
      // Calculate additional hours needed (rounding up)
      final additionalHours = (remainingMinutes / _minimumBillableMinutes).ceil();
      return 1 + additionalHours;
    }
  }

  /// Calculate parking cost based on vehicle type, student rate, and parking duration
  static double calculateParkingCost({
    required int totalMinutes,
    required String vehicleType,
    required BusinessSetupModel businessSetup,
    required bool isStudentRate,
  }) {
    final billableHours = calculateBillableHours(totalMinutes);
    final ratePerHour = _getRatePerHour(vehicleType, businessSetup, isStudentRate);
    return billableHours * ratePerHour;
  }

  /// Get the appropriate hourly rate based on vehicle type and student status
  static double _getRatePerHour(
    String vehicleType,
    BusinessSetupModel businessSetup,
    bool isStudentRate,
  ) {
    if (vehicleType.toLowerCase().contains('car')) {
      return businessSetup.carHourCost;
    } else {
      // For motorcycles, check if student rate should be applied
      return isStudentRate 
          ? businessSetup.studentMotorcycleHourCost 
          : businessSetup.motorcycleHourCost;
    }
  }

  /// Calculate billable hours from a payment value and rate
  /// This is useful when recalculating costs after rate changes
  static double calculateBillableHoursFromPayment(double paymentValue, double ratePerHour) {
    if (ratePerHour <= 0) return 0;
    return paymentValue / ratePerHour;
  }

  /// Recalculate payment value when rate changes
  static double recalculatePaymentValue({
    required double currentPaymentValue,
    required double currentRatePerHour,
    required double newRatePerHour,
  }) {
    final billableHours = calculateBillableHoursFromPayment(currentPaymentValue, currentRatePerHour);
    return billableHours * newRatePerHour;
  }

  /// Format parking time for display
  static String formatParkingTime(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours > 0) {
      return '${hours}h, ${minutes.toString().padLeft(2, '0')}m';
    } else {
      return '${minutes}m';
    }
  }

  /// Get parking time string in minutes format (for API compatibility)
  static String getParkingTimeString(int totalMinutes) {
    return '${totalMinutes}m';
  }
} 