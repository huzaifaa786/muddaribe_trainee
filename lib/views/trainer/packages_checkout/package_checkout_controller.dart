// ignore_for_file: division_optimization

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/coupon_code_api.dart';
import 'package:mudarribe_trainee/api/package_api.dart';
import 'package:mudarribe_trainee/models/coupon_code.dart';
import 'package:mudarribe_trainee/services/notification_service.dart';
import 'package:mudarribe_trainee/services/payment_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/trainer/packages_checkout/package_checkout_view.dart';

class Packagecheckoutcontroller extends GetxController {
  static Packagecheckoutcontroller instance = Get.find();
  final notificationService = NotificationService();
  final _paymentService = PaymentService();
  final _couponCodeApi = CouponCodeApi();
  final _packageApi = PackageApi();
  TextEditingController promoCode = TextEditingController();
  String packageId = '';
  String price = '';
  String total = '';
  int discount = 0;
  bool isCode = false;

  packagePaymentMethod? site;
  toggleplan(packagePaymentMethod value) {
    site = value;
    update();
  }

  @override
  void onInit() {
    site = packagePaymentMethod.visa;
    update();
    super.onInit();
  }

  void payPackageCharges(trainerId, userid, orderId, firebaseToken) async {
    bool isPayment;
    total == ''
        ? isPayment = await _paymentService.makePayment(int.parse(price))
        : isPayment = await _paymentService.makePayment(int.parse(total));
    String intent = _paymentService.paymentID.toString();

    if (isPayment) {
      if (total == '') {
        await _packageApi.orderPlacement(
            packageId, trainerId, userid, orderId, intent, int.parse(price));
        notificationService.postNotification(
            title: 'New order placed',
            body: 'Order has been placed successfully.',
            receiverToken: firebaseToken);
        String notiId = DateTime.now().millisecondsSinceEpoch.toString();

        await FirebaseFirestore.instance
            .collection('notifications')
            .doc(notiId)
            .set({
          'id': notiId,
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'trainerId': trainerId,
          'content': 'Your order has been placed.',
          'orderId': orderId,
          'seen': false,
          'trainerSeen': false,
          "planId": packageId,
          'planName': '',
          'type': 'package'
        });
        Get.back();
        UiUtilites.successAlert(
            Get.context, 'Package Subscribed Successfully'.tr);
      } else {
        await _packageApi.orderPlacement(
            packageId, trainerId, userid, orderId, intent, int.parse(total));
        notificationService.postNotification(
            title: 'New order placed',
            body: 'Order has been placed successfully.',
            receiverToken: firebaseToken);
        Get.back();
        UiUtilites.successAlert(
            Get.context, 'Package Subscribed Successfully'.tr);
      }
    }
  }

  void applyPromoCode(trainerId) async {
    if (promoCode.text.isEmpty) {
      UiUtilites.errorSnackbar(
          'Empty Promo Code'.tr, 'Please enter code first'.tr);
      return;
    }
    CouponCode? couponCode =
        await _couponCodeApi.getPromoCode(promoCode.text, trainerId);
    if (couponCode != null) {
      discount =
          (int.parse(price) * int.parse(couponCode.percentage) / 100).toInt();
      total = (int.parse(price) - discount).toString();
      isCode = !isCode;
      update();
    } else {
      UiUtilites.errorSnackbar(
          'Invalid Promo Code'.tr, 'Please enter correct code'.tr);
    }
  }

  var isButtonPressed = false.obs;

  void toggleButtonColor() {
    // Toggle the value when the button is pressed
    isButtonPressed.value = !isButtonPressed.value;
  }
}
