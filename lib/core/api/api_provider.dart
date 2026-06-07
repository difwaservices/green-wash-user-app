import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../app/core/config/api_config.dart';
import 'auth_interceptor.dart';
import '../storage/secure_storage_service.dart';
import '../../main.dart'; // To access rootScaffoldMessengerKey

final storageServiceProvider = Provider((ref) => SecureStorageService());

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,

      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  final storage = ref.watch(storageServiceProvider);
  dio.interceptors.addAll([
    AuthInterceptor(dio, storage),
    InterceptorsWrapper(
      onError: (DioException e, handler) {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout ||
            e.type == DioExceptionType.connectionError) {
          
          final String errorMsg = e.type == DioExceptionType.connectionError 
              ? 'Cannot connect to server. Please ensure the server is running.'
              : 'Connection timed out. Please check your internet connection.';

          debugPrint(errorMsg);
        }
        return handler.next(e);
      },
    ),
    LogInterceptor(requestBody: true, responseBody: true), // For debugging
  ]);

  return dio;
});
