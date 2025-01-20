import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/services/auth/auth_exceptions.dart';
import 'package:sport_app/services/auth/auth_service.dart';
import 'package:sport_app/services/auth/bloc/auth_bloc.dart';
import 'package:sport_app/services/auth/bloc/auth_event.dart';
import 'package:sport_app/services/auth/bloc/auth_state.dart';
import 'package:sport_app/utilities/dialogs/error_dialog.dart';

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
      appBar: AppBar(
        title: const Text('Login',
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
              controller: _email,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: "Enter your email")),
          TextField(
              controller: _password,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              decoration:
                  const InputDecoration(hintText: 'Enter your password')),
          // Display a text button, child being the content, onPressed is the function
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) async {
              if (state is AuthStateLoggedOut) {
                if (state.exception is WrongCredentialsAuthException) {
                  await showErrorDialog(context, 'Wrong credentials');
                } else if (state.exception is GenericAuthException) {
                  await showErrorDialog(context, 'Authentication error');
                }
              }
            },
            child: TextButton(
              // Function to create a new user
              onPressed: () async {
                final email = _email.text;
                final password = _password.text;

                context.read<AuthBloc>().add(
                  AuthEventLogIn(
                    email, 
                    password
                  ),
                );
              },
              child: const Text('Login'),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerRoute, (route) => false);
              },
              child: const Text('Not registered yet? Register here !'))
        ],
      ),
    );
  }
}
