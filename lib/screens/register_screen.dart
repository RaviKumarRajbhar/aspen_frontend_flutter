import 'package:aspen_app/states/auth_state.dart';
import 'package:aspen_app/viewmodel/auth_view_model.dart';
import 'package:aspen_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'otp_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Username",
                      labelStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color:
                          Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          width: 1.2,
                        ),
                      ),
                      focusedErrorBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Username";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color:
                          Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          width: 1.2,
                        ),
                      ),
                      focusedErrorBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          !value.contains("@")) {
                        return "Not a Valid Email";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Colors.grey.shade600,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color:
                          Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          width: 1.2,
                        ),
                      ),
                      focusedErrorBorder:
                      OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .colorScheme
                              .error,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password cannot be Empty";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  authState.status == AuthStatus.loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed:
                    authState.status ==
                        AuthStatus.loading
                        ? null
                        : () async {
                      if (!_formKey
                          .currentState!
                          .validate()) {
                        return;
                      }

                      await ref
                          .read(
                        authViewModelProvider
                            .notifier,
                      )
                          .register(
                        nameController
                            .text
                            .trim(),
                        emailController
                            .text
                            .trim(),
                        passwordController
                            .text,
                      );

                      final state = ref.read(
                        authViewModelProvider,
                      );

                      if (state.error == null &&
                          context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                OtpScreen(
                                  email:
                                  emailController
                                      .text
                                      .trim(),
                                ),
                          ),
                        );
                      }
                    },
                    child: const Text("Register"),
                  ),
                  const SizedBox(height: 20),
                  if (authState.error != null)
                    Text(
                      authState.error!,
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .error,
                      ),
                    ),
                  Text(
                    "Already a user ? Click here to Sign in",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(
                      color:
                      Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}