import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:mudarribe_trainee/exceptions/database_api_exception.dart';
import 'package:mudarribe_trainee/models/app_user.dart';

class DatabaseApi {
  static final _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = _firestore.collection("users");

  Future<void> createUser(AppUser user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to create User',
        message: e.message,
      );
    }
  }

  Future<void> updateUser(id, user) async {
    try {
      await _usersCollection.doc(id).update(user);
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to update User',
        message: e.message,
      );
    }
  }

  Future<AppUser> getUserLogin(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();

      if (!userDoc.exists) {
        return AppUser(userType: 'trainee', id: '123');
      } else {
        final userData = userDoc.data()! as Map<String, dynamic>;
        return AppUser.fromJson(userData);
      }
    } on PlatformException catch (e) {
      throw DatabaseApiException(
        title: 'Failed to get User Data',
        message: e.message,
      );
    }
  }
}
