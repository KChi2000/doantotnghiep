class GroupInfo {
  String? recentMassageSender;
  String? inviteId;
  List<Members>? members;
  Admin? admin;
  String? groupsId;
  String? groupPic;
  String? recentMessage;
  String? groupName;

  GroupInfo(
      {this.recentMassageSender,
      this.inviteId,
      this.members,
      this.admin,
      this.groupsId,
      this.groupPic,
      this.recentMessage,
      this.groupName});

  GroupInfo.fromJson(Map<String, dynamic> json) {
    recentMassageSender = json['recentMassageSender'];
    inviteId = json['inviteId'];
    if (json['members'] != null) {
      members = <Members>[];
      json['members'].forEach((v) {
        members!.add(new Members.fromJson(v));
      });
    }
    admin = json['admin'] != null ? new Admin.fromJson(json['admin']) : null;
    groupsId = json['groupsId'];
    groupPic = json['groupPic'];
    recentMessage = json['recentMessage'];
    groupName = json['GroupName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recentMassageSender'] = this.recentMassageSender;
    data['inviteId'] = this.inviteId;
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    if (this.admin != null) {
      data['admin'] = this.admin!.toJson();
    }
    data['groupsId'] = this.groupsId;
    data['groupPic'] = this.groupPic;
    data['recentMessage'] = this.recentMessage;
    data['GroupName'] = this.groupName;
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