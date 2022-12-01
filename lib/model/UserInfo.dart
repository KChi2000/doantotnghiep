
import 'dart:convert';



class Userinfo {
  String? uid;
  String? name;
  String? email;
  static  Userinfo userSingleton = Userinfo();
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
