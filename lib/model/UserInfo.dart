// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:doantotnghiep/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Userinfo {
  String? uid;
  String? name;
  String? email;
  List<Groups>? groups;
  String? profilePic;
  Userinfo({
    this.uid,
    this.name,
    this.email,
    this.groups,
    this.profilePic,
  });
  static  Userinfo userSingleton = Userinfo();
  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory Userinfo.fromMap(Map<String, dynamic> map) {
    return Userinfo(
      uid: map['uid'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
  void saveUserInfo(String uid,String name){
    this.uid=uid;
    this.name=name;
  }
  
  void saveUserUid(String uid){
    this.uid=uid;
  }
   void saveUserName(String name){
    this.name=name;
  }
  String toJson() => json.encode(toMap());

  factory Userinfo.fromJson(String source) => Userinfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
class Groups {
  String? groupId;
  String? groupName;

  Groups({this.groupId, this.groupName});

  Groups.fromJson(Map<String, dynamic> json) {
    groupId = json['groupId'];
    groupName = json['GroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.groupId;
    data['GroupName'] = this.groupName;
    return data;
  }
}
class CustomClipPath extends CustomClipper<Path> {
  var radius=5.0;
  
  @override
  Path getClip(Size size) {
    Path path = Path();
    
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    // TODO: implement getClip
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    throw false;
  }
 
}