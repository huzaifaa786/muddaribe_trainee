// ignore_for_file: prefer_final_fields, sort_child_properties_last, prefer_const_constructors, avoid_unnecessary_containers, prefer_is_empty, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';
import 'package:mudarribe_trainee/services/payment_service.dart';
import 'package:mudarribe_trainee/utils/controller_initlization.dart';
import 'package:mudarribe_trainee/views/chat/chat_plan_card.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mudarribe_trainee/views/chat/full_photo_page.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/models/message_chat.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/chat/constants.dart';
import 'package:mudarribe_trainee/views/chat/controller.dart';
import 'package:mudarribe_trainee/views/chat/pdf_view.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'widgets.dart';
// import 'pages.dart';

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

  File? imageFile;
  File? pdfFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";
  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late final ChatProvider chatProvider = context.read<ChatProvider>();

  String adminToken = '';
  bool isDeleted = false;

  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
    fetchadminToken();
  }

  void fetchadminToken() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.arguments.peerId)
          .get();

      if (snapshot.exists) {
        setState(() {
          adminToken = snapshot['token'];
        });
      } else {
        print('User not found');
      }
    } catch (error) {
      print('Error fetching user token: $error');
    }
  }

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

    docRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        docRef.update({'userSeen': true}).then((_) {
          print('Update successful');
        }).catchError((error) {
          print('Error updating document: $error');
        });
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });

    final docRef1 =
        FirebaseFirestore.instance.collection('companies').doc(peerId);
    docRef1.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        isDeleted = docSnapshot.data()!['delete'];
        setState(() {});
      }
    }).catchError((error) {
      print('Error fetching document: $error');
    });
  }

  Future getImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
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
        setState(() {
          isLoading = true;
        });
        uploadPdf(pdfFile!, fileName);
        // Process your PDF file (e.g., uploadFile(pdfFile))
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
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
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
      // notificationService.postNotification(
      //     title: 'Messages',
      //     body: 'New Message Received',
      //     receiverToken: adminToken);
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

  
  get_text_between(text, start, end) {
    var index = text.indexOf(start);
    if (index == -1) {
      return "";
    }
    var index2 = text.indexOf(end, index + start.length);
    if (index2 == -1) {
      return "";
    }
    return text.substring(index + start.length, index2);
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
                messageChat.type == TypeMessage.text
                    // Text
                    ? Container(
                        child: Text(
                          messageChat.content,
                          style: TextStyle(color: Colors.black),
                        ),
                        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                        constraints: BoxConstraints(
                          maxWidth: 200,
                        ),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.circular(8)),
                        margin: EdgeInsets.only(bottom: 10, right: 10),
                      )
                    : messageChat.type == TypeMessage.image
                        // Image
                        ? Container(
                            child: OutlinedButton(
                              child: Material(
                                child: Image.network(
                                  messageChat.content,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      width: 200,
                                      height: 200,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                        ),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, object, stackTrace) {
                                    return Material(
                                      child: Image.asset(
                                        'assets/images/img_not_available.jpeg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    );
                                  },
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                clipBehavior: Clip.hardEdge,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FullPhotoPage(
                                      url: messageChat.content,
                                    ),
                                  ),
                                );
                              },
                              style: ButtonStyle(
                                  padding:
                                      MaterialStateProperty.all<EdgeInsets>(
                                          EdgeInsets.all(0))),
                            ),
                            margin: EdgeInsets.only(bottom: 10, right: 10),
                          )
                        : messageChat.type == TypeMessage.document
                            ? InkWell(
                                onTap: () {
                                  String remotePDFpath;
                                  createFileOfPdfUrl(messageChat.content)
                                      .then((f) {
                                    setState(() {
                                      remotePDFpath = f.path;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PDFScreen(path: remotePDFpath,),
                                        ),
                                      );
                                    });
                                  });
                                },
                                child: Container(
                                  width: 250,
                                  height: 60,
                                  margin: EdgeInsets.only(left: 10, bottom: 10),
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.only(
                                              right: 4, left: 4),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(45),
                                            gradient: LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [borderTop, borderDown],
                                              stops: [0.0, 1.0],
                                            ),
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/document.svg',
                                            fit: BoxFit.scaleDown,
                                          )),
                                      SizedBox(
                                        width: 200,
                                        child: Text(get_text_between(messageChat.content, "/o/", "?"),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox()
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            isLastMessageRight(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(messageChat.timestamp))),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(right: 20, bottom: 10),
                  )
                : SizedBox.shrink()
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
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
                      ? Material(
                          child: Image.network(
                            widget.arguments.peerAvatar,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey[300],
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return Icon(
                                Icons.account_circle,
                                size: 35,
                                color: Colors.grey[300],
                              );
                            },
                            width: 35,
                            height: 35,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          clipBehavior: Clip.hardEdge,
                        )
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
                              color: bgContainer,
                              borderRadius: BorderRadius.circular(8)),
                          margin: EdgeInsets.only(left: 10),
                        )
                      : messageChat.type == TypeMessage.image
                          ? Container(
                              child: TextButton(
                                child: Material(
                                  child: Image.network(
                                    messageChat.content,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8),
                                          ),
                                        ),
                                        width: 200,
                                        height: 200,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, object, stackTrace) =>
                                            Material(
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => FullPhotoPage(
                                          url: messageChat.content),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                    padding:
                                        MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(0))),
                              ),
                              margin: EdgeInsets.only(left: 10),
                            )
                          : messageChat.type == TypeMessage.document
                              ? InkWell(
                                  onTap: () {
                                    String remotePDFpath;
                                    createFileOfPdfUrl(messageChat.content)
                                        .then((f) {
                                      setState(() {
                                        remotePDFpath = f.path;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PDFScreen(path: remotePDFpath),
                                          ),
                                        );
                                      });
                                    });
                                  },
                                  child: Container(
                                    width: 250,
                                    height: 60,
                                    margin:
                                        EdgeInsets.only(left: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                        color: bgContainer,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      children: [
                                        Container(
                                            padding: EdgeInsets.all(8),
                                            margin: EdgeInsets.only(
                                                right: 4, left: 4),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              gradient: LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [borderTop, borderDown],
                                                stops: [0.0, 1.0],
                                              ),
                                            ),
                                            child: SvgPicture.asset(
                                              'assets/images/document.svg',
                                              fit: BoxFit.scaleDown,
                                            )),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            get_text_between(messageChat.content, "/o/", "?"),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : messageChat.type == TypeMessage.myplan
                                  ? Container(
                                      width: 250,
                                      margin:
                                          EdgeInsets.only(left: 10, bottom: 10),
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                          color: bgContainer,
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
                                                "Personal Plan",
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
                                              Material(
                                                child: Image.network(
                                                  widget.arguments.peerAvatar,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: Colors.grey[300],
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
                                                      color: Colors.grey[300],
                                                    );
                                                  },
                                                  width: 35,
                                                  height: 35,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(18),
                                                ),
                                                clipBehavior: Clip.hardEdge,
                                              ),
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
                                                  'View Plan',
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
                                                                  widget
                                                                      .arguments
                                                                      .peerId,
                                                                  currentUserId,
                                                                  orderId,
                                                                  paymentService
                                                                      .paymentID
                                                                      .toString());
                                                          print(
                                                              '*************************** $i');
                                                          // if (i == true) {
                                                          // notificationService.postNotification(
                                                          //     title:
                                                          //         'New order placed',
                                                          //     body:
                                                          //         'Order placed with an Order Id #$orderId',
                                                          //     receiverToken:
                                                          //         adminToken);
                                                          String content =
                                                              'Order has been created with Order Id # ' +
                                                                  orderId;
                                                          onSendMessage(content,
                                                              TypeMessage.text);
                                                          // String noti =
                                                          //     'Your order has been confirmed.';
                                                          String notiId = DateTime
                                                                  .now()
                                                              .millisecondsSinceEpoch
                                                              .toString();
                                                          String plan = 'PlanTitle:' +
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[0]
                                                                  .split(
                                                                      ":")[1] +
                                                              '~~AMOUNT:' +
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[1]
                                                                  .split(
                                                                      ":")[1] +
                                                              '~~PlanCategory:' +
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[2]
                                                                  .split(
                                                                      ":")[1] +
                                                              '~~pay:' +
                                                              'true' +
                                                              '~~PlanId:' +
                                                              messageChat
                                                                  .content
                                                                  .split(
                                                                      "~~")[4]
                                                                  .split(
                                                                      ":")[1];
                                                          print(messageChat
                                                              .timestamp);
                                                          print(groupChatId);
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'messages')
                                                              .doc(groupChatId)
                                                              .collection(
                                                                  groupChatId)
                                                              .doc(messageChat
                                                                  .timestamp)
                                                              .update({
                                                            'content': plan,
                                                          });
                                                          // chatProvider
                                                          //     .notificationCreated(
                                                          //         noti,
                                                          //         currentUserId,
                                                          //         widget
                                                          //             .arguments
                                                          //             .peerId,
                                                          //         notiId,
                                                          //         orderId);
                                                          // }
                                                        }
                                                      },
                                                      child: Text(
                                                        'Checkout',
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
                                  : SizedBox()
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                      child: Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(messageChat.timestamp))),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                      margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
                    )
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
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(
                Icons.arrow_back_ios_new,
                color: white,
              )),
          title: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7),
            child: Row(
              children: [
                CircleAvatar(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    widget.arguments.peerAvatar,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                )),
                Gap(12),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    widget.arguments.peerNickname,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: white,
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

//////////////////////////////// Loading ////////////////////////////////////////
  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : SizedBox.shrink(),
    );
  }

