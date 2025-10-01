import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/intl.dart';

/// Centralized DateTime service for handling timezone conversions
/// and providing consistent DateTime handling across the app
class DateTimeService {
  static const String _defaultTimezone = 'America/Bogota'; // EST/EDT
  static const int _defaultOffsetHours = -5; // EST offset
  
  static bool _initialized = false;
  
  /// Initialize timezone data
  static void initialize() {
    if (!_initialized) {
      tz.initializeTimeZones();
      _initialized = true;
    }
  }
  
  /// Get current DateTime in the app's timezone (EST/EDT)
  static DateTime now() {
    initialize();
    try {
      return tz.TZDateTime.now(tz.getLocation(_defaultTimezone));
    } catch (e) {
      // Fallback to UTC - 5 hours if timezone location fails
      return DateTime.now().toUtc().add(const Duration(hours: _defaultOffsetHours));
    }
  }
  
  /// Convert UTC DateTime to app timezone
  static DateTime fromUtc(DateTime utcDateTime) {
    initialize();
    try {
      return tz.TZDateTime.from(utcDateTime, tz.getLocation(_defaultTimezone));
    } catch (e) {
      // Fallback to manual conversion
      return utcDateTime.add(const Duration(hours: _defaultOffsetHours));
    }
  }
  
  /// Convert DateTime to UTC
  static DateTime toUtc(DateTime localDateTime) {
    initialize();
    try {
      final tzDateTime = tz.TZDateTime.from(localDateTime, tz.getLocation(_defaultTimezone));
      return tzDateTime.toUtc();
    } catch (e) {
      // Fallback to manual conversion
      return localDateTime.subtract(const Duration(hours: _defaultOffsetHours));
    }
  }
  
  /// Format DateTime for display
  static String formatDateTime(DateTime dateTime, {String format = 'dd/MM/yyyy HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }
  
  /// Format date only
  static String formatDate(DateTime dateTime, {String format = 'dd/MM/yyyy'}) {
    return DateFormat(format).format(dateTime);
  }
  
  /// Format time only
  static String formatTime(DateTime dateTime, {String format = 'HH:mm'}) {
    return DateFormat(format).format(dateTime);
  }
  
  /// Get formatted current date
  static String getCurrentDate({String format = 'dd/MM/yyyy'}) {
    return formatDate(now(), format: format);
  }
  
  /// Get formatted current time
  static String getCurrentTime({String format = 'HH:mm'}) {
    return formatTime(now(), format: format);
  }
  
  /// Get formatted current date and time
  static String getCurrentDateTime({String format = 'dd/MM/yyyy HH:mm'}) {
    return formatDateTime(now(), format: format);
  }
  
  /// Calculate duration between two dates
  static Duration calculateDuration(DateTime start, DateTime end) {
    return end.difference(start);
  }
  
  /// Get timezone name
  static String getTimezoneName() {
    return _defaultTimezone;
  }
  
  /// Get timezone offset in hours
  static int getTimezoneOffset() {
    return _defaultOffsetHours;
  }
  
  /// Check if a DateTime is in the future
  static bool isFuture(DateTime dateTime) {
    return dateTime.isAfter(now());
  }
  
  /// Check if a DateTime is in the past
  static bool isPast(DateTime dateTime) {
    return dateTime.isBefore(now());
  }
  
  /// Get start of day for a given date
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
  
  /// Get end of day for a given date
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
  
  /// Parse DateTime from string with timezone consideration
  static DateTime? parseDateTime(String dateString) {
    try {
      final parsed = DateTime.parse(dateString);
      // If the parsed date is in UTC, convert to local timezone
      if (parsed.isUtc) {
        return fromUtc(parsed);
      }
      return parsed;
    } catch (e) {
      return null;
    }
  }
} 