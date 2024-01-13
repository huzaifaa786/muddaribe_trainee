import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/utils/translation.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class ExercisesCard2 extends StatefulWidget {
  const ExercisesCard2(
      {super.key,
      this.category,
      this.planName,
      this.trainerName,
      this.trainerCategories,
      this.trainerProfile,
      this.ontap});
  final category;
  final planName;
  final trainerProfile;
  final trainerName;
  final trainerCategories;
  final ontap;

  @override
  State<ExercisesCard2> createState() => _ExercisesCard2State();
}

class _ExercisesCard2State extends State<ExercisesCard2> {
  String? translatedText;

  @override
  void initState() {
    super.initState();
    translateText1(widget.planName);
  }

  translateText1(String text) async {
    translatedText = await translateText(text);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.ontap,
      child: Container(
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
                widget.category == 'excercise&nutrition'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/packageplanimage.png',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Text(
                              '+',
                              style: TextStyle(
                                  color: white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                          Image.asset(
                            'assets/images/packageplanimage1.png',
                          ),
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: widget.category == 'excercise'
                            ? Image.asset('assets/images/packageplanimage.png')
                            : Image.asset(
                                'assets/images/packageplanimage1.png'),
                      ),
                GradientText(translatedText ?? '...',
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
                          image: NetworkImage(widget.trainerProfile),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 2.0, left: 10, right: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.trainerName,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.trainerCategories,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              color:
                                  Colors.white.withOpacity(0.6000000238418579),
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
      ),
    );
  }
}