///////////////////////// Message Input Fields ///////////////////////////////////
  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: Container(
              child: IconButton(
                icon: Icon(Icons.more_vert),
                // onPressed: getImage,
                onPressed: () {
                  _showBottomSheet(context);
                },
                color: white,
              ),
            ),
            color: Colors.black,
          ),
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text, TypeMessage.text);
                },
                style: TextStyle(color: Colors.white, fontSize: 15),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                    hintText: 'Type here',
                    hintStyle: TextStyle(color: Colors.grey[300]),
                    fillColor: Colors.black,
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
            color: Colors.black,
          ),
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey[300]!, width: 0.5)),
          color: Colors.black),
    );
  }

///////////////////////////////// build Message List ///////////////////////////

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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext builder) {
        return Container(
          width: double.infinity,
          // You can customize the appearance of your bottom sheet here
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            topRight: Radius.circular(5))),
                  ),
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                ),
                onPressed: getImage,
                child: Text(
                  'Photos',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff0f0a06),
                  ),
                ),
              ),
              Container(
                  width: double.infinity,
                  color: bgContainer.withOpacity(0.45),
                  height: 0.5),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(5),
                            bottomRight: Radius.circular(5))),
                  ),
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                ),
                onPressed: getPdf,
                child: Text(
                  'Document',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff0f0a06),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                  ),
                  minimumSize:
                      MaterialStateProperty.all(Size(double.infinity, 50)),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff0f0a06),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<File> createFileOfPdfUrl(pdf) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final url = pdf;
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
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
