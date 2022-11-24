
import 'dart:convert';



class Userinfo {
  String? uid;
  String? name;
  String? email;
  Userinfo({
     this.uid,
     this.name,
     this.email,
  });

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

  String toJson() => json.encode(toMap());

  factory Userinfo.fromJson(String source) => Userinfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
