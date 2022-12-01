import 'package:flutter/material.dart';

void navigatePush(context,Widget object){
  Navigator.push(context, MaterialPageRoute(builder: (context)=>object));
}
void navigateReplacement(context,Widget object){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>object));
}
