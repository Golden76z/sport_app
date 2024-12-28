import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/services/auth/auth_exceptions.dart';
import 'package:sport_app/services/auth/auth_service.dart';
import 'package:sport_app/utilities/show_error_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // late means i'm going to attribute a value later on
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(
            children: [
              // Display an empty text field on the screen
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter your email"
                )
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:  const InputDecoration(
                  hintText: 'Enter your password'
                )
              ),
              // Display a text button, child being the content, onPressed is the function
              TextButton(
          
                // Function to create a new user
                onPressed: () async {
          
                  final email = _email.text;
                  final password = _password.text;
          
                  // Code running if there's no errors
                  try {
                    // await because this function return a Future
                    await AuthService.firebase().logIn(
                      email: email, 
                      password: password
                    );

                    // Check if the user has verified his email before sending him to Main UI
                    final user = AuthService.firebase().currentUser;
                    final emailVerified = user?.isEmailVerified ?? false;
                    if (emailVerified) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        homeRoute,
                        (route) => false, 
                      );
                    } else {
                       Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyEmailRoute,
                        (route) => false, 
                      );                     
                    }

                  // In case of wrong credentials
                  } on WrongCredentialsAuthException {
                    await showErrorDialog(
                      context, 
                      "Invalid email format"
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context, 
                      "Authentication error"
                    );
                  }
                }, 
                child: const Text('Login')),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    registerRoute, 
                    (route) => false
                  );
                }, 
                child: const Text('Not registered yet? Register here !'))
            ],
          ),
    );
  }
}