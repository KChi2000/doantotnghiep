import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/components/showSnackbar.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  Future addUserData(String fullname, String email) async {
    var result = await userCollection.doc(uid).set({
      'fullName': fullname,
      'email': email,
      'groups': [],
      'profilePic': '',
      'uid': uid
    });
    return result;
  }

  Future getUserData(String email) async {
    QuerySnapshot result =
        await userCollection.where('email', isEqualTo: email).get();
    return result;
  }
   getUserGroups() async {
  return userCollection.doc(uid).snapshots();
  
  }
  Future CreateGroup(String groupname, String adminId, String adminName,String invitedId) async {
   try{ var documentRef = await groupCollection.add({
      'GroupName': groupname,
      'groupPic': '',
      'admin': {'adminId': adminId, 'adminName': adminName},
      'members': [],
      'groupsId': '',
      'inviteId': invitedId,
      'recentMessage': '',
      'recentMessageSender': ''
    });
    await documentRef.update({
      'members': FieldValue.arrayUnion([
        {'adminId': adminId, 'adminName': adminName}
      ]),
      'groupsId': documentRef.id
    });
  return await userCollection.doc(uid).update({'groups':FieldValue.arrayUnion([{'groupsId':documentRef.id,
    'GroupName':groupname}])});}
   on FirebaseException catch (e){
        // showSnackbar(context, message, color)
        print(e);
    }
  }

 
}
