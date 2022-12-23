class UserGroup {
  String? email;
  String? uid;
  List<Groups>? groups;
  String? fullName;
  String? profilePic;

  UserGroup(
      {this.email, this.uid, this.groups, this.fullName, this.profilePic});

  UserGroup.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    uid = json['uid'];
    if (json['groups'] != null) {
      groups = <Groups>[];
      json['groups'].forEach((v) {
        groups!.add(new Groups.fromJson(v));
      });
    }
    fullName = json['fullName'];
    profilePic = json['profilePic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['uid'] = this.uid;
    if (this.groups != null) {
      data['groups'] = this.groups!.map((v) => v.toJson()).toList();
    }
    data['fullName'] = this.fullName;
    data['profilePic'] = this.profilePic;
    return data;
  }
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