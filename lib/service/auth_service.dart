import 'package:aspen_app/dio/auth_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/api_response.dart';

class AuthService {

  final Dio dio;

  AuthService(this.dio);


  final Dio refreshDio = Dio(BaseOptions( baseUrl: "http://localhost:8080/auth"));

  Future<Response> refreshToken( String refreshToken) async {

    return await refreshDio.post("/refresh",
      data: {
        "refreshToken": refreshToken,
      },
    );
  }

  Future<ApiResponse<Map<String, dynamic>>> googleLogin(String idToken) async {
    try {
      final response = await dio.post(
        "/google",
        data: {
          "idToken": idToken,
        },
      );

      return ApiResponse(
        success: true,
        data: response.data,
      );

    } on DioException catch (e) {
      final data = e.response?.data;

      String message = "Google login failed";

      if (data is Map) {
        message = data["error"]?.toString()
            ?? data["message"]?.toString()
            ?? "Google login failed";
      }

      return ApiResponse(
        success: false,
        error: message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: "Google login failed",
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
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


  Future<ApiResponse<Map<String, dynamic>>> register(
      String name,
      String email,
      String password,
      ) async {
    try {
      final response = await dio.post(
        "/register/initiate",
        data: {
          "username": name,
          "email": email,
          "password": password,
        },
      );

      return ApiResponse(
        success: true,
        data: {
          "message": response.data,
        },
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      String message = "Registration failed";

      if (data is Map) {
        message = data["message"]?.toString()
            ?? data["error"]?.toString()
            ?? "Registration failed";
      } else if (data is String) {
        message = data;
      }

      return ApiResponse(
        success: false,
        error: message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: "Registration failed",
      );
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyOtp(
      String email,
      String otp,
      ) async {
    try {
      final response = await dio.post(
        "/register/verify",
        data: {
          "email": email,
          "otp": otp,
        },
      );

      return ApiResponse(
        success: true,
        data: response.data,
      );
    } on DioException catch (e) {
      final data = e.response?.data;

      String message = "OTP verification failed";

      if (data is Map) {
        message = data["message"]?.toString()
            ?? data["error"]?.toString()
            ?? "OTP verification failed";
      } else if (data is String) {
        message = data;
      }

      return ApiResponse(
        success: false,
        error: message,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: "OTP verification failed",
      );
    }
  }

}
final authServiceProvider = Provider<AuthService> ((ref) {
  final dio = ref.read(dioProvider);
  return AuthService(dio);
});