// ignore_for_file: prefer_final_fields, sort_child_properties_last, prefer_const_constructors, avoid_unnecessary_containers, prefer_is_empty, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables, depend_on_referenced_packages, unused_local_variable

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:mudarribe_trainee/services/notification_service.dart';
import 'package:mudarribe_trainee/utils/controller_initlization.dart';
import 'package:mudarribe_trainee/utils/ui_utils.dart';
import 'package:mudarribe_trainee/views/chat/chat_plan_card.dart';
import 'package:mudarribe_trainee/views/chat/partials/btn.dart';
import 'package:mudarribe_trainee/views/chat/partials/receive_messages.dart';
import 'package:mudarribe_trainee/views/chat/partials/send_messages.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mudarribe_trainee/models/message_chat.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/chat/constants.dart';
import 'package:mudarribe_trainee/views/chat/controller.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.arguments});

  final ChatPageArguments arguments;

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  late final String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";
  final notificationService = NotificationService();
  File? imageFile;
  File? pdfFile;
  File? videoFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  StreamSubscription<DocumentSnapshot>? chatSubscription;
  StreamSubscription<QuerySnapshot>? messageSubscription;
  late final ChatProvider chatProvider = context.read<ChatProvider>();
  String trainerToken = '';
  bool isDeleted = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
    fetchtrainerToken();
  }

  @override
  void dispose() {
    chatSubscription?.cancel();
    messageSubscription?.cancel();
    super.dispose();
  }

  void fetchtrainerToken() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.arguments.peerId)
          .get();

      if (snapshot.exists) {
        setState(() {
          trainerToken = snapshot['firebaseToken'];
        });
      } else {
        print('User not found');
      }
    } catch (error) {
      print('Error fetching user token: $error');
    }
  }

  double? ratings;

  _scrollListener() {
    if (!listScrollController.hasClients) return;
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    print(FirebaseAuth.instance.currentUser!.uid);
    if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
      currentUserId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      // Get.offAll(() => const LoginScreen());
    }
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }
    final docRef = FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId);

    // Listen for changes in the document
    chatSubscription = docRef.snapshots().listen((docSnapshot) {
      if (docSnapshot.exists) {
        docRef.update({'userSeen': true}).then((_) {
          print('Update successful');
        }).catchError((error) {
          print('Error updating document: $error');
        });
      } else {
        print('Document does not exist');
      }
    });

    final collectionRef = FirebaseFirestore.instance
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId);

    // Listen for changes in the messages collection
    final query = collectionRef.where('idFrom', isNotEqualTo: currentUserId);

    // Update the seen status for each message
    messageSubscription = query.snapshots().listen((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // Update the seen field for each document
        doc.reference.update({'seen': true}).then((_) {
          print('Update successful');
        }).catchError((error) {
          print('Error updating document: $error');
        });
      });
    });
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      bool userConfirmed = await showConfirmationDialog(context);

      if (userConfirmed) {
        if (imageFile != null) {
          setState(() {
            isLoading = true;
          });
          uploadFile();
        }
      } else {}
    }
  }

  Future getPdf() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    print(result);
    if (result != null) {
      List<File> pickedFiles = result.paths.map((path) => File(path!)).toList();
      if (pickedFiles.isNotEmpty) {
        pdfFile = pickedFiles.first;
        String? fileName = result.files.first.name;

        bool userConfirmed = await showConfirmationDialog(context);

        if (userConfirmed) {
          setState(() {
            isLoading = true;
          });
          uploadPdf(pdfFile!, fileName);
        } else {}
      }
    }
  }

  Future uploadPdf(File pdfFile, String fileName) async {
    UploadTask uploadTask = chatProvider.uploadPdf(pdfFile, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      String pdfUrl = await snapshot.ref.getDownloadURL();
      print(pdfUrl);
      setState(() {
        isLoading = false;
        onSendMessage(pdfUrl, TypeMessage.document);
      });
      Get.back();
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  Future getMp4() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );

    if (result != null) {
      List<File> pickedFiles = result.paths.map((path) => File(path!)).toList();
      if (pickedFiles.isNotEmpty) {
        videoFile = pickedFiles.first;
        String? fileName = result.files.first.name;

        bool userConfirmed = await showConfirmationDialog(context);

        if (userConfirmed) {
          setState(() {
            isLoading = true;
          });
          uploadVideo(videoFile!, fileName);
        } else {}
      }
    }
  }

  Future uploadVideo(File videoFile, String fileName) async {
    UploadTask uploadTask = chatProvider.uploadVideo(videoFile, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      String videoUrl = await snapshot.ref.getDownloadURL();
      print(videoUrl);
      setState(() {
        isLoading = false;
        onSendMessage(videoUrl, TypeMessage.video);
      });
      Get.back();
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.back();
      print(e);
    }
  }

  GetStorage box = GetStorage();

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, TypeMessage.image);
      });
      Get.back();
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      notificationService.postNotification(
          title: 'Messages',
          body: 'New Message Received',
          receiverToken: trainerToken);
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, widget.arguments.peerId);
      if (listScrollController.hasClients) {
        listScrollController.animateTo(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    } else {
      // Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // Right (my message)
        return Column(
          children: [
            Row(
              children: <Widget>[
                buildMessageStatusIcon(messageChat.seen),
                buildRightMessageContent(context, messageChat),
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            if (isLastMessageRight(index))
              buildMessageTimestamp(messageChat.timestamp),
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? buildPeerImage(context, widget.arguments.peerAvatar)
                      : Container(width: 35),
                  messageChat.type == TypeMessage.text
                      ? Container(
                          child: Text(
                            messageChat.content,
                            style: TextStyle(color: white),
                          ),
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          constraints: BoxConstraints(
                            maxWidth: 200,
                          ),
                          decoration: BoxDecoration(
                              color: bgContainer1,
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(left: 10),
                        )
                      : messageChat.type == TypeMessage.image
                          ? buildLeftImageMessageContent(
                              context, messageChat.content)
                          : messageChat.type == TypeMessage.document
                              ? buildLeftDocumentMessageContent(
                                  context, messageChat.content)
                              : messageChat.type == TypeMessage.myplan
                                  ? Container(
                                      width: 270,
                                      margin:
                                          EdgeInsets.only(left: 10, bottom: 10),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: bgContainer1,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: borderDown),
                                              ),
                                              Gap(12),
                                              Text(
                                                "Personal Plan".tr,
                                                style: const TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: white),
                                              )
                                            ],
                                          ),
                                          Gap(12),
                                          Row(
                                            children: [
                                              buildPeerImage(context,
                                                  widget.arguments.peerAvatar),
                                              Gap(12),
                                              SizedBox(
                                                width: 150,
                                                child: Text(
                                                  widget.arguments.peerNickname,
                                                  style: const TextStyle(
                                                      fontFamily: "Poppins",
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: white),
                                                ),
                                              )
                                            ],
                                          ),
                                          Gap(16),
                                          Row(
                                            children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5.0)),
                                                  ),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Colors.transparent),
                                                  minimumSize:
                                                      MaterialStateProperty.all(
                                                          Size(100, 30)),
                                                ),
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return Dialog(
                                                        child: ChatPlanPopUpCard(
                                                            img: widget
                                                                .arguments
                                                                .peerAvatar,
                                                            name: widget
                                                                .arguments
                                                                .peerNickname,
                                                            price: messageChat
                                                                .content
                                                                .split("~~")[1]
                                                                .split(":")[1]
                                                                .trim(),
                                                            title: messageChat
                                                                .content
                                                                .split("~~")[0]
                                                                .split(":")[1]
                                                                .trim(),
                                                            duration: messageChat
                                                                .content
                                                                .split("~~")[5]
                                                                .split(":")[1]
                                                                .trim(),
                                                            category:
                                                                messageChat
                                                                    .content
                                                                    .split(
                                                                        "~~")[2]
                                                                    .split(
                                                                        ":")[1]
                                                                    .trim()),
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Text(
                                                  'View Plan'.tr,
                                                  style: TextStyle(
                                                    fontFamily: "Poppins",
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: white,
                                                  ),
                                                ),
                                              ),
                                              messageChat.content
                                                          .split("~~")[3]
                                                          .split(":")[1]
                                                          .trim() ==
                                                      'false'
                                                  ? ElevatedButton(
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5.0)),
                                                        ),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(
                                                                    borderDown),
                                                        minimumSize:
                                                            MaterialStateProperty
                                                                .all(Size(
                                                                    100, 30)),
                                                      ),
                                                      onPressed: () async {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        int amount = int.parse(
                                                            messageChat.content
                                                                .split("~~")[1]
                                                                .split(":")[1]
                                                                .trim());
                                                        bool payment =
                                                            await paymentService
                                                                .makePayment(
                                                                    amount);
                                                        print(payment);
                                                        if (payment == true) {
                                                          print(
                                                              '&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                                                          String planTitle =
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[0]
                                                                  .split(":")[1]
                                                                  .trim();
                                                          print('planTitle');
                                                          print(planTitle);
                                                          String amount =
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[1]
                                                                  .split(":")[1]
                                                                  .trim();
                                                          print('ampount');
                                                          print(amount);
                                                          String category =
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[2]
                                                                  .split(":")[1]
                                                                  .trim();
                                                          print('category');
                                                          print(category);
                                                          String planid =
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[4]
                                                                  .split(":")[1]
                                                                  .trim();
                                                          print('planid');
                                                          print(planid);
                                                          String planduration =
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[5]
                                                                  .split(":")[1]
                                                                  .trim();
                                                          print('planduration');
                                                          print(planduration);
                                                          String orderId = DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch
                                                              .toString();
                                                          print('orderId');
                                                          print(orderId);
                                                          print(paymentService
                                                              .paymentID
                                                              .toString());

                                                          bool i = await chatProvider
                                                              .orderPlacement(
                                                                  planid,
                                                                  widget.arguments
                                                                      .peerId,
                                                                  currentUserId,
                                                                  orderId,
                                                                  paymentService
                                                                      .paymentID
                                                                      .toString(),
                                                                  int.parse(
                                                                      amount));
                                                          print(
                                                              '*************************** $i');
                                                          if (i == true) {
                                                            notificationService
                                                                .postNotification(
                                                                    title:
                                                                        'New order placed',
                                                                    body:
                                                                        'Order has been placed successfully.',
                                                                    // 'Thank you , your order has been confirmed',
                                                                    // 'Order placed with an Order Id #$orderId',
                                                                    receiverToken:
                                                                        trainerToken);
                                                            String content =
                                                                'Thank you , your order has been confirmed';
                                                            // 'Order has been created with Order Id # ' +
                                                            //     orderId;
                                                            onSendMessage(
                                                                content,
                                                                TypeMessage
                                                                    .text);
                                                            // String noti =
                                                            //     'Your order has been confirmed.';
                                                            String notiId =
                                                                DateTime.now()
                                                                    .millisecondsSinceEpoch
                                                                    .toString();
                                                            String plan = 'PlanTitle:' +
                                                                messageChat.content
                                                                        .split(
                                                                            "~~")[0]
                                                                        .split(":")[
                                                                    1] +
                                                                '~~AMOUNT:' +
                                                                messageChat.content
                                                                        .split(
                                                                            "~~")[1]
                                                                        .split(":")[
                                                                    1] +
                                                                '~~PlanCategory:' +
                                                                messageChat.content
                                                                        .split(
                                                                            "~~")[2]
                                                                        .split(":")[
                                                                    1] +
                                                                '~~pay:' +
                                                                'true' +
                                                                '~~PlanId:' +
                                                                messageChat
                                                                        .content
                                                                        .split(
                                                                            "~~")[4]
                                                                        .split(":")[
                                                                    1] +
                                                                '~~PlanDuration:' +
                                                                messageChat
                                                                    .content
                                                                    .split("~~")[5]
                                                                    .split(":")[1];
                                                            print(messageChat
                                                                .timestamp);
                                                            print(groupChatId);
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'messages')
                                                                .doc(
                                                                    groupChatId)
                                                                .collection(
                                                                    groupChatId)
                                                                .doc(messageChat
                                                                    .timestamp)
                                                                .update({
                                                              'content': plan,
                                                            }).then((value) =>
                                                                    print(
                                                                        'update hu gya hu !'));
                                                          }
                                                        }
                                                      },
                                                      child: Text(
                                                        'Check Out'.tr,
                                                        style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: white,
                                                        ),
                                                      ),
                                                    )
                                                  : SizedBox(),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : messageChat.type == TypeMessage.video
                                      ? buildLeftVideoMessageContent(
                                          context, messageChat.content)
                                      : Container(
                                          width: 250,
                                          margin: EdgeInsets.only(
                                              left: 10, bottom: 10),
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              color: bgContainer1,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: borderDown),
                                                  ),
                                                  Gap(12),
                                                  Text(
                                                    "Rating".tr,
                                                    style: const TextStyle(
                                                        fontFamily: "Poppins",
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: white),
                                                  )
                                                ],
                                              ),
                                              Gap(12),
                                              Row(
                                                children: [
                                                  Material(
                                                    child: Image.network(
                                                      widget
                                                          .arguments.peerAvatar,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            color: Colors
                                                                .grey[300],
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ),
                                                        );
                                                      },
                                                      errorBuilder: (context,
                                                          object, stackTrace) {
                                                        return Icon(
                                                          Icons.account_circle,
                                                          size: 35,
                                                          color:
                                                              Colors.grey[300],
                                                        );
                                                      },
                                                      width: 35,
                                                      height: 35,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(18),
                                                    ),
                                                    clipBehavior: Clip.hardEdge,
                                                  ),
                                                  Gap(12),
                                                  SizedBox(
                                                    width: 150,
                                                    child: Text(
                                                      widget.arguments
                                                          .peerNickname,
                                                      style: const TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Gap(16),
                                              RatingBar.builder(
                                                initialRating: messageChat
                                                            .content
                                                            .split("~~")[0]
                                                            .split(":")[1]
                                                            .trim() ==
                                                        '0'
                                                    ? 0
                                                    : double.parse(messageChat
                                                        .content
                                                        .split("~~")[0]
                                                        .split(":")[1]
                                                        .trim()),
                                                minRating: 1,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemSize: 25,
                                                unratedColor: Colors.grey,
                                                glow: false,
                                                ignoreGestures: messageChat
                                                            .content
                                                            .split("~~")[1]
                                                            .split(":")[1]
                                                            .trim() ==
                                                        'false'
                                                    ? false
                                                    : true,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 2.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: borderDown,
                                                  size: 15,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  ratings = rating;
                                                  setState(() {});
                                                },
                                              ),
                                              messageChat.content
                                                          .split("~~")[1]
                                                          .split(":")[1]
                                                          .trim() ==
                                                      'false'
                                                  ? Row(
                                                      children: [
                                                        ElevatedButton(
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0)),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        borderDown),
                                                            minimumSize:
                                                                MaterialStateProperty
                                                                    .all(Size(
                                                                        100,
                                                                        30)),
                                                          ),
                                                          onPressed:
                                                              ratings != null
                                                                  ? () async {
                                                                      String content = 'rating:' +
                                                                          '$ratings' +
                                                                          '~~isRating:' +
                                                                          'true';
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'messages')
                                                                          .doc(
                                                                              groupChatId)
                                                                          .collection(
                                                                              groupChatId)
                                                                          .doc(messageChat
                                                                              .timestamp)
                                                                          .update({
                                                                        'content':
                                                                            content,
                                                                      });
                                                                      chatProvider.storeRating(
                                                                          widget
                                                                              .arguments
                                                                              .peerId,
                                                                          ratings);
                                                                      print(
                                                                          content);
                                                                    }
                                                                  : () {
                                                                      UiUtilites.errorSnackbar(
                                                                          'Error!'
                                                                              .tr,
                                                                          "Rating can't be less then 1."
                                                                              .tr);
                                                                    },
                                                          child: Text(
                                                            'Submit'.tr,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  "Poppins",
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  : SizedBox()
                                            ],
                                          ),
                                        )
                ],
              ),
              // Time
              isLastMessageLeft(index)
                  ? buildLastMessageTime(messageChat.timestamp)
                  : SizedBox.shrink()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage[index - 1].get(FirestoreConstants.idFrom) !=
                currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    FocusScope.of(context).unfocus();
    Get.back();
    return Future.value(false);
  }

  //! Main Widget
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Get.isDarkMode ? white : black,
              )),
          title: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Row(
              children: [
                buildPeerImage(context, widget.arguments.peerAvatar),
                Gap(12),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    widget.arguments.peerNickname,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: WillPopScope(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    // List of messages
                    buildListMessage(),
                    // Input content
                    buildInput()
                  ],
                ),

                // Loading
                buildLoading()
              ],
            ),
            onWillPop: onBackPress,
          ),
        ),
      ),
    );
  }

