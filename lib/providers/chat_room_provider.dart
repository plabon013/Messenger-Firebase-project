import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_batch6/auth/firebase_auth.dart';
import 'package:firebase_batch6/db/dbhelper.dart';
import 'package:flutter/material.dart';

import '../models/message_model.dart';

class ChatRoomProvider extends ChangeNotifier {
  List<MessageModel> msgList = [];

  Future<void> addMessage(String msg) {
    final messageModel = MessageModel(
      msgId: DateTime.now().millisecondsSinceEpoch,
      userUid: AuthService.user!.uid,
      userImage: AuthService.user!.photoURL,
      userName: AuthService.user!.displayName,
      email: AuthService.user!.email!,
      msg: msg,
      timestamp: Timestamp.now(),
    );
    return DbHelper.addMsg(messageModel);
  }

  getChatRoomMessages() {
    DbHelper.getAllChatRoomMessages().listen((snapshot) {
      msgList = List.generate(snapshot.docs.length, (index) =>
          MessageModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }
}
