import 'package:fitnesss_app/UI/dashboard_module/profile_screen/Imporatant_Screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/profile_screen/WorkOut.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../UI/dashboard_module/home_screen/home_screen.dart';
import '../UI/dashboard_module/measurement_screen/measurement_screen.dart';
import '../UI/dashboard_module/my_daily_meal/my_daily_meal.dart';
import '../UI/dashboard_module/my_recordings/my_recordings_screen.dart';
import '../UI/dashboard_module/session_screen/session_screen.dart';
import '../values/my_colors.dart';
import '../values/my_imgs.dart';
import 'package:get/get.dart';
class UserHomeScreen extends StatelessWidget {
   UserHomeScreen({Key? key}) : super(key: key);

   final AuthController authController=Get.find();
   final List<Color> colors = [
     Colors.grey,
     Colors.blueGrey,
     Colors.teal,
     Colors.cyanAccent
   ];
   final List<String> images = [
     MyImgs.yoga,
     MyImgs.zumba,
     MyImgs.cardio,
     MyImgs.mediation,
   ];
   final List<String> textList = [
     "Yoga",
     "Zumba",
     "Cardio",
     "Mediation",
   ];
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 45.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        blurRadius: 22.0,
                        spreadRadius: 0.0,
                        offset: const Offset(
                            0.0, 0.0), // shadow direction: bottom right
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            MyImgs.body,
                            scale: 4,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Finished",
                            style: textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Text("${DateTime.parse(authController.logInUser!.expireDate).difference(DateTime.now()).inDays+1}",
                          style: textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 40.sp)),
                      Text(
                        "Remaining\nDays",
                        style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            color: MyColors.black.withOpacity(0.6)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          left: 12.w,
                          top: 8.h,
                          bottom: 8.h,
                          right: 70.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 22.0,
                            spreadRadius: 0.0,
                            offset: const Offset(0.0,
                                0.0), // shadow direction: bottom right
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                MyImgs.calender,
                                scale: 4,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "Days Spend",
                                style: textTheme.bodySmall!.copyWith(
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "${DateTime.parse(authController.logInUser!.startDate).difference(DateTime.now()).inDays}",
                                  style: textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  children: [
                                    TextSpan(
                                        text: " days",
                                        style: textTheme.bodySmall!
                                            .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black
                                                .withOpacity(0.4)))
                                  ]))
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   height: 12.h,
                    // ),
                    // Container(
                    //   padding: EdgeInsets.only(
                    //       left: 12.w,
                    //       top: 8.h,
                    //       bottom: 8.h,
                    //       right: 70.w),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(8),
                    //     color: Colors.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: Colors.grey.withOpacity(0.4),
                    //         blurRadius: 22.0,
                    //         spreadRadius: 0.0,
                    //         offset: const Offset(0.0,
                    //             0.0), // shadow direction: bottom right
                    //       )
                    //     ],
                    //   ),
                    //   child: Column(
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //     children: [
                    //       Row(
                    //         children: [
                    //           Image.asset(
                    //             MyImgs.calender2,
                    //             scale: 4,
                    //           ),
                    //           SizedBox(
                    //             width: 5.w,
                    //           ),
                    //           Text(
                    //             "Days Spend",
                    //             style: textTheme.bodySmall!.copyWith(
                    //                 fontWeight: FontWeight.w400),
                    //           ),
                    //         ],
                    //       ),
                    //       RichText(
                    //           text: TextSpan(
                    //               text: "22",
                    //               style: textTheme.bodyLarge!.copyWith(
                    //                 fontWeight: FontWeight.w500,
                    //               ),
                    //               children: [
                    //                 TextSpan(
                    //                     text: " days",
                    //                     style: textTheme.bodySmall!
                    //                         .copyWith(
                    //                         fontWeight: FontWeight.w400,
                    //                         color: Colors.black
                    //                             .withOpacity(0.4)))
                    //               ]))
                    //     ],
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 40.h,
            ),
            Text(
              "Workout Plans",
              style: textTheme.headlineMedium!
                  .copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 24.h,
            ),
            SizedBox(
                height: 110.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: (){
                        //  Get.to(()=>WorkOuts());
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 10.w, right: 10.w),
                          decoration: BoxDecoration(
                            // color: Colors.yellow,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: 70.h,
                                width: 70.w,
                                decoration: BoxDecoration(
                                    color: colors[index],
                                    borderRadius: BorderRadius.circular(8)),
                                child: Image.asset(
                                  images[index],
                                  scale: 3.5,
                                ),
                              ),
                              Text(
                                textList[index],
                                style: textTheme.titleLarge!.copyWith(),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                  itemCount: textList.length,
                )),
            SizedBox(
              height: 30.h,
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Important Tips",
                      style: textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      //height: 140.h,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 26.h),
                      decoration: BoxDecoration(
                          color: const Color(0xfffcd8e0),
                          borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                "Tips for Achieving \nYour Fitness Goals",
                                style: textTheme.headlineSmall!
                                    .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff4A4A4A)),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Get.to(()=>ImportantScreen());
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Explore",
                                      style: textTheme.bodyMedium!
                                          .copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: const Color(
                                              0xff175A87)),
                                    ),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: const Color(0xff175A87)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Image.asset(
                  MyImgs.womanImage,
                  scale: 2.93,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            SizedBox(
              height: 30.h,
            ),
            Text(
              "Let’s Start",
              style: textTheme.headlineMedium!
                  .copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(
              height: 24.h,
            ),
            GestureDetector(
                onTap: () {
                  Get.to(() => MeasureMentScreen());
                },
                child: containerWidget(const Color(0xffFCE4D1),
                    "My Weekly Report", MyImgs.myWeeklyReport)),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
                onTap: () {
                  Get.to(() => MyRecordingsScreen());
                },
                child: containerWidget(const Color(0xffCCF2FE),
                    "My Recordings", MyImgs.myRecordings)),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
                onTap: () {
                  Get.to(() => MyDailyMeal());
                },
                child: containerWidget(const Color(0xffCCF2FE),
                    "My Daily Meal", MyImgs.myMeal)),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
                onTap: () {
                  Get.to(() => SessionScreen());
                },
                child: containerWidget(const Color(0xffFFF1FE),
                    "Join Live Session", MyImgs.joinLive)),
            SizedBox(
              height: 16.h,
            ),
          ],
        ),
      ),
    );
  }
}
