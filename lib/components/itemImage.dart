import 'package:flutter/material.dart';

Widget itemImage(String name,context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).primaryColor),
      child: Center(
          child: Text(
        '${name.substring(0, 1)}',
        style: TextStyle(color: Colors.white),
      )),
    );
  }