//! Loading
  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : SizedBox.shrink(),
    );
  }

//! Message Input Fields
  Widget buildInput() {
    GetStorage box = GetStorage();
    return Directionality(
      textDirection: box.read('locale') == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      child: Container(
        child: Row(
          children: <Widget>[
            Material(
              child: Container(
                child: IconButton(
                  icon: Icon(
                    Icons.attach_file,
                    color: borderTop,
                  ),
                  // onPressed: getImage,
                  onPressed: () {
                    _showBottomSheet(context);
                  },
                  color: white,
                ),
              ),
              color: Get.isDarkMode ? black : white,
            ),
            Flexible(
              child: Container(
                child: TextField(
                  onSubmitted: (value) {
                    onSendMessage(textEditingController.text, TypeMessage.text);
                  },
                  style: TextStyle(
                      color: Get.isDarkMode ? white : black, fontSize: 15),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                      hintText: 'Type here ...'.tr,
                      hintStyle: TextStyle(color: Colors.grey[300]),
                      fillColor: Get.isDarkMode ? black : white,
                      filled: true),
                  focusNode: focusNode,
                  autofocus: true,
                ),
              ),
            ),

            // Button send message
            Material(
              child: InkWell(
                onTap: () =>
                    onSendMessage(textEditingController.text, TypeMessage.text),
                child: Container(
                    padding: EdgeInsets.all(8),
                    margin: EdgeInsets.only(right: 8, left: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [borderTop, borderDown],
                        stops: [0.0, 1.0],
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/images/send.svg',
                      fit: BoxFit.scaleDown,
                    )),
              ),
              color: Get.isDarkMode ? black : white,
            ),
          ],
        ),
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
            color: Get.isDarkMode ? black : white),
      ),
    );
  }

//! build Message List

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatStream(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.length > 0) {
                    return ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemBuilder: (context, index) =>
                          buildItem(index, snapshot.data?.docs[index]),
                      itemCount: snapshot.data?.docs.length,
                      reverse: true,
                      controller: listScrollController,
                    );
                  } else {
                    return Center(
                        child: Text(
                      "No message here yet...",
                      style: TextStyle(color: white),
                    ));
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

//! Build model sheet to send Messages
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext builder) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              BottomSheetButton(text: 'Photos'.tr, ontap: getImage),
              Container(
                  width: double.infinity,
                  color: bgContainer1.withOpacity(0.45),
                  height: 0.5),
              BottomSheetButton(text: 'Video'.tr, ontap: getMp4),
              Container(
                  width: double.infinity,
                  color: bgContainer1.withOpacity(0.45),
                  height: 0.5),
              BottomSheetButton(text: 'Document'.tr, ontap: getPdf),
              SizedBox(height: 20),
              BottomSheetButton(
                  text: 'Cancel'.tr,
                  ontap: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        );
      },
    );
  }
}

/////////////////////////// Page Arguments /////////////////////////////
class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(
      {required this.peerId,
      required this.peerAvatar,
      required this.peerNickname});
}
