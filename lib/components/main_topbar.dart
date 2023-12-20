import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/views/chat/chat_view.dart';

class MainTopBar extends StatelessWidget {
  const MainTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/images/logo.png', height: 21),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                    onTap: () {
                      Get.to(() => const ChatLsitScreen());
                    },
                    child: SvgPicture.asset('assets/images/msg.svg',
                        fit: BoxFit.scaleDown)),
                SvgPicture.asset('assets/images/notification.svg',
                    fit: BoxFit.scaleDown)
                // Icon(Icons.abc,color: white,)
              ],
            ),
          )
        ],
      ),
    );
  }
}
