import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/views/notes/notes_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.redAccent[200],
      ),
      body: const Center(child: Text("Hello there")),
      bottomNavigationBar: Container(
        height: 60,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Colors.redAccent[200]!,
        //       const Color.fromARGB(0, 255, 240, 174),
        //     ],
        //     begin: Alignment.bottomCenter,
        //     end: Alignment.topCenter,
        //   ),
        // ),
        child: BottomAppBar(
          color: Colors.redAccent[200], // Make the BottomAppBar background transparent
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    homeRoute,
                    (route) => false, 
                  )
                }, 
                icon: const Icon(Icons.home_filled),
                color: Colors.white,
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () => {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    homeRoute,
                    (route) => false, 
                  )
                }, 
                icon: const Icon(Icons.search_rounded),
                color: Colors.white,
              ),
              const SizedBox(width: 40),
              IconButton(
                onPressed: () => {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    profileRoute,
                    (route) => false, 
                  )
                }, 
                icon: const Icon(Icons.account_circle_sharp),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
