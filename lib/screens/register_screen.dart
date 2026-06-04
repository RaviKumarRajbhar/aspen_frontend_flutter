import 'package:aspen_app/states/auth_state.dart';
import 'package:aspen_app/viewmodel/auth_view_model.dart';
import 'package:aspen_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen  extends ConsumerStatefulWidget{

  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();

}

class _RegisterScreenState extends ConsumerState<RegisterScreen>{

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.all(16),
          child: Form(
              key : _formKey,
              child: Column(
                children: [

                  TextFormField(
                    controller: nameController,
                      decoration: const InputDecoration(labelText: "Username"),
                      validator: (value) {
                      if(value == null || value.isEmpty){
                        return "Enter Username";
                      }
                      return null;
                      }
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
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
                    obscureText: true,
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
                              .register(nameController.text,
                              emailController.text,
                              passwordController.text);
                        }
                      }, child: const Text("Register")),

                  const SizedBox(height: 20),

                  if(authState.error != null)
                    Text(
                      authState.error!,
                      style: TextStyle(color : Theme.of(context).colorScheme.error,
                    )),

                  Text("Already a user ? Click here to Sign in",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).primaryColor),),

                  const SizedBox(height: 20,),

                  ElevatedButton(onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                  }, child: const Text("Sign in"),)
                ],
              )
          ),
          ),
        ),
      ),
    );


  }
}