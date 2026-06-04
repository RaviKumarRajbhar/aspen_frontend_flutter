import 'package:aspen_app/dio/auth_client.dart';
import 'package:aspen_app/interceptor/auth_interceptor.dart';
import 'package:aspen_app/service/auth_service.dart';
import 'package:aspen_app/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final universalDioProvider = Provider<Dio> ((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8080",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      // headers: {
      //   "Content-Type" : "application/json"
      // }
    )
  );

  final tokenStorage = ref.read(tokenStorageProvider);
  final authService = ref.read(authServiceProvider);
  final authDio = ref.read(dioProvider);

  dio.interceptors.clear();

  dio.interceptors.add(
    AuthInterceptor(tokenStorage, authService, authDio)
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
    ),
  );

  return dio;
});