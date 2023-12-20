import 'package:get/get.dart';

class SavedController extends GetxController {
  static SavedController instance = Get.find();

  RxList<bool> selections = [true, false, false].obs;
  int indexs = 0;

  var gridItems;
  void handleToggleButtons(int index) {
    for (int buttonIndex = 0; buttonIndex < selections.length; buttonIndex++) {
      selections[buttonIndex] = buttonIndex == index;
    }
    indexs = index;
    print(indexs);
    update();
  }

  
}
