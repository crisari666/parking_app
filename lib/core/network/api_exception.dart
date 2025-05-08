import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final DioExceptionType? type;

  ApiException({
    required this.message,
    this.statusCode,
    this.type,
  });

  factory ApiException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timeout',
          type: error.type,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: error.response?.data['message'] ?? 'Server error',
          statusCode: error.response?.statusCode,
          type: error.type,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request cancelled',
          type: error.type,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection',
          type: error.type,
        );
      default:
        return ApiException(
          message: 'Something went wrong',
          type: error.type,
        );
    }
  }

  @override
  String toString() => message;
} 