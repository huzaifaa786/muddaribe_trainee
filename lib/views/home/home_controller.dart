// ignore_for_file: unused_field, constant_identifier_names
import 'package:get/get.dart';

enum Languages {
  English,
  Italian,
  French,
  Arabic,
  German,
  Spanish,
}

enum Gender { male, female }

enum Categories {
  body_Building,
  Yoga,
  Boxing,
  Basketball,
  Fitness,
  Tennis,
  Swimming,
  medical_Fitness,
  Lifting,
}

class HomeController extends GetxController {
  static HomeController instance = Get.find();
  late int activeMeterIndex;
  // Input Toggle button function
  bool showAllCards = false;
  showAllCategory() {
    showAllCards = !showAllCards;
    update();
  }

  List<Map<String, String>> cards = [
    {
      'title': 'Body Building',
      'image': 'assets/images/tumble.png',
      'firstColor': '0xFF727DCD',
      'secondColor': '0xFF58E0FF',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'Fitness',
      'image': 'assets/images/fitness.png',
      'firstColor': '0xFFBF00C3',
      'secondColor': '0xFFFFC337',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'Boxing',
      'image': 'assets/images/boxcing.png',
      'firstColor': '0xFF727DCD',
      'secondColor': '0xFF58E0FF',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'Tennis',
      'image': 'assets/images/tennis.png',
      'firstColor': '0xFF41A95E',
      'secondColor': '0xFF58E0FF',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'Yoga',
      'image': 'assets/images/yoga.png',
      'firstColor': '0xFF9113DE',
      'secondColor': '0xFFFF9541',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'BasketBall',
      'image': 'assets/images/basketball.png',
      'firstColor': '0xFF58E0FF',
      'secondColor': '0xFF727DCD',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'Swimming',
      'image': 'assets/images/swimming.png',
      'firstColor': '0xFF970909',
      'secondColor': '0xFFB4250F',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'Medical fitness',
      'image': 'assets/images/heart.png',
      'firstColor': '0xFF727DCD',
      'secondColor': '0xFFBF31E3',
      'beginX': '0.95',
      'beginY': '-0.32',
      'endX': '-0.95',
      'endY': '0.32'
    },
    {
      'title': 'Lifting',
      'image': 'assets/images/tumble.png',
      'firstColor': '0xFF9113DE',
      'secondColor': '0xFFFF9541',
      'beginX': '0.5',
      'beginY': '-0.32',
      'endX': '-0.5',
      'endY': '0.32'
    },
  ];
}
