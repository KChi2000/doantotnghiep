import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doantotnghiep/NetworkProvider/Networkprovider.dart';
import 'package:doantotnghiep/model/UserInfo.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

part 'pick_image_state.dart';

class PickImageCubit extends Cubit<PickImageState> {
  PickImageCubit() : super(PickImageInitial());
  void pick(ImageSource typePick) async {
    try {
      emit(PickImageLoading());
      XFile? image = await ImagePicker().pickImage(source: typePick);
      String url = await DatabaseService().uploadImage(File(image!.path));
      if (url != null && url.isNotEmpty) {
        emit(PickImageLoaded());
      }
    } on FirebaseException catch (e) {
      print('ERROR: $e');
    }
  }
}
