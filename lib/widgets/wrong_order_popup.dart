import 'package:flutter/material.dart';

enum DialogOptions { showAnyway, showProperPoint }

class WrongOrderPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Trasa uporządkowana"),
      content: const Text(
          "Wybrane miejsce należy do trasy, która opowiada historię, więc zalecamy zwiedzanie jej w ustalonej kolejności, a nie zameldowałeś się jeszcze na poprzednich punktach."),
      actions: <Widget>[
        TextButton(
          child: const Text("Zobacz mimo to"),
          onPressed: () => Navigator.of(context).pop(DialogOptions.showAnyway),
        ),
        TextButton(
          child: const Text("OK, Pokaż właściwy punkt"),
          onPressed: () =>
              Navigator.of(context).pop(DialogOptions.showProperPoint),
        )
      ],
    );
  }
}
