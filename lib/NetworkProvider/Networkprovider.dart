import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/components/showSnackbar.dart';
import 'package:doantotnghiep/helper/helper_function.dart';
import 'package:doantotnghiep/model/Group.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:location/location.dart';

import '../model/User.dart';

typedef void StreamStateCallback(MediaStream stream);

class DatabaseService {
  bool checkCanUpdate = false;
  final String? uid;
  static DatabaseService instance = DatabaseService();
  DatabaseService({this.uid});
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection('groups');
  final storageRef =
      FirebaseStorage.instance.ref('${Userinfo.userSingleton.uid}');
  Future addUserData(String fullname, String email, String sothich,
      String registration_id) async {
    var result = await userCollection.doc(uid).set({
      'fullName': fullname,
      'email': email,
      'sothich': sothich,
      'groups': [],
      'profilePic': '',
      'uid': uid,
      'registration_id': registration_id,
      'location': {'latitude': '0', 'longitude': '0'}
    });
    return result;
  }

  Future updateRegistrationId(String registration_id) async {
    await userCollection.doc(uid).update({
      'registration_id': registration_id,
    });
  }

  Future getUserData(String email) async {
    QuerySnapshot result =
        await userCollection.where('email', isEqualTo: email).get();
    return result;
  }

  Future<DocumentSnapshot<Object?>> getUserGroups() async {
    var snapshot = userCollection.doc(uid).get();
    return snapshot;
  }

  getInvitedId(String groupId) {
    return groupCollection.where('groupId', isEqualTo: groupId).snapshots();
  }

  Stream<QuerySnapshot<Object?>> getGroupsByUserId(String name) {
    return groupCollection.where('members', arrayContainsAny: [
      {'Id': uid, 'Name': name}
    ]).snapshots();
  }

  // deleteGroupInUser(String groupid, String groupname) async {
  //   // await userCollection.doc(Userinfo.userSingleton.uid).update({
  //   //   'groups': FieldValue.arrayRemove([
  //   //     {'groupId': groupid, 'GroupName': groupname}
  //   //   ])
  //   // });
  //  var userdocdata=await userCollection.get();
  //  userdocdata.docs.forEach((element) {
  //   element.reference.update({
  //      'groups': FieldValue.arrayRemove([
  //       {'groupId': groupid, 'GroupName': groupname}
  //     ])
  //   });
  //  });
  // }

  Future deleteGroup(String groupid, String groupname) async {
    await groupCollection.doc(groupid).update({
      'status': 'deleted',
      'time':
          '${DateTime.now().add(Duration(minutes: 5)).microsecondsSinceEpoch}',
      'recentMessage': 'đã xóa nhóm'
    });
    var userdocdata = await userCollection.get();
    userdocdata.docs.forEach((element) {
      element.reference.update({
        'groups': FieldValue.arrayRemove([
          {'groupId': groupid, 'GroupName': groupname}
        ])
      });
    });
  }

  Future deleteDataInFB(String groupid, String groupname) async {
    final batch = FirebaseFirestore.instance.batch();
    var messagedata =
        await groupCollection.doc(groupid).collection('Messages').get();
    messagedata.docs.forEach((element) {
      batch.delete(element.reference);
    });
    await batch.commit();
    await groupCollection.doc(groupid).delete();
    await userCollection.doc(Userinfo.userSingleton.uid).update({
      'groups': FieldValue.arrayRemove([
        {'groupId': groupid, 'GroupName': groupname}
      ])
    });
  }

//orderBy('time').
  Future<QuerySnapshot<Object?>> getGroups(String invitedId) async {
    return groupCollection.where('inviteId', isEqualTo: invitedId).get();
  }

