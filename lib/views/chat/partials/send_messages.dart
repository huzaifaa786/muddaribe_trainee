import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/models/message_chat.dart';
import 'package:mudarribe_trainee/views/chat/controller.dart';
import 'package:mudarribe_trainee/views/chat/full_photo_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/chat/pdf_view.dart';
import 'package:mudarribe_trainee/views/video/video_view.dart';

Widget buildMessageStatusIcon(bool seen) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Icon(
      seen ? Icons.done_all : Icons.done,
      color: Get.isDarkMode ? white : Colors.black,
    ),
  );
}

Widget buildRightMessageContent(BuildContext context, MessageChat messageChat) {
  switch (messageChat.type) {
    case TypeMessage.text:
      return buildRightTextMessageContent(messageChat.content);
    case TypeMessage.image:
      return buildImageMessageContent(context, messageChat);
    case TypeMessage.document:
      return buildRightDocumentMessageContent(context, messageChat.content);
    case TypeMessage.video:
      return buildVideoMessageContent(context, messageChat.content);
    default:
      return SizedBox();
  }
}

//! Text Messae
Widget buildRightTextMessageContent(String content) {
  return Container(
    child: Text(
      content,
      style: TextStyle(color: Colors.black),
    ),
    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
    constraints: BoxConstraints(maxWidth: 200),
    decoration: BoxDecoration(
      color: Get.isDarkMode ? white : grey.withOpacity(0.2),
      borderRadius: BorderRadius.circular(8),
    ),
    margin: EdgeInsets.only(bottom: 10, right: 10),
  );
}

//! Images Message
Widget buildImageMessageContent(BuildContext context, MessageChat messageChat) {
  return Container(
    child: TextButton(
      child: Material(
        child: Image.network(
          messageChat.content,
          loadingBuilder: (BuildContext context, Widget child,
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
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
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
        borderRadius: BorderRadius.all(Radius.circular(8)),
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
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
      ),
    ),
    margin: EdgeInsets.only(bottom: 10, right: 10),
  );
}

//! PDF Message Container
Widget buildRightDocumentMessageContent(BuildContext context, String content) {
  return InkWell(
    onTap: () {
      createFileOfPdfUrl(content).then((f) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(
              path: f.path,
            ),
          ),
        );
      });
    },
    child: Container(
      width: 250,
      height: 60,
      margin: EdgeInsets.only(left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 4, left: 4),
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
              'assets/images/document.svg',
              fit: BoxFit.scaleDown,
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              get_text_between(content, "/o/", "?"),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    ),
  );
}

//! Video Message Container
Widget buildVideoMessageContent(BuildContext context, String content) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VideoPlay(path: content),
        ),
      );
    },
    child: Container(
      width: 250,
      height: 60,
      margin: EdgeInsets.only(left: 10, bottom: 10),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.only(right: 4, left: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(45),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [borderTop, borderDown],
                stops: [0.0, 1.0],
              ),
            ),
            child: Icon(CupertinoIcons.video_camera),
          ),
          SizedBox(
            width: 200,
            child: Text(
              get_text_between(content, "/o/", "?"),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    ),
  );
}

//! Last Message Time
Widget buildMessageTimestamp(String timestamp) {
  return Container(
    child: Text(
      DateFormat('dd MMM kk:mm').format(
        DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp)),
      ),
      style: TextStyle(
        color: Colors.grey,
        fontSize: 12,
        fontStyle: FontStyle.italic,
      ),
    ),
    margin: EdgeInsets.only(right: 20, bottom: 10),
  );
}

//!
//? Getting Video and PDF file name From fireStorage Url's
//!
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
