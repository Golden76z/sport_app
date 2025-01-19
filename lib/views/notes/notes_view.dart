import 'package:flutter/material.dart';
import 'package:sport_app/constants/routes.dart';
import 'package:sport_app/enums/menu_action.dart';
import 'package:sport_app/services/auth/auth_service.dart';
import 'package:sport_app/services/cloud/cloud_note.dart';
import 'package:sport_app/services/cloud/firebase_cloud_storage.dart';
import 'package:sport_app/utilities/dialogs/logout_dialog.dart';
import 'package:sport_app/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  // Code to execute upon initialisation of the widget
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.account_box_rounded),
        title: const Text(
          'Your Notes',
          style: TextStyle(fontWeight: FontWeight.bold,)
          ,),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            }, 
            icon: const Icon(Icons.add_box_outlined)
          ),
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
        ],
        backgroundColor: Colors.redAccent[200],
        foregroundColor: Colors.white,
      )
      ,
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId), 
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes, 
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();  
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 60,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [
        //       Colors.redAccent[200]!,
        //       const Color.fromARGB(153, 255, 82, 82)!,
        //       const Color.fromARGB(78, 255, 82, 82)!,
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