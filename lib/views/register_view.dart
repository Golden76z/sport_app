import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/services/auth/auth_exceptions.dart';
import 'package:sport_app/services/auth/auth_service.dart';
import 'package:sport_app/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // late means i'm going to attribute a value later on
  late final TextEditingController _username;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordConfirm;

  @override
  void initState() {
    _username = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordConfirm = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    _passwordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Column(
            children: [
              // Display an empty text field on the screen
              TextField(
                controller: _username,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter your pseudo"
                )
              ),
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
              TextField(
                controller: _passwordConfirm,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:  const InputDecoration(
                  hintText: 'Confirm your password'
                )
              ),
              // Display a text button, child being the content, onPressed is the function
              TextButton(
          
                // Function to create a new user
                onPressed: () async {
          
                  // final username = _username.text;
                  final email = _email.text;
                  final password = _password.text;
                  final passwordConfirm = _passwordConfirm.text;
      
                  if (password != passwordConfirm) {
                    await showErrorDialog(context, "Password doesn't match");
                  } else {
                    try {
                    // await because this function return a Future
                    await AuthService.firebase().createUser(
                      email: email, 
                      password: password
                    );
                    // final user = AuthService.firebase().currentUser;
                    AuthService.firebase().sendEmailVerification();

                    // Sending user to verify view after registration
                    Navigator.of(context).pushNamed(verifyEmailRoute);
                  } on EmailAlreadyUsedAuthException {
                    await showErrorDialog(
                      context, 
                      "Email already used"
                    );
                  } on EmailFormatAuthException {
                    await showErrorDialog(
                      context, 
                      "Invalid Email format"
                    );
                  } on WeakPasswordAuthException {
                    await showErrorDialog(
                      context, 
                      "Weak password"
                    );
                  } on GenericAuthException {
                    await showErrorDialog(
                      context, 
                      "Authentication error"
                    );
                  }
                }
              }, 
              child: const Text('Register')),

              // TextButton to go back to login view
              TextButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false, 
                );
              }, 
              child: const Text('Already have an account? Go to login !')),
            ],
          ),
    );
  }
}