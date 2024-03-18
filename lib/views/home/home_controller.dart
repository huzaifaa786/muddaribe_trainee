// ignore_for_file: unused_field, constant_identifier_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/post_api.dart';
import 'package:mudarribe_trainee/models/event.dart';

enum Languages {
  Arabic,
  English,
  Urdu,
  Filipino,
  Spanish,
  French,
  German,
  Italian,
}

enum Gender { male, female }

enum Categories {
  body_Building,
  Yoga,
  Boxing,
  BasketBall,
  Fitness,
  Tennis,
  Swimming,
  CrossFit,
  indoor_Cycling,
  Padel,
  Calisthenics,
  animal_flow,
  Rehabilitation,
  Aerobics,
  kettle_bell,
  Stick_mobility,
  Hiking,
  Women_fitness,
  Football,
  Cycling,
  Dancing,
  Running,
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

  int chatlength = 0;
  int notilength = 0;
  void countListener() {
    FirebaseFirestore.instance
        .collection('messages')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('userSeen', isEqualTo: false)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      chatlength = querySnapshot.docs.length;
      print('Number of documents: $chatlength');
      update();
    });
  }

  void notiCountListener() {
    FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('seen', isEqualTo: false)
        .snapshots()
        .listen((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      notilength = querySnapshot.docs.length;
      print('Number of notifications: $notilength');
      update();
    });
  }

  List<Events> bannersList = [];
  Future<void> fetchDataFromFirestore() async {
    List<DocumentSnapshot> documentSnapshots = [];
    QuerySnapshot querySnapshot = await HomeApi.posterEventQuery.get();
    documentSnapshots = querySnapshot.docs;
    bannersList = documentSnapshots
        .map((documentSnapshot) =>
            Events.fromMap(documentSnapshot.data() as Map<String, dynamic>))
        .toList();
    print("BAnner Fetched ${bannersList.length}");
    update();
  }

  bool follewed = false;
  checkIfDocumentExists(String userId) async {
    try {
      // Reference to the "followed_trainers" collection
      final CollectionReference followedTrainersRef =
          FirebaseFirestore.instance.collection('followed_trainers');
      final QuerySnapshot querySnapshot = await followedTrainersRef
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        follewed = true;
        update();
      } else {
        follewed = false;
        update();
      }
    } catch (e) {
      follewed = false;
      update();
      // return false;
    }
  }

  List<Map<String, String>> cards = [
    {'title': 'Body Building', 'image': 'assets/images/bodybuilding.jpg'},
    {'title': 'Fitness', 'image': 'assets/images/fitness.jpg'},
    {'title': 'Boxing', 'image': 'assets/images/boxing.jpg'},
    {'title': 'Tennis', 'image': 'assets/images/tennis.jpg'},
    {
      'title': 'Yoga',
      'image': 'assets/images/yoga.jpg',
    },
    {'title': 'BasketBall', 'image': 'assets/images/basketball.jpg'},
    {
      'title': 'Swimming',
      'image': 'assets/images/swimming.jpg',
    },
    {'title': 'Indoor Cycling', 'image': 'assets/images/indoor-cycling.jpg'},
    {'title': 'CrossFit', 'image': 'assets/images/crossfit.jpg'},
    {'title': 'Rehabilitation', 'image': 'assets/images/rehabilitation.jpg'},
    {'title': 'Padel', 'image': 'assets/images/padel.jpg'},
    {'title': 'Calisthenics', 'image': 'assets/images/calisthenics.jpg'},
    {'title': 'Animal flow', 'image': 'assets/images/animal-flow.jpg'},
    {'title': 'Kettle bell', 'image': 'assets/images/kettlebell.jpg'},
    {'title': 'Aerobics', 'image': 'assets/images/aerobics.jpg'},
    {'title': 'Stick mobility', 'image': 'assets/images/stick-mobility.jpg'},
    {'title': 'Hiking', 'image': 'assets/images/hiking.jpg'},
    {'title': 'Women fitness', 'image': 'assets/images/women-fitness.jpg'},
    {'title': 'Football', 'image': 'assets/images/football.jpg'},
    {'title': 'Cycling', 'image': 'assets/images/cycling.jpg'},
    {'title': 'Dancing', 'image': 'assets/images/dancing.jpg'},
    {'title': 'TRX', 'image': 'assets/images/trx.jpg'},
    {'title': 'Running', 'image': 'assets/images/running.jpg'},
  ];
}
