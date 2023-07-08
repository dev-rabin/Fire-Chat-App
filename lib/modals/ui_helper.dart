// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UIHelper {
  static void showLoadingDialog(BuildContext context, String title) {
    AlertDialog loadingDialog = AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 10,
          ),
          Text(title),
        ],
      ),
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return loadingDialog;
        });
  }

  static void showAlertDialog(
      BuildContext context, String content, String title) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        title,
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      content: Text(content, style: TextStyle(color: Colors.grey)),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "OK",
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ))
      ],
    );
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (content) {
          return alertDialog;
        });
  }
}
