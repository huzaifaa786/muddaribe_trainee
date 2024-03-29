// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/chat_api.dart';
import 'package:mudarribe_trainee/components/Chat_tile.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/routes/app_routes.dart';
import 'package:mudarribe_trainee/views/chat/chat_page.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';

class ChatLsitScreen extends StatefulWidget {
  const ChatLsitScreen({super.key});

  @override
  State<ChatLsitScreen> createState() => _ChatLsitScreenState();
}

class _ChatLsitScreenState extends State<ChatLsitScreen> {
  @override
  void initState() {
    // TODO: implement initState
    if (FirebaseAuth.instance.currentUser == null) {
      Future.delayed(Duration.zero, () {
        setState(() {
          Get.toNamed(AppRoutes.signin)!.then((value) {
            Get.offAllNamed(AppRoutes.footer);
            ;
          });
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Container()
        : GetBuilder<HomeController>(
            autoRemove: false,
            builder: (controller) => Directionality(
              textDirection: TextDirection.ltr,
              child: Scaffold(
                appBar: AppBar(
                  forceMaterialTransparency: true,
                  automaticallyImplyLeading: false,
                  title: Text(
                    'Chats'.tr,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Poppins'),
                  ),
                ),
                body: SafeArea(
                  // child: CustomMaterialIndicator(
                  //   onRefresh: () async {
                  //     setState(() {});
                  //     Future.delayed(Duration(milliseconds: 1500));
                  //   },
                  //   indicatorBuilder: (context, controller) {
                  //     return CupertinoActivityIndicator();
                  //   },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        Flexible(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: ChatApi.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text('Error: ${snapshot.error}'));
                                } else if (!snapshot.hasData) {
                                  return Center(child: Text(''));
                                } else {
                                  final messagesSnapshot = snapshot.data;
                                  return FutureBuilder<
                                      List<Map<String, dynamic>>>(
                                    future: ChatApi.fetchTainersData(
                                        messagesSnapshot!),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData) {
                                        return Text('');
                                      } else {
                                        final tainersData = snapshot.data;
                                        return tainersData!.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: tainersData.length,
                                                itemBuilder: (context, index) {
                                                  final tainerData =
                                                      tainersData[index];
                                                  String time;
                                                  int timestamp = int.parse(
                                                      tainerData['time']);
                                                  DateTime dateTime = DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          timestamp);
                                                  DateTime now = DateTime.now();
                                                  Duration difference =
                                                      now.difference(dateTime);
                                                  if (difference.inMinutes <
                                                      60) {
                                                    time =
                                                        '${difference.inMinutes}m ago';
                                                  } else if (difference
                                                          .inHours <
                                                      24) {
                                                    time =
                                                        '${difference.inHours}h ago';
                                                  } else {
                                                    time = dateTime
                                                        .toString()
                                                        .split(' ')[0];
                                                  }
                                                  return ChatTile(
                                                    image: tainerData[
                                                        'profileImageUrl'],
                                                    name: tainerData['name'],
                                                    ontap: () {
                                                      Get.to(() => ChatPage(
                                                          arguments: ChatPageArguments(
                                                              peerId:
                                                                  tainerData[
                                                                      'id'],
                                                              peerAvatar:
                                                                  tainerData[
                                                                      'profileImageUrl'],
                                                              peerNickname:
                                                                  tainerData[
                                                                      'name'])));
                                                    },
                                                    seen: tainerData['seen'],
                                                    time: time,
                                                  );
                                                },
                                              )
                                            : Container(
                                                padding: const EdgeInsets.only(
                                                    left: 14,
                                                    right: 14,
                                                    top: 12),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.65,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.76,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 12),
                                                      child: Text(
                                                        "No chats found",
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLines: 2,
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ),
          );
  }
}
