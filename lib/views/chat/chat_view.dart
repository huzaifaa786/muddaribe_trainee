// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/chat_api.dart';
import 'package:mudarribe_trainee/components/Chat_tile.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/views/chat/chat_page.dart';

class ChatLsitScreen extends StatelessWidget {
  const ChatLsitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          automaticallyImplyLeading: false,
          title: TopBar(
            text: 'Chats',
          ),
        ),
        body: SafeArea(
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
                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future: ChatApi.fetchTainersData(messagesSnapshot!),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                    child: Text('Error: ${snapshot.error}'));
                              } else if (!snapshot.hasData) {
                                return Text('');
                              } else {
                                final tainersData = snapshot.data;
                                return tainersData!.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: tainersData.length,
                                        itemBuilder: (context, index) {
                                          final tainerData = tainersData[index];
                                          String time;
                                          int timestamp =
                                              int.parse(tainerData['time']);
                                          DateTime dateTime = DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  timestamp);
                                          DateTime now = DateTime.now();
                                          Duration difference =
                                              now.difference(dateTime);
                                          if (difference.inMinutes < 60) {
                                            time =
                                                '${difference.inMinutes}m ago';
                                          } else if (difference.inHours < 24) {
                                            time = '${difference.inHours}h ago';
                                          } else {
                                            time = dateTime
                                                .toString()
                                                .split(' ')[0];
                                          }
                                          return ChatTile(
                                            image:
                                                tainerData['profileImageUrl'],
                                            name: tainerData['name'],
                                            ontap: () {
                                              Get.to(() => ChatPage(
                                                  arguments: ChatPageArguments(
                                                      peerId: tainerData['id'],
                                                      peerAvatar: tainerData[
                                                          'profileImageUrl'],
                                                      peerNickname:
                                                          tainerData['name'])));
                                            },
                                            seen: tainerData['seen'],
                                            time: time,
                                          );
                                        },
                                      )
                                    : Container(
                                        padding: const EdgeInsets.only(
                                            left: 14, right: 14, top: 12),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.65,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.76,
                                              padding: const EdgeInsets.only(
                                                  bottom: 12),
                                              child: Text(
                                                "No chats found".tr,
                                                textAlign: TextAlign.center,
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
    );
  }
}
