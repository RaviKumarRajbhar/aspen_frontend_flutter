enum AuthStatus {
  loading,
  unauthenticated,
  authenticated,
}

class AuthState {

  final AuthStatus status;
  final String? error;

  AuthState({
    required this.status,
    this.error
});

  factory AuthState.initial(){
    return AuthState(status: AuthStatus.loading);
  }

  AuthState copyWith({
    AuthStatus? status,
    String? error
}){
    return AuthState(status: status ?? this.status , error: error);
  }


}