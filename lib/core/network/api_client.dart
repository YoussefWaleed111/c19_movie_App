import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiClient {
  late final Dio _dio;

  ApiClient({Dio? dio}) {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ),
    );
  }

  Dio get dio => _dio;

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ApiException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timed out. Please check your internet connection.',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final responseData = error.response?.data;
        String errorMessage = 'Server error occurred ($statusCode)';
        if (responseData is Map && responseData.containsKey('status_message')) {
          errorMessage = responseData['status_message'].toString();
        }
        return ApiException(
          message: errorMessage,
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: 'Request was cancelled',
          statusCode: error.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection detected.',
          statusCode: error.response?.statusCode,
        );
      default:
        return ApiException(
          message: error.message ?? 'Unexpected error occurred',
          statusCode: error.response?.statusCode,
        );
    }
  }
}
