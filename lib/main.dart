import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/services/auth/auth_service.dart';
import 'package:sport_app/views/login_view.dart';
import 'package:sport_app/views/notes/create_update_note_view.dart';
import 'package:sport_app/views/notes/notes_view.dart';
import 'package:sport_app/views/register_view.dart';
import 'package:sport_app/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),

      // Setting up the routes of our functions
      routes: {
        homeRoute: (context) => HomePage(),
        loginRoute: (context) => LoginView(),
        registerRoute: (context) => RegisterView(),
        verifyEmailRoute: (context) => VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => CreateUpdateNoteView(),
      },
      )
    );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            default:
              //Showing an indicator to the screen
              return const CircularProgressIndicator();
          }
        },
      );
  }
}