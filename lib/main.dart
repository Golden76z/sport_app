import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sport_app/firebase_options.dart';
import 'package:sport_app/views/login_view.dart';
import 'package:sport_app/views/register_view.dart';

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
        "/login/": (context) => LoginView(),
        "/register/": (context) => RegisterView()
      },
      )
    );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage")
      ,), 
      // Column means that everything will display in one column
      body: FutureBuilder(
        future: Firebase.initializeApp(
                  options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              // Checking the user informations, to see if he's logged or email verified
              // final user = FirebaseAuth.instance.currentUser;
              // print(user);
              // if (user?.emailVerified == null) {
              //   print("User not registered");
              // } else {
              //   final emailVerified = user?.emailVerified ?? false;
              //   if (emailVerified) {
              //     print("You email is verified");
              //     return const Text('Done');
              //   } else {
              //     print("You email isn't verified");
              //     return const VerifyEmailView();
              //   }
              // }
              // return const Text('test');
              return const LoginView();
          default:
            return const Text('Loading...');
          }
        },
      )
    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text('Verified Page')
      ,),
      body: Column(children: [
        Text('You need to verify your email first'),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          }, 
          child: const Text('Send email verification')
        )
      ],)
      );
  }
}