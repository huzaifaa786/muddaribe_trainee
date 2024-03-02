import 'package:get/get.dart';

class TrainerprofileController extends GetxController {
  static TrainerprofileController instance = Get.find();

  RxList<bool> selections = [true, false, false].obs;
  int indexs = 0;
  void handleToggleButtons(int index) {
    for (int buttonIndex = 0; buttonIndex < selections.length; buttonIndex++) {
      selections[buttonIndex] = buttonIndex == index;
    }
    indexs = index;
    print(indexs);
    update();
  }

  RxList<String> gridItems = [
    'assets/images/post1.png',
    'assets/images/post2.png',
    'assets/images/post3.png',
    'assets/images/post4.png',
    'assets/images/post5.png',
    'assets/images/post6.png',
    'assets/images/post1.png',
    'assets/images/post2.png',
    'assets/images/post3.png',
    'assets/images/post4.png',
    'assets/images/post5.png',
    'assets/images/post6.png',
  ].obs;
  RxBool isFollowing = false.obs;
  void toggleFollow() {
    isFollowing.value = !isFollowing.value;
  }

  String? selectedPlan = '';
  toggleplan(value) {
    selectedPlan = value;

    update();
  }

  String? selectedPrice;
  toggleprice(value) {
    selectedPrice = value;
    update();
  }

  String trainerId = '';

  @override
  void onInit() {
    if (trainerId == '') {
      trainerId = Get.arguments;
    }
    update();
    super.onInit();
  }

  Future getTrainerData(id) async {
    update();
  }
}
