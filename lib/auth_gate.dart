import 'package:aspen_app/states/auth_state.dart';
import 'package:aspen_app/viewmodel/auth_view_model.dart';
import 'package:aspen_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/home_screen.dart';

class AuthGate extends ConsumerWidget {

  const AuthGate({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    switch(authState.status) {
      case AuthStatus.loading:
        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );

      case AuthStatus.unauthenticated:
        return LoginScreen();
      case AuthStatus.authenticated:
        return HomeScreen();
    }


  }

}