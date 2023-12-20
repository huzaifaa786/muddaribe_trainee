import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/coupon_code_api.dart';
import 'package:mudarribe_trainee/api/event_api.dart';
import 'package:mudarribe_trainee/models/coupon_code.dart';
import 'package:mudarribe_trainee/services/payment_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_view.dart';

class EventcheckoutController extends GetxController {
  static EventcheckoutController instance = Get.find();
  final _paymentService = PaymentService();
  final _couponCodeApi = CouponCodeApi();
  final _eventApi = EventApi();
  TextEditingController promoCode = TextEditingController();
  String eventId = '';
  String price = '';
  String total = '';
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

  void payEventCharges() async {
    bool isPayment = await _paymentService.makePayment(int.parse(total));

    if (isPayment) {
      await _eventApi.joinEvent(eventId);

      Get.back();
      UiUtilites.successAlert(Get.context, 'Event Joined Successfully');
    }
  }

  void applyPromoCode() async {
    if (promoCode.text.isEmpty) {
      UiUtilites.errorSnackbar('Empty Promo Code', 'Please enter code first');
      return;
    }
    CouponCode? couponCode = await _couponCodeApi.getCouponCode(promoCode.text);
    if (couponCode != null) {
      discount =
          (int.parse(price) * int.parse(couponCode.percentage) / 100).toInt();
      total = (int.parse(price) - discount).toString();
      isCode = !isCode;
      update();
    } else {
      UiUtilites.errorSnackbar(
          'Invalid Promo Code', 'Please enter correct code');
    }
  }

  var isButtonPressed = false.obs;

  void toggleButtonColor() {
    // Toggle the value when the button is pressed
    isButtonPressed.value = !isButtonPressed.value;
  }
}
