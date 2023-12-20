import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mudarribe_trainee/models/message_chat.dart';
import 'package:mudarribe_trainee/views/chat/constants.dart';

class ChatProvider {
  UploadTask uploadFile(File image, String fileName) {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  UploadTask uploadPdf(File pdfFile, String fileName) {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(pdfFile);
    return uploadTask;
  }

  Future<void> updateDataFirestore(String collectionPath, String docPath,
      Map<String, dynamic> dataNeedUpdate) {
    return FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) async {
    await FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .set({
      'userId': currentUserId,
      'trainerId': peerId,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
      'userSeen': true,
      'trainerSeen': false,
    });
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
      idFrom: currentUserId,
      idTo: peerId,
      timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      type: type,
    );

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }

  orderPlacement(String planId, String trainerID, String userID, String orderId,
      String intent) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'planId': planId,
        'trainerId': trainerID,
        'userId': userID,
        'orderId': orderId,
        'type': 'My_Plan',
        'intent': intent,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  // notificationCreated(String content, String currentUserId, String peerId,
  //     String id, String orderId) async {
  //   try {
  //     // LoadingHelper.show();
  //     await FirebaseFirestore.instance.collection('notifications').doc(id).set({
  //       'id': id,
  //       'userId': currentUserId,
  //       'companyId': peerId,
  //       'content': content,
  //       'orderId': orderId,
  //       'seen': false
  //     });
  //     // LoadingHelper.dismiss();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const document = 2;
  static const myplan = 3;
  static const rating = 4;
}
