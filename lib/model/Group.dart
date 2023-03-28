// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:doantotnghiep/model/Message.dart';

class GroupInfo {
  String? recentMessageSender;
  String? inviteId;
  List<Read>? isReadAr;
  List<Members>? members;
  Admin? admin;
  String? groupId;
  OfferAnswer? offer;
  OfferAnswer? answer;
  String? groupPic;
  String? recentMessage;
  String? groupName;
  String? time;
  bool? checked = false;
  bool? checkIsRead = false;
  Type? type;
  String? callStatus;
  String? status;
  GroupInfo(
      {this.recentMessageSender,
      this.inviteId,
      this.isReadAr,
      this.members,
      this.admin,
      this.groupId,
      this.groupPic,
      this.recentMessage,
      this.groupName,
      this.offer,
      this.answer,
      this.time,
      this.checked,
      this.checkIsRead,
      this.type,
      this.callStatus,
      this.status});

  GroupInfo.fromJson(Map<String, dynamic> json) {
    recentMessageSender = json['recentMessageSender'];
    inviteId = json['inviteId'];
    if (json['isReadAr'] != null) {
      isReadAr = <Read>[];
      json['isReadAr'].forEach((v) {
        isReadAr!.add(new Read.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    admin = json['admin'] != null ? new Admin.fromJson(json['admin']) : null;
     offer = json['offer'] != null ? new OfferAnswer.fromJson(json['offer']) : null;
      answer = json['answer'] != null ? new OfferAnswer.fromJson(json['answer']) : null;
    groupId = json['groupId'];
    groupPic = json['groupPic'];
    recentMessage = json['recentMessage'];
    groupName = json['GroupName'];
    time = json['time'];
    type = Type.values.elementAt(findenum(json['type']));
    callStatus = json['callStatus'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recentMessageSender'] = this.recentMessageSender;
    data['inviteId'] = this.inviteId;
    if (this.isReadAr != null) {
      data['isReadAr'] = this.isReadAr!.map((v) => v.toJson()).toList();
    }
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    if (this.admin != null) {
      data['admin'] = this.admin!.toJson();
    }
    if (this.offer != null) {
      data['offer'] = this.offer!.toJson();
    }
      if (this.answer != null) {
      data['answer'] = this.answer!.toJson();
    }
    data['groupId'] = this.groupId;
    data['groupPic'] = this.groupPic;
    data['recentMessage'] = this.recentMessage;
    data['GroupName'] = this.groupName;
    data['time'] = this.time;
    data['type'] = this.type!.name;
    data['callStatus'] = this.callStatus;
    data['status'] = this.status;
    return data;
  }

  @override
  bool operator ==(covariant GroupInfo other) {
    if (identical(this, other)) return true;
  
    return 
      other.recentMessageSender == recentMessageSender &&
      other.inviteId == inviteId &&
      listEquals(other.isReadAr, isReadAr) &&
      listEquals(other.members, members) &&
      other.admin == admin &&
      other.groupId == groupId &&
      other.groupPic == groupPic &&
      other.recentMessage == recentMessage &&
      other.groupName == groupName &&
      other.time == time &&
      other.checked == checked &&
      other.checkIsRead == checkIsRead &&
      other.type == type &&
      other.callStatus == callStatus &&
      other.status == status;
  }

  @override
  int get hashCode {
    return recentMessageSender.hashCode ^
      inviteId.hashCode ^
      isReadAr.hashCode ^
      members.hashCode ^
      admin.hashCode ^
      groupId.hashCode ^
      groupPic.hashCode ^
      recentMessage.hashCode ^
      groupName.hashCode ^
      time.hashCode ^
      checked.hashCode ^
      checkIsRead.hashCode ^
      type.hashCode ^
      callStatus.hashCode ^
      status.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'recentMessageSender': recentMessageSender,
      'inviteId': inviteId,
      'isReadAr': isReadAr!.map((x) => x.toMap()).toList(),
      'members': members!.map((x) => x.toMap()).toList(),
      'admin': admin?.toMap(),
      'groupId': groupId,
      'offer': offer?.toMap(),
      'answer': answer?.toMap(),
      'groupPic': groupPic,
      'recentMessage': recentMessage,
      'groupName': groupName,
      'time': time,
      'checked': checked,
      'checkIsRead': checkIsRead,
      'type': this.type!.name,
      'callStatus': callStatus,
      'status': status,
    };
  }

  factory GroupInfo.fromMap(Map<String, dynamic> map) {
    return GroupInfo(
     recentMessageSender:  map['recentMessageSender'] != null ? map['recentMessageSender'] as String : null,
    inviteId:   map['inviteId'] != null ? map['inviteId'] as String : null,
    isReadAr:   map['isReadAr'] != null ? List<Read>.from((map['isReadAr'] as List<int>).map<Read?>((x) => Read.fromMap(x as Map<String,dynamic>),),) : null,
    members:   map['members'] != null ? List<Members>.from((map['members'] as List<int>).map<Members?>((x) => Members.fromMap(x as Map<String,dynamic>),),) : null,
    admin:   map['admin'] != null ? Admin.fromMap(map['admin'] as Map<String,dynamic>) : null,
    groupId:   map['groupId'] != null ? map['groupId'] as String : null,
    offer:   map['offer'] != null ? OfferAnswer.fromMap(map['offer'] as Map<String,dynamic>) : null,
    answer:   map['answer'] != null ? OfferAnswer.fromMap(map['answer'] as Map<String,dynamic>) : null,
    groupPic:   map['groupPic'] != null ? map['groupPic'] as String : null,
    recentMessage:   map['recentMessage'] != null ? map['recentMessage'] as String : null,
    groupName:   map['groupName'] != null ? map['groupName'] as String : null,
    time:   map['time'] != null ? map['time'] as String : null,
    checked:   map['checked'] != null ? map['checked'] as bool : null,
    checkIsRead:   map['checkIsRead'] != null ? map['checkIsRead'] as bool : null,
    type:   map['type'] != null ? Type.values.elementAt(findenum(map['type'])):null,
    callStatus:   map['callStatus'] != null ? map['callStatus'] as String : null,
     status:  map['status'] != null ? map['status'] as String : null,
    );
  }

 
}

class Members {
  String? Id;
  String? Name;

  Members({this.Id, this.Name});

  Members.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    Name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.Id;
    data['Name'] = this.Name;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': Id,
      'Name': Name,
    };
  }

  factory Members.fromMap(Map<String, dynamic> map) {
    return Members(
      Id: map['Id'] != null ? map['Id'] as String : null,
      Name: map['Name'] != null ? map['Name'] as String : null,
    );
  }


}

class Admin {
  String? adminId;
  String? adminName;

  Admin({this.adminId, this.adminName});

  Admin.fromJson(Map<String, dynamic> json) {
    adminId = json['adminId'];
    adminName = json['adminName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adminId'] = this.adminId;
    data['adminName'] = this.adminName;
    return data;
  }

  @override
  bool operator ==(covariant Admin other) {
    if (identical(this, other)) return true;
  
    return 
      other.adminId == adminId &&
      other.adminName == adminName;
  }

  @override
  int get hashCode => adminId.hashCode ^ adminName.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'adminId': adminId,
      'adminName': adminName,
    };
  }

