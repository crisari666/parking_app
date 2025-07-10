import 'package:quantum_parking_flutter/core/utils/date_time_service.dart';

/// Extensions for DateTime to make timezone handling easier
extension DateTimeExtensions on DateTime {
  /// Convert to app timezone (EST/EDT)
  DateTime get toAppTimezone => DateTimeService.fromUtc(this);
  
  /// Convert to UTC
  DateTime get toUtcTime => DateTimeService.toUtc(this);
  
  /// Format for display
  String format({String format = 'dd/MM/yyyy HH:mm'}) {
    return DateTimeService.formatDateTime(this, format: format);
  }
  
  /// Format date only
  String formatDate({String format = 'dd/MM/yyyy'}) {
    return DateTimeService.formatDate(this, format: format);
  }
  
  /// Format time only
  String formatTime({String format = 'HH:mm'}) {
    return DateTimeService.formatTime(this, format: format);
  }
  
  /// Check if this DateTime is in the future
  bool get isFuture => DateTimeService.isFuture(this);
  
  /// Check if this DateTime is in the past
  bool get isPast => DateTimeService.isPast(this);
  
  /// Get start of day
  DateTime get startOfDay => DateTimeService.startOfDay(this);
  
  /// Get end of day
  DateTime get endOfDay => DateTimeService.endOfDay(this);
  
  /// Calculate duration from this DateTime to another
  Duration durationTo(DateTime other) {
    return DateTimeService.calculateDuration(this, other);
  }
  
  /// Calculate duration from another DateTime to this one
  Duration durationFrom(DateTime other) {
    return DateTimeService.calculateDuration(other, this);
  }
}

/// Extension for nullable DateTime
extension NullableDateTimeExtensions on DateTime? {
  /// Safely format DateTime, returns empty string if null
  String format({String format = 'dd/MM/yyyy HH:mm'}) {
    if (this == null) return '';
    return DateTimeService.formatDateTime(this!, format: format);
  }
  
  /// Safely format date, returns empty string if null
  String formatDate({String format = 'dd/MM/yyyy'}) {
    if (this == null) return '';
    return DateTimeService.formatDate(this!, format: format);
  }
  
  /// Safely format time, returns empty string if null
  String formatTime({String format = 'HH:mm'}) {
    if (this == null) return '';
    return DateTimeService.formatTime(this!, format: format);
  }
} 