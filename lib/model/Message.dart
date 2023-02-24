import 'dart:convert';

import 'package:flutter/material.dart';

enum Type { text, announce,  callvideo,callaudio}

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  String sender;
  String contentMessage;
  String time;
  Type type;
  String displaytime = '';
  int timesent = 0;
  bool ontap = false;
  String timelocal = '';
  Message(
      {required this.sender,
      required this.contentMessage,
      required this.time,
      required this.type});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'contentMessage': contentMessage,
      'time': time,
      'type': type.name
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
        sender: map['sender'] as String,
        contentMessage: map['contentMessage'] as String,
        time: map['time'] as String,
        type: Type.values.elementAt(findenum(map['type'])));
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);
}

findenum(String any) {
  for (var v in Type.values) {
    if (v.name == any) {
      return v.index;
    }
  }
}
