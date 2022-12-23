import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Message {
  String sender;
  String contentMessage;
  String time;
  String displaytime='';
  bool ontap=false;
  Message({
    required this.sender,
    required this.contentMessage,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'contentMessage': contentMessage,
      'time': time,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'] as String,
      contentMessage: map['contentMessage'] as String,
      time: map['time'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);
}
