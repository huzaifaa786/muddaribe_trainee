import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/chat/full_photo_page.dart';
import 'package:mudarribe_trainee/views/chat/partials/send_messages.dart';
import 'package:mudarribe_trainee/views/chat/pdf_view.dart';
import 'package:mudarribe_trainee/views/video/video_view.dart';

//! Peer Image
Widget buildPeerImage(BuildContext context, String peerAvatar) {
  return Material(
    child: Image.network(
      peerAvatar,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            color: Colors.grey[300],
            value: loadingProgress.expectedTotalBytes != null
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
  );
}

//! Image Message Container
Widget buildLeftImageMessageContent(BuildContext context, String content) {
  return Container(
    child: TextButton(
      child: Material(
        child: Image.network(
          content,
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
          errorBuilder: (context, object, stackTrace) => Material(
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
        borderRadius: BorderRadius.all(Radius.circular(8)),
        clipBehavior: Clip.hardEdge,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullPhotoPage(url: content),
          ),
        );
      },
      style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
    ),
    margin: EdgeInsets.only(left: 10),
  );
}

//! Video Message Container
Widget buildLeftVideoMessageContent(BuildContext context, String content) {
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
          color: bgContainer, borderRadius: BorderRadius.circular(8)),
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
              child: Icon(CupertinoIcons.video_camera)),
          SizedBox(
            width: 200,
            child: Text(get_text_between(content, "/o/", "?"),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    ),
  );
}

//! PDF Message Container
Widget buildLeftDocumentMessageContent(BuildContext context, String content) {
  return InkWell(
    onTap: () {
      createFileOfPdfUrl(content).then((f) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(path: f.path),
          ),
        );
      });
    },
    child: Container(
      width: 250,
      height: 60,
      margin: EdgeInsets.only(left: 10, bottom: 10),
      decoration: BoxDecoration(
          color: bgContainer, borderRadius: BorderRadius.circular(8)),
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
              )),
          SizedBox(
            width: 200,
            child: Text(
              get_text_between(content, "/o/", "?"),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: white),
            ),
          ),
        ],
      ),
    ),
  );
}

//! Last Message Time
Widget buildLastMessageTime(String timestamp) {
  return Container(
    child: Text(
      DateFormat('dd MMM kk:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))),
      style: TextStyle(
          color: Colors.grey, fontSize: 12, fontStyle: FontStyle.italic),
    ),
    margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
  );
}
