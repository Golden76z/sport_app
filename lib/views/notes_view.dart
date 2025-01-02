import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/enums/menu_action.dart';
import 'package:sport_app/services/auth/auth_service.dart';
import 'package:sport_app/services/crud/notes_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final NotesService _notesService;
  String get userEmail => AuthService.firebase().currentUser!.email!;

  // Code to execute upon initialisation of the widget
  @override
  void initState() {
    _notesService = NotesService();
    super.initState();
  }

  // Closing db before leaving the widget
  @override
  void dispose() {
    _notesService.close();
    super.dispose();
  }

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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesService.allNotes, 
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Waiting for all notes');
                    default:
                      return const CircularProgressIndicator();  
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      )
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