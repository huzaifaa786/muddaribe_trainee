import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mudarribe_trainee/models/coupon_code.dart';

class CouponCodeApi {
  Future<CouponCode?> getCouponCode(String couponCode) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('coupon_code')
        .where('CouponCode', isEqualTo: couponCode)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return CouponCode.fromMap(
          querySnapshot.docs[0].data() as Map<String, dynamic>);
    }
  }
}
