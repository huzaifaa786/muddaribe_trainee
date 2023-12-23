import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/coupon_code_api.dart';
import 'package:mudarribe_trainee/api/event_api.dart';
import 'package:mudarribe_trainee/api/package_api.dart';
import 'package:mudarribe_trainee/models/coupon_code.dart';
import 'package:mudarribe_trainee/services/payment_service.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/trainer/event_checkout/event_checkout_view.dart';
import 'package:mudarribe_trainee/views/trainer/packages_checkout/package_checkout_view.dart';

class Packagecheckoutcontroller extends GetxController {
  static Packagecheckoutcontroller instance = Get.find();

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

  void payPackageCharges(trainerId, userid, orderId) async {
    bool isPayment;
    total == ''
        ? isPayment = await _paymentService.makePayment(int.parse(price))
        : isPayment = await _paymentService.makePayment(int.parse(total));
    String intent = _paymentService.paymentID.toString();

    if (isPayment) {
      await _packageApi.orderPlacement(
          packageId, trainerId, userid, orderId, intent);

      Get.back();
      UiUtilites.successAlert(Get.context, 'Package Subscribed Successfully');
    }
  }

  void applyPromoCode(trainerId) async {
    if (promoCode.text.isEmpty) {
      UiUtilites.errorSnackbar('Empty Promo Code', 'Please enter code first');
      return;
    }
    CouponCode? couponCode = await _couponCodeApi.getPromoCode(promoCode.text,trainerId);
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
