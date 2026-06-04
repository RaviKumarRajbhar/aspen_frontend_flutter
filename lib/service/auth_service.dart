import 'package:aspen_app/dio/auth_client.dart';
import 'package:aspen_app/service/google_auth_service.dart';
import 'package:aspen_app/token_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/api_response.dart';

class AuthService {


  final Dio dio;

  AuthService(this.dio);


  final Dio refreshDio = Dio(
    BaseOptions( baseUrl: "http://localhost:8080/auth")
  );

  Future<Response> refreshToken(
      String refreshToken,
      ) async {

    return await refreshDio.post("/refresh",
      data: {
        "refreshToken": refreshToken,
      },
    );
  }

  Future<ApiResponse<Map<String,dynamic>>> googleLogin(String idToken ) async {

    try {

      final response = await dio.post( "/google",
        data: {
          "idToken": idToken,
        },
      );

      return ApiResponse( success: true, data: response.data);

    } catch (e) {

      return ApiResponse( success: false, error: e.toString(),
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> login(String email,
      String password) async {
    try {
      final response = await dio.post("/login",
          data: {
            "email": email,
            "password": password
          });


      return ApiResponse(success: true, data: response.data);
    } on DioException catch (e) {

      final message = e.response?.data?["message"] ?? "Something went wrong";

      return ApiResponse(success: false, error: message);
    } catch (e) {
      return ApiResponse(success: false, error: "Unexpected Error");
    }
  }


  Future<ApiResponse<Map<String, dynamic>>> register(String name, String email,
      String password) async {
    try {
      final response = await dio.post("/register",
          data: {
            "name": name,
            "email": email,
            "password": password
          });

      return ApiResponse(success: true, data: response.data);
    } catch (e) {
      return ApiResponse(success: false, error: e.toString());
    }
  }

}
final authServiceProvider = Provider<AuthService> ((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});