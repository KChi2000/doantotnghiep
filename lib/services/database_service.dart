import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/components/showSnackbar.dart';
import 'package:doantotnghiep/helper/helper_function.dart';

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

 Future<DocumentSnapshot<Object?>> getUserGroups() async {
    var snapshot =  userCollection.doc(uid).get();
    return snapshot;
  }

  getInvitedId(String groupId) {
    return groupCollection.where('groupId', isEqualTo: groupId).snapshots();
  }
Stream<QuerySnapshot<Object?>> getGroupsByUserId(String name) {
    return groupCollection.where('members', arrayContainsAny: [{'Id':uid,
    'Name':name}]).snapshots();
  }
  Future<QuerySnapshot<Object?>> getGroups(String invitedId) async {
    return groupCollection.where('inviteId', isEqualTo: invitedId).get();
  }

  Future<bool> checkIfJoined(String groupid) async {
    bool joined = false;
    var docsnapshot = await userCollection.doc(uid).get();
    var listgroup = await docsnapshot['groups'];
    print(listgroup);
    listgroup.forEach((element) {
      if (groupid.contains(element['groupId'])) {
        joined = true;
      } else {
        joined = false;
      }
    });
    return joined;
  }

  JoinToGroup(bool joined, String groupid, String groupname) async {
    DocumentReference userDoc = userCollection.doc(uid);
    DocumentReference groupDoc = groupCollection.doc(groupid);
    var username = await HelperFunctions.getLoggedUserName();
    if (joined) {
      await userDoc.update({
        'groups': FieldValue.arrayRemove([
          {'groupId': groupid, 'GroupName': groupname}
        ])
      });
      await groupDoc.update({
        'members': FieldValue.arrayRemove([
          {'Id': uid, 'Name': username}
        ])
      });
    } else {
      print('vao else');
      await userDoc.update({
        'groups': FieldValue.arrayUnion([
          {'groupId': groupid, 'GroupName': groupname}
        ])
      });
      await groupDoc.update({
        'members': FieldValue.arrayUnion([
          {'Id': uid, 'Name': username}
        ])
      });
    }
  }

  Future CreateGroup(String groupname, String adminId, String adminName,
      String invitedId) async {
    try {
      var documentRef = await groupCollection.add({
        'GroupName': groupname,
        'groupPic': '',
        'admin': {'adminId': adminId, 'adminName': adminName},
        'members': [],
        'groupId': '',
        'inviteId': invitedId,
        'recentMessage': '',
        'recentMessageSender': '',
        'time':''
      });
      await documentRef.update({
        'members': FieldValue.arrayUnion([
          {'Id': adminId, 'Name': adminName}
        ]),
        'groupId': documentRef.id
      });
      return await userCollection.doc(uid).update({
        'groups': FieldValue.arrayUnion([
          {'groupId': documentRef.id, 'GroupName': groupname}
        ])
      });
    } on FirebaseException catch (e) {
      // showSnackbar(context, message, color)
      print(e);
    }
  }
  sendMessage(String groupId, Map<String,dynamic> data){
    groupCollection.doc(groupId).collection('Messages').add(data);
    groupCollection.doc(groupId).update({
      'recentMessage':data['contentMessage'],
      'recentMessageSender':data['sender'],
      'time':data['time'],
    });
  }
 Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessage(String groupId){
   return groupCollection.doc(groupId).collection('Messages').orderBy('time').snapshots();
    
  }
}
