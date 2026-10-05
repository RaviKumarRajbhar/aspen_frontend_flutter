import 'package:aspen_app/repository/auth_repository.dart';
import 'package:aspen_app/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider =
StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);

  return AuthViewModel(authRepository);
});

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthRepository repo;

  AuthViewModel(this.repo) : super(AuthState.initial()) {
    checkAuth();
  }

  Future<void> googleLogin() async {
    try {
      final response = await repo.oauthGoogleLogin();

      if (response.success) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: response.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: "Google login failed",
      );
    }
  }

  Future<void> checkAuth() async {
    final refreshToken = await repo.getRefreshToken();

    if (refreshToken != null) {
      state = state.copyWith(
        status: AuthStatus.authenticated,
      );
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
      );
    }
  }

  Future<void> login(
      String email,
      String password,
      ) async {
    try {
      final response = await repo.login(
        email,
        password,
      );

      if (response.success) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: response.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: "Something went wrong",
      );
    }
  }

  Future<void> logout() async {
    await repo.logout();

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      error: null,
    );
  }

  Future<void> register(
      String username,
      String email,
      String password,
      ) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      error: null,
    );

    try {
      final response = await repo.register(
        username,
        email,
        password,
      );

      if (response.success) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: null,
        );
      } else {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          error: response.error,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: "Registration failed",
      );
    }
  }

  Future<bool> verifyOtp(
      String email,
      String otp,
      ) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      error: null,
    );

    try {
      final response = await repo.verifyOtp(
        email,
        otp,
      );

      if (response.success) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          error: null,
        );

        return true;
      }

      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: response.error,
      );

      return false;
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        error: "OTP verification failed",
      );

      return false;
    }
  }
}