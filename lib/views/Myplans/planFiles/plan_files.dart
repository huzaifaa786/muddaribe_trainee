// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mudarribe_trainee/api/order_api.dart';
import 'package:mudarribe_trainee/api/trainer_profile_api.dart';
import 'package:mudarribe_trainee/components/basic_loader%20copy.dart';
import 'package:mudarribe_trainee/components/bodyworkplan.dart';
import 'package:mudarribe_trainee/components/topbar.dart';
import 'package:mudarribe_trainee/components/workoutvideocard.dart';
import 'package:mudarribe_trainee/enums/enums.dart';
import 'package:mudarribe_trainee/models/plan_file.dart';
import 'package:mudarribe_trainee/models/trainer.dart';
import 'package:mudarribe_trainee/utils/colors.dart';
import 'package:mudarribe_trainee/views/Myplans/planFiles/plan_files_controller.dart';
import 'package:mudarribe_trainee/views/chat/chat_page.dart';
import 'package:mudarribe_trainee/views/chat/pdf_view.dart';
import 'package:mudarribe_trainee/views/video/video_view.dart';

class PlanFiles extends StatefulWidget {
  const PlanFiles({super.key});

  @override
  State<PlanFiles> createState() => _PlanFilesState();
}

class _PlanFilesState extends State<PlanFiles> {
  var planId = Get.parameters['planId'] as String;
  var planName = Get.parameters['planName'] as String;
  var trainerId = Get.parameters['trainerId'] as String;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanFilesController>(
        initState: (state) async {
          Future.delayed(const Duration(milliseconds: 100), () {
            state.controller!.planId = planId;
            state.controller!.planName = planName;
            state.controller!.trainerId = trainerId;

            setState(() {});
          });
        },
        builder: (controller) => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                forceMaterialTransparency: true,
                title: TopBar(text: controller.planName.capitalize!),
              ),
              body: SafeArea(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: FutureBuilder<Trainer>(
                      future: TrainerProfileApi.fetchTrainerData(trainerId),
                      builder: (context, snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                    return SizedBox(
                      height: Get.height*0.7,
                      child: BasicLoader(
                        background: false,
                      ),
                    );
                  }
                        if (!snapshot.hasData) {
                          return Text('');
                        }
                        Trainer trainer = snapshot.data!;
                        return Column(
                          children: [
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: bgContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 8,
                                          width: 8,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: borderDown),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Get.off(() => ChatPage(
                                                arguments: ChatPageArguments(
                                                    peerId: trainer.id,
                                                    peerAvatar:
                                                        trainer.profileImageUrl,
                                                    peerNickname:
                                                        trainer.name)));
                                          },
                                          child: SvgPicture.asset(
                                            'assets/images/chat.svg',
                                            width: 26,
                                            height: 23,
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipOval(
                                          child: Container(
                                            width: 45,
                                            height: 45,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: const GradientBoxBorder(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 184, 66, 186),
                                                    Color.fromARGB(
                                                        255, 111, 127, 247),
                                                  ],
                                                ),
                                                width: 2,
                                              ),
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                    trainer.profileImageUrl),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2.0, left: 10, right: 10),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.5,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  trainer.name,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w700,
                                                    color: whitewithopacity1,
                                                  ),
                                                ),
                                                Text(
                                                  trainer.category.join('& '),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                        .withOpacity(
                                                            0.6000000238418579),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Container(
                                height: 136,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: bgContainer,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15, top: 20),
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Description',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                              color: whitewithopacity1),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            trainer.bio!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'Poppins',
                                              color: Colors.white.withOpacity(
                                                  0.6000000238418579),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.8,
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: FutureBuilder<List<PlanFile>>(
                                  future: OrderApi.getFilesByPlanId(
                                      controller.planId),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Text('');
                                    }
                                    List<PlanFile> planFiles = snapshot.data!;
                                    return ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: planFiles.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              planFiles[index].fileType ==
                                                      FileType.mp4
                                                  ? Workoutvideocard(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                VideoPlay(
                                                                    path: planFiles[
                                                                            index]
                                                                        .fileUrl!),
                                                          ),
                                                        );
                                                      },
                                                      videoName:
                                                          planFiles[index]
                                                              .fileName,
                                                      func: controller
                                                          .genrateVideoThumbnail(
                                                              planFiles[index]
                                                                  .fileUrl),
                                                    )
                                                  : Bodyworkplan(
                                                    onTap: (){
                                                         String remotePDFpath;
                                                controller
                                                    .createFileOfPdfUrl(
                                                        
                                                            planFiles[index]
                                                            .fileUrl)
                                                    .then((f) {
                                                  setState(() {
                                                    remotePDFpath = f.path;

                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PDFScreen(
                                                                path:
                                                                    remotePDFpath),
                                                      ),
                                                    );
                                                  });
                                                });
                                                    },
                                                      mytext: planFiles[index]
                                                          .fileName,
                                                    ),
                                            ],
                                          );
                                        });
                                  }),
                            ),
                          ],
                        );
                      }),
                ),
              )),
            ));
  }
}
