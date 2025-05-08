import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:quantum_parking_flutter/core/config/env.dart';
import 'package:quantum_parking_flutter/core/utils/network_utils.dart';

class ApiClient {
  late final Dio _dio;
  final _logger = Logger();
  
  ApiClient() {
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    final baseUrl = await NetworkUtils.getBaseUrl(Env.apiUrl);
    
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ), 
    );

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        _logger.i('REQUEST[${options.method}] => PATH: ${options.path}');
        _logger.d('REQUEST HEADERS: ${options.headers}');
        _logger.d('REQUEST DATA: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        _logger.i('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
        _logger.d('RESPONSE DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        _logger.e('ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}');
        _logger.e('ERROR MESSAGE: ${e.message}');
        return handler.next(e);
      },
    ));

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  Dio get dio => _dio;

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }
} 