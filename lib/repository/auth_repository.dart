import 'package:aspen_app/service/auth_service.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:aspen_app/service/device_service.dart';
import 'package:aspen_app/service/google_auth_service.dart';
import 'package:aspen_app/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthRepository {
  final TokenStorage _tokenStorage;
  final AuthService authService;
  final DeviceService deviceService;
  final GoogleAuthService googleAuthService;

  AuthRepository(this._tokenStorage,this.authService,this.googleAuthService,this.deviceService);

  Future<String?> getRefreshToken() async {
    return await _tokenStorage.getRefreshToken();
  }

  Future<String?> getAccessToken() async {
    return await _tokenStorage.getAccessToken();
  }

  Future<void> saveRefreshToken(String token) async {
    await _tokenStorage.saveRefreshToken(token);
  }

  Future<void> deleteRefreshToken() async {
    await _tokenStorage.deleteRefreshToken();
  }

  Future<void> deleteAccessToken() async {
    await _tokenStorage.deleteAccessToken();
  }

  Future<String?> getUserId() async {
    return await _tokenStorage.getUserId();
  }

  Future<void> deleteUserId() async {
    await _tokenStorage.deleteUserId();
  }

  Future<void> logout() async {
    await deleteAccessToken();
    await deleteRefreshToken();
    await deleteUserId();
  }

  Future<ApiResponse<void>> login(
      String email,
      String password,
      ) async {
    final response = await authService.login(
      email,
      password,
    );

    if (!response.success) {
      return ApiResponse(
        success: false,
        error: response.error,
      );
    }

    try {
      final accessToken =
      response.data?["accessToken"];

      final refreshToken =
      response.data?["refreshToken"];

      if (accessToken == null ||
          refreshToken == null) {
        return ApiResponse(
          success: false,
          error: "Invalid Server Response",
        );
      }

      await _tokenStorage.saveAccessToken(
        accessToken,
      );

      await _tokenStorage.saveRefreshToken(
        refreshToken,
      );

      final decodedToken = JwtDecoder.decode(accessToken);

      final userId = decodedToken["sub"]?.toString();

      if (userId == null || userId.isEmpty) {
        return ApiResponse(
          success: false,
          error: "Invalid User Token",
        );
      }

      await _tokenStorage.saveUserId(
        userId,
      );

      await deviceService.registerDeviceToken();

      return ApiResponse(
        success: true,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: "Something went wrong",
      );
    }
  }



  Future<ApiResponse<void>> oauthGoogleLogin() async {
    try {
      final idToken =
      await googleAuthService.signIn();

      final response =
      await authService.googleLogin(idToken);

      if (!response.success) {
        return ApiResponse(
          success: false,
          error: response.error,
        );
      }

      final accessToken =
      response.data?["accessToken"];

      final refreshToken =
      response.data?["refreshToken"];

      if (accessToken == null ||
          refreshToken == null) {
        return ApiResponse(
          success: false,
          error: "Invalid Server Response",
        );
      }

      await _tokenStorage.saveAccessToken(
        accessToken,
      );

      await _tokenStorage.saveRefreshToken(
        refreshToken,
      );

      final decodedToken = JwtDecoder.decode(accessToken);

      final userId = decodedToken["sub"]?.toString();

      if (userId == null || userId.isEmpty) {
        return ApiResponse(
          success: false,
          error: "Invalid User Token",
        );
      }

      await _tokenStorage.saveUserId(userId);

      await deviceService.registerDeviceToken();

      return ApiResponse(
        success: true,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        error: e.toString(),
      );
    }
  }

  Future<ApiResponse<void>> register(
      String username,
      String email,
      String password,
      ) async {
    try {
      final response =
      await authService.register(
        username,
        email,
        password,
      );

      if (!response.success) {
        return ApiResponse(
          success: false,
          error: response.error,
        );
      }

      return ApiResponse(success: true);
    } catch (e) {
      return ApiResponse(success: false, error: "Something went wrong");
    }
  }
}


final authRepositoryProvider  = Provider<AuthRepository>((ref) {

  final tokenStorage = ref.read(tokenStorageProvider);

  final authService = ref.read(authServiceProvider);

  final googleAuthService = ref.read(googleAuthServiceProvider);

  final deviceService = ref.read(deviceServiceProvider);

  return AuthRepository(
    tokenStorage,
    authService,
    googleAuthService,
    deviceService,
  );
});

final googleAuthServiceProvider = Provider<GoogleAuthService>((ref) {
  return GoogleAuthService();
});