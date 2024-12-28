import 'package:flutter/material.dart';

//? Function to show errors to the User (pop-up)
Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            }, 
            child: const Text('Ok')
          )
        ],
      );
    },
  );
}