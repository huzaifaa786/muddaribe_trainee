// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:mudarribe_trainee/api/trainer_saved.dart';
import 'package:mudarribe_trainee/components/boxing_trainers_card.dart';
import 'package:mudarribe_trainee/components/color_button.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/home/home_controller.dart';
import 'package:mudarribe_trainee/views/search_trainer/search_trianer_binding.dart';

// import 'package:mudarribe_trainee/components/topbar.dart';

class SerachView extends StatefulWidget {
  const SerachView({super.key});

  @override
  State<SerachView> createState() => _SerachViewState();
}

class _SerachViewState extends State<SerachView> {
  String? search;
  Languages lang = Languages.English;
  Gender gender = Gender.male;
  Categories category = Categories.body_Building;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TSearchController>(
      initState: (state) {
        Future.delayed(Duration(milliseconds: 100), () {
          state.controller!.fetchTrainers();
          // state.controller!.orderStream?.listen((List<Trainer>? data) {
          //   if (data != null) {
          //     setState(() {
          //       state.controller!.items = data;
          //     });
          //   }
          // });
        });
      },
      autoRemove: false,
      builder: (controller) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          forceMaterialTransparency: true,
          title: TopBar(
            text: 'Search',
          ),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            InkWell(
              highlightColor: Colors.transparent,
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: controller.show == true
                  ? () {
                      controller.toggleShow();
                    }
                  : null,
              child: IgnorePointer(
                ignoring: controller.show == true ? true : false,
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Montserrat",
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (String val) {
                                  setState(() {
                                    search = val;
                                    controller.filterTrainers(val);
                                  });
                                },
                                decoration: InputDecoration(
                                    fillColor: bgContainer,
                                    filled: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 14, horizontal: 14),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25))),
                                    hintText: 'Search trainer by name',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.3),
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                controller.toggleShow();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: SvgPicture.asset(
                                  'assets/images/filter.svg',
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      controller.items.isNotEmpty
                          ? Flexible(
                              child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.85,
                                  child: ListView.builder(
                                    itemCount: controller.items.length,
                                    itemBuilder: (context, index) {
                                      Trainer item = controller.items[index];
                                      return BoxingTrainersCard(
                                        title: item.name,
                                        description: item.category.join('\n'),
                                        imgpath1: item.profileImageUrl,
                                        isSaved: item.isSaved,
                                        ontap: () {
                                          item.isSaved = !item.isSaved;
                                          setState(() {});
                                          item.isSaved
                                              ? TrainerSaved.trainerUnsaved(
                                                  item.id)
                                              : TrainerSaved.trainerSaved(
                                                  item.id);
                                        },
                                      );
                                    },
                                  )),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            controller.show == true
                ? Positioned(
                    top: 65,
                    right: 20,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 6.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black87,
                            borderRadius: BorderRadius.circular(15)),
                        child: Container(
                          padding: EdgeInsets.all(15),
                          width: 200,
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Categories',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildCategoryButtons()),
                              Text(
                                'Languages',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildRadioButtons()),
                              Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: white),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildGenderButtons()),
                              Align(
                                alignment: Alignment.centerRight,
                                child: GradientButton(
                                  title: 'Search',
                                  onPressed: () async {
                                    controller.lang = lang;
                                    controller.gender = gender;
                                    controller.category = category;
                                    controller.filterTrainers('');
                                    controller.toggleShow();
                                  },
                                  selected: true,
                                  buttonwidth: 0.3,
                                  buttonHeight: 40.0,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ))
                : Container()
          ],
        )),
      ),
    );
  }

  List<Widget> _buildRadioButtons() {
    List<Widget> radioButtons = [];
    for (Languages option in Languages.values) {
      radioButtons.add(
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                  scale: 1.0,
                  child: Radio(
                    value: option,
                    groupValue: lang,
                    fillColor:
                        MaterialStateColor.resolveWith((states) => borderDown),
                    onChanged: (value) {
                      setState(() {
                        lang = value!;
                      });
                    },
                  )),
              Text(
                option.toString().split('.').last,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: white),
              ),
              Text(
                '',
              ),
            ],
          ),
        ),
      );
    }
    return radioButtons;
  }

  List<Widget> _buildGenderButtons() {
    List<Widget> radioButtons = [];
    for (Gender option in Gender.values) {
      radioButtons.add(
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                  scale: 1.0,
                  child: Radio(
                    value: option,
                    groupValue: gender,
                    fillColor:
                        MaterialStateColor.resolveWith((states) => borderDown),
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  )),
              Text(
                option.toString().split('.').last,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: white),
              ),
              Text(
                '',
              ),
            ],
          ),
        ),
      );
    }
    return radioButtons;
  }

  List<Widget> _buildCategoryButtons() {
    List<Widget> radioButtons = [];
    for (Categories option in Categories.values) {
      radioButtons.add(
        SizedBox(
          height: 30,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Transform.scale(
                  scale: 1.0,
                  child: Radio(
                    value: option,
                    groupValue: category,
                    fillColor:
                        MaterialStateColor.resolveWith((states) => borderDown),
                    onChanged: (value) {
                      setState(() {
                        category = value!;
                      });
                    },
                  )),
              Text(
                option.toString().split('.').last == 'body_Building'
                    ? "Body Building"
                    : option.toString().split('.').last == 'medical_Fitness'
                        ? 'Medical Fitness'
                        : option.toString().split('.').last,
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: white),
              ),
              Text(
                '',
              ),
            ],
          ),
        ),
      );
    }
    return radioButtons;
  }
}
