import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:flutter/material.dart';

import '../../../values/constants.dart';
import '../../../values/my_colors.dart';
import '../../../widgets/app_bar_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../video_player/video_player.dart';

class MyRecordingsScreen extends StatelessWidget {
  const MyRecordingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: HelpingWidgets().appBarWidget(() {
          Get.back();
        }, text: "All Recordings"),
        body: Column(
          children: [
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection(Constants.sessionVideos)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.all(20.h),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap:(){
                                Get.to(()=>VideoApp(url: snapshot.data!.docs[index]["url"],));
                              },

                              child: Container(
                                padding:
                                EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 22,
                                          offset: const Offset(0, 2),
                                          color: Colors.black.withOpacity(0.2))
                                    ],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]["date"].split("T").first,
                                            style: textTheme.bodyLarge!
                                                .copyWith(color: MyColors.textColor),
                                          ),
                                          // Text(
                                          //   "Duration: 10 minutes",
                                          //   style: textTheme.titleMedium!
                                          //       .copyWith(color: MyColors.textColor),
                                          // ),
                                        ],
                                      ),
                                      Image.asset(
                                        MyImgs.yoga2,
                                        scale: 2,
                                      )
                                    ]),
                              ),
                            );
                          },
                          itemCount:  snapshot.data!.docs.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              height: 12.h,
                            );
                          },
                        ));
                  } else {
                    return const Center(child: Text("No Weekly Reports"));
                  }
                }),

          ],
        ));
  }
}
