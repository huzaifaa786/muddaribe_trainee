import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/components/basic_loader.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/story/story_controller.dart';
import 'package:story_view/story_view.dart';

class StoriesView extends StatefulWidget {
  const StoriesView({super.key});

  @override
  State<StoriesView> createState() => _StoriesViewState();
}

class _StoriesViewState extends State<StoriesView> {
  @override
  Widget build(BuildContext context) {
    String id = Get.arguments;
    return GetBuilder<TrainerStoryContoller>(
      initState: (state) async {
        Future.delayed(const Duration(milliseconds: 100), () {
          state.controller!.getTrainerStories(id);
        });
      },
      builder: (controller) => controller.trainer != null
          ? Scaffold(
              body: SafeArea(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: [
                      StoryView(
                        controller: controller.storyController,
                        storyItems: controller.stories,
                        onComplete: () {
                          Get.back();
                        },
                        onStoryShow: controller.onStoryShow,
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                height: 52,
                                width: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: GradientBoxBorder(
                                    gradient: LinearGradient(colors: [
                                      Color(4290773187),
                                      Color(4285693389),
                                      Color.fromARGB(255, 32, 68, 65)
                                    ]),
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(controller
                                            .trainer!.value.profileImageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, top: 13),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        controller.trainer!.value.name,
                                        style: const TextStyle(
                                            color: white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
                                      ),
                                  
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                          controller.extractTimeAgo(
                                              controller.time.value),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ))
          : const BasicLoader(),
    );
  }
}
