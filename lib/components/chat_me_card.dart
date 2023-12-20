import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class ChatMeCard extends StatelessWidget {
  const ChatMeCard({
    super.key,
    this.userimg,
    this.username,
    this.chatText,
    this.onChatClick,
  });
  final userimg;
  final username;
  final onChatClick;
  final chatText;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.only(left: 6, right: 6, bottom: 8 ,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: GradientBoxBorder(
                      gradient: LinearGradient(colors: const [
                        gradientred,
                        borderTop,
                        borderDown,
                        borderDown
                      ]),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: userimg,
                      fit: BoxFit.cover,
                    ),
                    // Image.network(userimg),
                  )),
              Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          username,
                          style: TextStyle(
                              color: white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Image.asset(
                            'assets/images/verified_tick.png',
                            width: 15,
                            height: 15,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 9),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Text(
                          chatText,
                          style: TextStyle(
                              color: profilesubheading,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          InkWell(
            onTap: onChatClick,
            child: SvgPicture.asset(
              'assets/images/chat.svg',
              width: 29,
              height: 29,
              fit: BoxFit.scaleDown,
            ),
          ),
        ],
      ),
    );
  }
}
