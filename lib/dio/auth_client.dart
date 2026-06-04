import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthClient {

  static final Dio authDio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8080/auth",
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10)
    )
  );
}


final dioProvider = Provider<Dio> ((ref) {
  return AuthClient.authDio;
});