import 'package:flutter/material.dart';
import 'package:mudarribe_trainee/components/packagecheckbox.dart';
import 'package:mudarribe_trainee/utils/colors.dart';

class TrainerPackageCard extends StatelessWidget {
  const TrainerPackageCard({
    super.key,
    this.category,
    this.price,
    this.name,
    this.description,
    this.duration,
    this.onchanged,
    this.onTap,
    this.id,
    this.selectedPlan,
  });
  final category;
  final onTap;
  final price;
  final name;
  final description;
  final id;
  final duration;
  final onchanged;
  final selectedPlan;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(alignment: Alignment.bottomLeft, children: [
        Container(
            height: 118,
            margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black,
              border:
                  selectedPlan == id ? Border.all(color: Colors.white) : null,
            ),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 70, top: 10, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      category == 'excercise&nutrition'
                          ? Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/packageplanimage.png',
                                    height: 19,
                                    width: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
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
                                      height: 18,
                                      width: 20),
                                ],
                              ),
                            )
                          : Text(''),
                      Row(
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: whitewithopacity1),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 6),
                            child: Text(
                              'AED',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: whitewithopacity1),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      children: [
                        category == 'excercise'
                            ? Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Image.asset(
                                  'assets/images/packageplanimage.png',
                                  height: 19,
                                  width: 20,
                                ))
                            : category == 'nutrition'
                                ? Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.asset(
                                      'assets/images/packageplanimage1.png',
                                      height: 19,
                                      width: 20,
                                    ))
                                : Text(''),
                        Text(
                          name,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: whitewithopacity1),
                        ),
                      ],
                    ),
                  ),
                  Text(description,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: whitewithopacity1)),
                ],
              ),
            )),
        Positioned(
            top: 3,
            right: 120,
            child: PackageCheckedBox(
                groupvalue: selectedPlan, value: id, onchanged: onchanged))
      ]),
    );
  }
}
