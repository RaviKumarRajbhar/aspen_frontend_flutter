
import 'package:aspen_app/repository/auth_repository.dart';
import 'package:aspen_app/states/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState> ((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthViewModel(authRepository);
});

class AuthViewModel extends StateNotifier<AuthState>{

  final AuthRepository repo;

  AuthViewModel(this.repo):super(AuthState.initial()) {
    checkAuth();
  }

  Future<void> googleLogin() async {

    try {

      final response = await repo.oauthGoogleLogin();

      if ( response.success ) {

        state = state.copyWith(
              status: AuthStatus.authenticated,
              error:null,
            );
      }

      else {
        state = state.copyWith( status: AuthStatus.unauthenticated, error:response.error);
      }

    }

    catch (e) {
      state = state.copyWith(status: AuthStatus.unauthenticated,error: "Google login failed");
    }
  }

  Future<void> checkAuth() async {

    final token = await repo.getRefreshToken();

    if(token != null){
      state = state.copyWith(status: AuthStatus.authenticated);
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
   }

   Future<void> login(String email , String password) async {

    try {
      final response = await repo.login(email, password);

      if(response.success) {
        state = state.copyWith(status: AuthStatus.authenticated);
      } else {
        state = state.copyWith(status: AuthStatus.unauthenticated , error: response.error);
      }
    } catch (e) {
      state = state.copyWith(status : AuthStatus.unauthenticated , error: "Something went wrong");
    }

   }

   Future<void> logout() async {
    await repo.deleteRefreshToken();
    await repo.deleteAccessToken();
    state = state.copyWith(status: AuthStatus.unauthenticated);
   }

   Future<void> register(String username , String email , String password) async {
    // make registration here
   }
}