  Future<bool> checkIfJoined(String groupid) async {
    bool joined = false;
    var docsnapshot = await userCollection.doc(uid).get();
    var listgroup = await docsnapshot['groups'];
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
        ]),
        'isReadAr': FieldValue.arrayRemove([
          {'Id': '${username}_${uid}', 'isRead': false}
        ])
      });
    } else {
      await userDoc.update({
        'groups': FieldValue.arrayUnion([
          {'groupId': groupid, 'GroupName': groupname}
        ])
      });
      await groupDoc.update({
        'members': FieldValue.arrayUnion([
          {'Id': uid, 'Name': username}
        ]),
        'isReadAr': FieldValue.arrayUnion([
          {'Id': '${username}_${uid}', 'isRead': false}
        ])
      });
    }
  }

  CreateGroup(String groupname, String adminId, String adminName,
      String inviteid) async {
    try {
      var documentRef = await groupCollection.add({
        'GroupName': groupname,
        'groupPic': '',
        'admin': {'adminId': adminId, 'adminName': adminName},
        'members': [],
        'groupId': '',
        'inviteId': inviteid,
        'recentMessage': 'Chưa có tin nhắn nào',
        'recentMessageSender': '',
        'time': '${DateTime.now().microsecondsSinceEpoch.toString()}',
        'isReadAr': [],
        'offer': {},
        'type': 'announce',
        'callStatus': ''
      });
      await documentRef.update({
        'members': FieldValue.arrayUnion([
          {'Id': adminId, 'Name': adminName}
        ]),
        'groupId': documentRef.id,
        'isReadAr': FieldValue.arrayUnion([
          {'Id': '${adminName}_${adminId}', 'isRead': false}
        ])
      });
      // await groupCollection
      //     .doc(documentRef.id)
      //     .collection('Messages')
      //     .doc('TypingStatus')
      //     .set({
      //   '$adminId':
      //     {'isTyping': false}

      // });
      // await groupCollection.doc(documentRef.id).set({
      //    'TypingStatus':[
      //     {
      //       'UserId': adminId, 'isTyping': false
      //     }
      //   ]
      // });
      return await userCollection.doc(uid).update({
        'groups': FieldValue.arrayUnion([
          {'groupId': documentRef.id, 'GroupName': groupname}
        ])
      });
    } on FirebaseException catch (e) {
      // showSnackbar(context, message, color)
    }
  }

  sendMessage(String groupId, Map<String, dynamic> data) async {
    checkCanUpdate = false;
    await groupCollection.doc(groupId).collection('Messages').add(data);
    var fetchdata = await groupCollection.doc(groupId).get();
    Map<String, dynamic> temp = fetchdata.data() as Map<String, dynamic>;
    List<Read>? listread = GroupInfo.fromJson(temp).isReadAr;
    List<Map<String, dynamic>> listresult = [];
    listread!.forEach((element) {
      if (element.Id != data['sender']) {
        element.isRead = false;
      } else {
        element.isRead = true;
      }

      listresult.add(element.toJson());
    });

    await groupCollection.doc(groupId).update({
      'recentMessage': data['contentMessage'],
      'recentMessageSender': data['sender'],
      'time': data['time'],
      'type': data['type'],
      'isReadAr': listresult
    });
    
  }

  updateisReadMessage(String grId) async {
    var fetchdata = await groupCollection.doc(grId).get();

    Map<String, dynamic> temp = await fetchdata.data() as Map<String, dynamic>;
    List<Read>? listread = GroupInfo.fromJson(temp).isReadAr;
    List<Map<String, dynamic>> listresult = [];

    listread!.forEach((element) {
      if (element.Id ==
          '${Userinfo.userSingleton.name}_${Userinfo.userSingleton.uid}') {
        element.isRead = true;
      }

      listresult.add(element.toJson());
    });
    groupCollection.doc(grId).update({'isReadAr': listresult});

   
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchMessage(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection('Messages')
        .orderBy('time')
        .snapshots();
  }

  pushLocation(LocationData location) async {
    await userCollection.doc(Userinfo.userSingleton.uid).update({
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude
      }
    });
  }

  Future<List<Userinfo>> fetchGrouplocation(GroupInfo group) async {
    var members = group.members;
    DocumentSnapshot location;
    List<Userinfo> list = [];
    await Future.forEach(
      members!,
      (element) async {
        location = await userCollection.doc(element.Id).get();
        Userinfo userinfo =
            Userinfo.fromJson(location.data() as Map<String, dynamic>);
        list.add(userinfo);
      },
    );

    return list;
  }

  Future<String> uploadImage(File image) async {
    var uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    await userCollection
        .doc(Userinfo.userSingleton.uid)
        .update({'profilePic': '$urlDownload'});
   
    return urlDownload;
  }

  Stream<DocumentSnapshot<Object?>> getProfileImage() {
    return userCollection.doc(Userinfo.userSingleton.uid).snapshots();
  }


}