  factory Admin.fromMap(Map<String, dynamic> map) {
    return Admin(
      adminId: map['adminId'] != null ? map['adminId'] as String : null,
      adminName: map['adminName'] != null ? map['adminName'] as String : null,
    );
  }

  
}
class OfferAnswer {
  String? id;
  String? sdp;
  String? type;
  String? name;
  String? profile;
  bool? cameraStatus;
  OfferAnswer({this.sdp, this.type,this.id,this.name,this.profile, bool? cameraStatus});

  OfferAnswer.fromJson(Map<String, dynamic> json) {
    sdp = json['sdp'];
    type = json['type'];
    id= json['id'];
    name= json['name'];
    profile = json['pic'];
    cameraStatus = json['cameraStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sdp'] = this.sdp;
    data['type'] = this.type;
    data['id'] = this.id;
    data['name'] = this.name;
    data['pic'] = this.profile;
     data['cameraStatus'] = this.cameraStatus;
    return data;
  }

  @override
  bool operator ==(covariant OfferAnswer other) {
    if (identical(this, other)) return true;
  
    return 
      other.sdp == sdp &&
      other.type == type;
  }

  @override
  int get hashCode => sdp.hashCode ^ type.hashCode;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'sdp': sdp,
      'type': type,
      'name': name,
      'profile': profile,
      'cameraStatus': cameraStatus,
    };
  }

  factory OfferAnswer.fromMap(Map<String, dynamic> map) {
    return OfferAnswer(
      id: map['id'] != null ? map['id'] as String : null,
      sdp: map['sdp'] != null ? map['sdp'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      profile: map['profile'] != null ? map['profile'] as String : null,
      cameraStatus: map['cameraStatus'] != null ? map['cameraStatus'] as bool : null,
    );
  }

 
}
class Read {
  String? Id;
  bool? isRead;

  Read({this.Id, this.isRead});

  Read.fromJson(Map<String, dynamic> json) {
    Id = json['Id'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.Id;
    data['isRead'] = this.isRead;
    return data;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Id': Id,
      'isRead': isRead,
    };
  }

  factory Read.fromMap(Map<String, dynamic> map) {
    return Read(
      Id: map['Id'] != null ? map['Id'] as String : null,
      isRead: map['isRead'] != null ? map['isRead'] as bool : null,
    );
  }

  
}
