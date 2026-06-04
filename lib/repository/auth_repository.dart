import 'package:aspen_app/service/auth_service.dart';
import 'package:aspen_app/model/api_response.dart';
import 'package:aspen_app/service/device_service.dart';
import 'package:aspen_app/service/google_auth_service.dart';
import 'package:aspen_app/token_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthRepository {

  final TokenStorage _tokenStorage;
  final AuthService authService;
  final DeviceService deviceService;
  final GoogleAuthService googleAuthService;

  AuthRepository(this._tokenStorage , this.authService, this.googleAuthService, this.deviceService);

  Future<String?> getRefreshToken() async {
    return await _tokenStorage.getRefreshToken();
  }


  Future<void> saveRefreshToken(String token) async {
    return await _tokenStorage.saveRefreshToken(token);
  }

  Future<void> deleteRefreshToken() async {
    await _tokenStorage.deleteRefreshToken();
  }

  Future<void> deleteAccessToken() async {
    _tokenStorage.deleteAccessToken();
  }

  Future<void> logout() async {
    await deleteAccessToken();
    await deleteRefreshToken();
  }

  Future<ApiResponse<void>> login(String email , String password) async {

    final response = await authService.login(email, password);

    if(!response.success) {

      return ApiResponse(success: false , error: response.error);

    }

    try {

      final accessToken = response.data?["accessToken"];
      final refreshToken = response.data?["refreshToken"];

      if(accessToken == null || refreshToken == null) {
        return ApiResponse(success: false , error: "Invalid Server Response");
      }

      await _tokenStorage.saveAccessToken(accessToken);
      await _tokenStorage.saveRefreshToken(refreshToken);

      await deviceService.registerDeviceToken();

      return ApiResponse(success: true);
    } catch (e) {
      return ApiResponse(success: false , error: "Something went wrong");
    }

  }

  Future<ApiResponse<void>>
  oauthGoogleLogin()
  async {

    try {

      // Step 1
      final idToken =
      await googleAuthService
          .signIn();

      // Step 2
      final response =
      await authService
          .googleLogin(
          idToken);

      if (!response.success) {

        return ApiResponse(
          success: false,
          error: response.error,
        );
      }

      // Step 3
      final accessToken =
      response.data?[
      "accessToken"];

      final refreshToken =
      response.data?[
      "refreshToken"];

      if (
      accessToken == null ||
          refreshToken == null
      ) {

        return ApiResponse(
          success: false,
          error:
          "Invalid server response",
        );
      }

      // Step 4
      await _tokenStorage
          .saveAccessToken(
          accessToken);

      await _tokenStorage
          .saveRefreshToken(
          refreshToken);

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

  Future<void> register ( String username , String email , String password ) async {

    final response = await authService.register(username, email, password);

    if(response.success) {


    }

  }




}
final authRepositoryProvider =
Provider<AuthRepository>(
        (
        ref,
        ) {

      final tokenStorage =
      ref.read(
          tokenStorageProvider);

      final authService =
      ref.read(
          authServiceProvider);

      final googleAuthService =
      ref.read(
          googleAuthServiceProvider);

      final deviceService = ref.read(deviceServiceProvider);

      return AuthRepository(

        tokenStorage,

        authService,

        googleAuthService,

        deviceService
      );
    });

final googleAuthServiceProvider =
Provider<GoogleAuthService>(
      (ref) {
    return GoogleAuthService();
  },
);