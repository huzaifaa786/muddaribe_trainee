import 'dart:developer';

import 'package:get/get.dart';

class BusyController extends GetxController {
  final RxBool _isBusy = RxBool(false);

  // Get the current busy state
  bool get isBusy => _isBusy.value;

  // Set the busy state to true
  void setBusy(bool busy) {
    if (busy) {
      log('Loading Started');
    }else{
      log('Loading end');
    }
    _isBusy.value = busy;
  }
}
