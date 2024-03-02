import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/coupon_code_api.dart';
import 'package:mudarribe_trainee/api/event_api.dart';
import 'package:mudarribe_trainee/models/coupon_code.dart';
import 'package:mudarribe_trainee/services/notification_service.dart';
import 'package:mudarribe_trainee/services/payment_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_view.dart';

class EventcheckoutController extends GetxController {
  static EventcheckoutController instance = Get.find();
  final _paymentService = PaymentService();
  final _couponCodeApi = CouponCodeApi();
  final notificationService = NotificationService();
  final _eventApi = EventApi();
  TextEditingController promoCode = TextEditingController();
  String eventId = '';
  String price = '';
  String total = '';
  String firebaseToken = '';
  String id = '';
  int discount = 0;
  bool isCode = false;

  PaymentMethod? site;
  toggleplan(PaymentMethod value) {
    site = value;
    update();
  }

  @override
  void onInit() {
    site = PaymentMethod.visa;
    update();
    super.onInit();
  }

  void payEventCharges(pricetotal, trainerId) async {
    bool isPayment = await _paymentService.makePayment(int.parse(pricetotal));

    if (isPayment) {
      await _eventApi.joinEvent(eventId, int.parse(pricetotal), trainerId);
      notificationService.postNotification(
          title: 'Event Joined!',
          body: 'Event joined Succesfully!',
          receiverToken: firebaseToken);
      String notiId = DateTime.now().millisecondsSinceEpoch.toString();
      await FirebaseFirestore.instance
          .collection('notifications')
          .doc(notiId)
          .set({
        'id': notiId,
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'trainerId': id,
        'content': 'Event joined successfully.',
        'orderId': '',
        'seen': false,
        'trainerSeen': false,
        "planId": '',
        'planName': '',
        'type': 'event'
      });
      Get.back();
      UiUtilites.successAlert(Get.context, 'Event Joined Successfully'.tr);
    }
  }

  void applyPromoCode(String trainerId) async {
    if (promoCode.text.isEmpty) {
      UiUtilites.errorSnackbar(
          'Empty Promo Code'.tr, 'Please enter code first'.tr);
      return;
    }
    CouponCode? couponCode =
        await _couponCodeApi.getPromoCode(promoCode.text, trainerId);
    if (couponCode != null) {
      discount = int.parse(price) * int.parse(couponCode.percentage) ~/ 100;
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
