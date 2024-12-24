import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    return Column(
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
                final userCredentials = 
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: email, 
                    password: password
                    );
                    print(userCredentials);

                // In case of wrong credentials
                } on FirebaseAuthException catch (e) {
                  print(e.code);
                  switch (e.code) {
                    case "invalid-email":
                      print("Invalid email format");
                    case "invalid-credential":
                      print("Invalid credentials");  
                    default:
                      print("Invalid password");  
                  }
                // Works like an else statement
                } catch (e) {
                  print("something bad happened");
                  print(e);
                  print(e.runtimeType);
                }
              }, 
              child: const Text('Login')),
            TextButton(
              onPressed: () {

              }, 
              child: const Text('Not registered yet? Register here !'))
          ],
        );
  }
}