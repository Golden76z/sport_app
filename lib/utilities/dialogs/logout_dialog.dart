import 'package:flutter/material.dart';
import 'package:sport_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Log out', 
    content: 'Are you sure you want to log out?', 
    optionsBuilder: () => {
      'Yes': true,
      'No': false,
    }
  ).then(
    (value) => value ?? false,
  );
}