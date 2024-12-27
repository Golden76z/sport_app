import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:sport_app/constants/routes.dart';

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
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, 
                      password: password
                      );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      homeRoute,
                      (route) => false, 
                    );
      
                  // In case of wrong credentials
                  } on FirebaseAuthException catch (e) {
                    devtools.log(e.code);
                    switch (e.code) {
                      case "invalid-email":
                        devtools.log("Invalid email format");
                      case "invalid-credential":
                        devtools.log("Invalid credentials");
                      default:
                        devtools.log("Invalid password"); 
                    }
                  // Works like an else statement
                  } catch (e) {
                    devtools.log("something bad happened");
                    devtools.log(e.toString());
                    devtools.log(e.runtimeType.toString());
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