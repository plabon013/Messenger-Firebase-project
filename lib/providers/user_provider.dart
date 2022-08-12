import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../db/dbhelper.dart';
import '../models/usermodel.dart';

class UserProvider extends ChangeNotifier {
  List<UserModel> remainingUserList = [];

  Future<void> addUser(UserModel userModel) {
    return DbHelper.addUser(userModel);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserById(String uid) =>
      DbHelper.getUserById(uid);

  getAllRemainingUser(String uid) {
    DbHelper.getAllRemainingUsers(uid).listen((event) {
      remainingUserList = List.generate(event.docs.length, (index) =>
          UserModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Future<String> updateImage(File file) async {
    final imageName = 'Image_${DateTime.now().millisecondsSinceEpoch}';
    final photoRef = FirebaseStorage.instance.ref().child('Pictures/$imageName');
    final task = photoRef.putFile(file);
    final snapshot = await task.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> map) =>
      DbHelper.updateProfile(uid, map);
}