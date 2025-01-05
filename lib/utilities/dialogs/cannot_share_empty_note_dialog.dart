import 'package:flutter/material.dart';
import 'package:sport_app/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context, 
    title: 'Sharing', 
    content: 'You cannot share an empty note', 
    optionsBuilder: () => {
      'OK': null,
    }
  );
}