import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatApi {
  static Future<List<Map<String, dynamic>>> fetchTainersData(
      QuerySnapshot messagesSnapshot) async {
    List<Map<String, dynamic>> companyDataWithID = [];
    for (var document in messagesSnapshot.docs) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(document['trainerId'])
          .get();
      if (userSnapshot.exists) {
        Map<String, dynamic> companyData =
            userSnapshot.data() as Map<String, dynamic>;
        companyData['trainerId'] = document['trainerId'];
        companyData['seen'] = document['userSeen'];
        companyData['time'] = document['timestamp'];
        companyDataWithID.add(companyData);
      }
    }
    return companyDataWithID;
  }

  static Stream<QuerySnapshot<Object?>>? stream = FirebaseFirestore.instance
      .collection('messages')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .orderBy('timestamp', descending: true)
      .snapshots();
}
