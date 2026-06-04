import 'package:aspen_app/states/auth_state.dart';
import 'package:aspen_app/viewmodel/auth_view_model.dart';
import 'package:aspen_app/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen  extends ConsumerStatefulWidget{

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends ConsumerState<LoginScreen>{

  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authViewModelProvider);
    
    ref.listen<AuthState>(authViewModelProvider, (prev ,next){

      if(next.status == AuthStatus.unauthenticated && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!),
          backgroundColor: Theme.of(context).colorScheme.error)
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16),
            child: Form(
                key : _formKey,
                child: Column(
                  children: [


                    const SizedBox(height: 20),

                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),),
                      validator: (value) {
                        if(value == null || !value.contains("@")){
                          return "Not a Valid Email";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: "Password"),
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return "Password cannot be Empty";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    authState.status == AuthStatus.loading ? const CircularProgressIndicator() :
                    ElevatedButton(onPressed: () {
                      if(_formKey.currentState!.validate()) {
                        ref.
                        read(authViewModelProvider.notifier)
                            .login(
                            emailController.text,
                            passwordController.text);
                      }
                    }, child: const Text("Login")),

                    const SizedBox(height: 20),

                    if(authState.error != null)
                      Text(
                        authState.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),

                    Text("Not a User ? Click here to Register",
                    style: Theme.of(context).textTheme.bodyMedium,),

                    const SizedBox(height: 20),

                    ElevatedButton(onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                    }, child: const Text("Register as a user")),

                    const SizedBox(
                        height: 20),

                    ElevatedButton(

                      onPressed: () {

                        ref

                            .read(
                            authViewModelProvider
                                .notifier)

                            .googleLogin();
                      },

                      child: const Text(

                        "Continue with Google",
                      ),
                    ),


                  ],
                )
            ),
          ),
        ),
      ),
    );


  }
}