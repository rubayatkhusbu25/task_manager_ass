import 'package:flutter/material.dart';

void showSnackbarMessage(BuildContext context, String message, [bool isError = false]) {

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message,style: TextStyle(color: Colors.white),),
      backgroundColor: isError ? Colors.red : null));
}
