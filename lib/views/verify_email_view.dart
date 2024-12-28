import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      title: const Text('Email verification')
      ,),
      body: Column(children: [
        Text("Hi [User's Name], \n\nWe’ve sent a verification email to your inbox. Please check your email to complete the process.\n\nIf you didn’t receive the email, click on the link below\n\nThanks,\n\nThe [Your Application Name] Team"),
        TextButton(
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            await user?.sendEmailVerification();
          }, 
          child: const Text('Send email')
        ),

        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil(
              registerRoute, 
              (route) => false,
              );
          }, 
          child: const Text('Restart')
        )
      ],)
      );
  }
}