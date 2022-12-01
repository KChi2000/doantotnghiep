import 'package:flutter/material.dart';

void showSnackbar(context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: color,
  ));
}
