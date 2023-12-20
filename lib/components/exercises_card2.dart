import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisesCard2 extends StatelessWidget {
  const ExercisesCard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, right: 10, left: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Color(0x872C2723), borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset('assets/images/exercisesdartimg.png'),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Image.asset('assets/images/doumbleimg.png'),
              ),
              GradientText('Body Plan For 1 month',
                  style: TextStyle(fontSize: 16.0, fontFamily: "Poppins"),
                  colors: [borderDown, borderTop]),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: const GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 184, 66, 186),
                            Color.fromARGB(255, 111, 127, 247),
                          ],
                        ),
                        width: 2,
                      ),
                      image: DecorationImage(
                        image: AssetImage('assets/images/profile.jpg'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 10, right: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ahmed_67',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Body Building trainer',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.6000000238418579),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
