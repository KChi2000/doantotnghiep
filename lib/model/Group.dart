import 'package:doantotnghiep/model/Message.dart';

class GroupInfo {
  String? recentMessageSender;
  String? inviteId;
  List<Read>? isReadAr;
  List<Members>? members;
  Admin? admin;
  String? groupId;
  String? groupPic;
  String? recentMessage;
  String? groupName;
  String? time;
  bool? checked=false;
  bool? checkIsRead=false;
  Type? type;
  String? callStatus;
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
      this.time,this.checked,
      this.checkIsRead,
      this.type,this.callStatus
      });

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
    groupId = json['groupId'];
    groupPic = json['groupPic'];
    recentMessage = json['recentMessage'];
    groupName = json['GroupName'];
    time = json['time'];
    type = Type.values.elementAt(findenum(json['type']));
    callStatus = json['callStatus'];
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
    data['groupId'] = this.groupId;
    data['groupPic'] = this.groupPic;
    data['recentMessage'] = this.recentMessage;
    data['GroupName'] = this.groupName;
    data['time']=this.time;
    data['type']= this.type!.name;
    data['callStatus']= this.callStatus;
    return data;
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