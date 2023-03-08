// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:doantotnghiep/constant.dart';
import 'package:doantotnghiep/model/Location.dart';

//fuutu

class Userinfo {
  String? uid;
  String? profilePic;
  List<Groups>? groups;
  String? name;
  Location? location;
  String? email;
  String? sothich;
  String? registrationId;
  Userinfo({
    this.uid,
    this.profilePic,
    this.groups,
    this.name,
    this.location,
    this.email,
    this.sothich,
    this.registrationId
  });
  void saveUserInfo(String uid, String name,String registrationId) {
    this.uid = uid;
    this.name = name;
    this.registrationId= registrationId;
  }
 void saveUserNameId(String uid, String name) {
    this.uid = uid;
    this.name = name;
   
  }
  void saveUserUid(String uid) {
    this.uid = uid;
  }

  void saveUserName(String name) {
    this.name = name;
  }

 void saveRegistrationId(String registrationId) {
    this.registrationId = registrationId;
  }
  static Userinfo userSingleton = Userinfo();
  Userinfo.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    profilePic = json['profilePic'];
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
    name = json['fullName'];
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    email = json['email'];
    sothich= json['sothich'];
    registrationId = json['registration_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['profilePic'] = this.profilePic;
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    data['fullName'] = this.name;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['email'] = this.email;
     data['sothich']=this.sothich;
     data['registration_id']=this.registrationId;
    return data;
  }
}

class Groups {
  String? groupName;
  String? groupId;

  Groups({this.groupName, this.groupId});

  Groups.fromJson(Map<String, dynamic> json) {
    groupName = json['GroupName'];
    groupId = json['groupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupName'] = this.groupName;
    data['groupId'] = this.groupId;
    return data;
  }
}
