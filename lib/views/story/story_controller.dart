import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/post_api.dart';
import 'package:mudarribe_trainee/api/story_api.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/models/trainer_story.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class TrainerStoryContoller extends GetxController {
  static TrainerStoryContoller instance = Get.find();
  final StoryController storyController = StoryController();
  final _homeApi = StoryApi();
  RxList<TrainerStory> firebaseStories = <TrainerStory>[].obs;
  RxList<StoryItem> stories = <StoryItem>[].obs;
  RxString time = ''.obs;

  Rx<Trainer>? trainer;

  Future<void> getTrainerStories(id) async {
    trainer = await _homeApi.fetchTrainerData(id).then((value) => value.obs);
    firebaseStories =
        await _homeApi.fetchTrainerStoryData(id).then((value) => value.obs);

    for (var story in firebaseStories) {
      int timestamp = int.parse(story.postedTime!);
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      DateTime now = DateTime.now();
      Duration difference = now.difference(dateTime);
      if (difference.inSeconds < 60) {
        time = 'just now'.obs;
      } else if (difference.inMinutes < 60) {
        time = '${difference.inMinutes}m ago'.obs;
      } else if (difference.inHours < 24) {
        time = '${difference.inHours}h ago'.obs;
      } else {
        await _homeApi.deleteStory(story.id);
        time = 'DontShow'.obs;
        print(time.value);
      }
      if (time.value != 'DontShow') {
        stories.add(StoryItem.inlineImage(
            key: Key(time.value),
            url: story.imageUrl!,
            controller: storyController,
            roundedBottom: false,
            roundedTop: false));
        update();
      }
    }
    // if(stories.length != 0)
    time = stories.first.view.key.toString().obs;
    update();
  }

  void onStoryShow(story) async {
    time = story.view.key.toString().obs;

    update();
  }

  String extractTimeAgo(String input) {
    // Define a regular expression to match the time duration
    RegExp regExp = RegExp(r'(\d+)\s*([a-z]+)\s*ago');

    // Match the regular expression against the input string
    if (input != '') {
      Match match = regExp.firstMatch(input)!;

      // Extract hours and unit from the matched result
      if (!match.isBlank!) {
        String hours = match.group(1)!;
        String unit = match.group(2)!;

        return '$hours$unit ago';
      } else {
        // Return a default value or handle the case when no match is found
        return 'Invalid format';
      }
    } else {
      return '';
    }
  }
}
