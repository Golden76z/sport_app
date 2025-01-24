import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_app/services/auth/auth_exceptions.dart';
import 'package:sport_app/services/auth/bloc/auth_bloc.dart';
import 'package:sport_app/services/auth/bloc/auth_event.dart';
import 'package:sport_app/services/auth/bloc/auth_state.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak password');
          } else if (state.exception is EmailAlreadyUsedAuthException) {
            await showErrorDialog(context, 'Email already taken');
          } else if (state.exception is EmailFormatAuthException) {
            await showErrorDialog(context, 'Invalid email format');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: Colors.redAccent[200],
          foregroundColor: Colors.white,
        ),
        body: Column(
          children: [
            // Display an empty text field on the screen
            TextField(
                controller: _username,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: "Enter your pseudo")),
            TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: "Enter your email")),
            TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Enter your password')),
            TextField(
                controller: _passwordConfirm,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration:
                    const InputDecoration(hintText: 'Confirm your password')),
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
                  } 
                  context.read<AuthBloc>().add(
                    AuthEventRegister(
                      email, 
                      password
                    )
                  );
                },
                child: const Text('Register')),

            // TextButton to go back to login view
            TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(
                    const AuthEventLogOut()
                  );
                },
                child: const Text('Already have an account? Go to login !')),
          ],
        ),
      ),
    );
  }
}
