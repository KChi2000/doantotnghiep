// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}
class OfferAnswer {
  String? id;
  String? sdp;
  String? type;
  String? name;
  String? profile;
  OfferAnswer({this.sdp, this.type,this.id,this.name,this.profile});

  OfferAnswer.fromJson(Map<String, dynamic> json) {
    sdp = json['sdp'];
    type = json['type'];
    id= json['id'];
    name= json['name'];
    profile = json['pic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sdp'] = this.sdp;
    data['type'] = this.type;
    data['id'] = this.id;
    data['name'] = this.name;
    data['pic'] = this.profile;
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
}
