import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/enums/menu_action.dart';
import 'package:sport_app/services/auth/auth_service.dart';

class NotesView extends StatelessWidget {
  const NotesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogOut = await showLogOutDialog(context);
                if (shouldLogOut) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (route) => false, 
                    );
                }
            };
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text('Log out')
              ),
            ];
          },)
        ]
      ),
      body: const Text('Hello world')
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context, 
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out'),
        content: const Text('Logging out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            }, 
            child: const Text('Yes')
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            }, 
            child: const Text('Cancel')
          )          
        ],
      );
    }
  ).then((value) => value ?? false);
}