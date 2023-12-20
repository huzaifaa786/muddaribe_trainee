import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class TrainerProfileCard extends StatelessWidget {
  const TrainerProfileCard({
    super.key,
    this.userimg,
    this.username,
    this.bio,
    this.categories,
  });
  final userimg;
  final username;
  final bio;
  final categories;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            height: 90,
            width: 90,
            padding: EdgeInsets.all(4),
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
              child: CachedNetworkImage(imageUrl: userimg),
              // Image.network(userimg),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    username,
                    style: TextStyle(
                        color: white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Image.asset(
                      'assets/images/verified_tick.png',
                      width: 20,
                      height: 20,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    categories,
                    style: TextStyle(
                        color: profilesubheading,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    maxLines: 2,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  bio,
                  style: TextStyle(
                    color: white,
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
