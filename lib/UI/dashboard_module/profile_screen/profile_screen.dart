import 'package:fitnesss_app/UI/auth_module/walt_through/walk_through_screenn.dart';
import 'package:fitnesss_app/UI/dashboard_module/profile_screen/Imporatant_Screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/profile_screen/PaymentDetails.dart';
import 'package:fitnesss_app/UI/dashboard_module/profile_screen/Success_Stories.dart';
import 'package:fitnesss_app/UI/dashboard_module/profile_screen/WorkOut.dart';
import 'package:fitnesss_app/UI/dashboard_module/profile_screen/about_us_screen.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../values/constants.dart';
import '../../../values/my_colors.dart';
import '../../../values/my_imgs.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key}) : super(key: key);
//  final HomeController homeController = Get.find();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Column(
        children: [
          Image.asset(
            'assets/icons/userScreen.png',
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 43.h,
          ),
      Center(
              child: CustomText(
            Title:     Get.find<AuthController>().sharedPreferences.getBool(Constants.isGuest)!?"Guest":Get.find<AuthController>().logInUser!.fullName,
            TitleFontSize: 20,
          )),
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                rowWidget(MyImgs.aboutUs, "About Us", () {
                  Get.to(() => AboutUsScreen());
                }),
                SizedBox(
                  height: 10.h,
                ),
                rowWidget(MyImgs.successStories, "Success Stories", () {
                  Get.to(() => Success_Stories());
                }),
                SizedBox(
                  height: 10.h,
                ),
                rowWidget(MyImgs.payment, "Important Tips", () {
                  Get.to(() =>  ImportantScreen());
                }),
                SizedBox(
                  height: 10.h,
                ),
                Get.find<AuthController>().sharedPreferences.getBool(Constants.isGuest)!?SizedBox():          rowWidget(MyImgs.logOut, "Log Out", () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(
                            "Log Out",
                            style: textTheme.headlineSmall,
                          ),
                          content: Text(
                            "Are you sure you want to logout?",
                            style: textTheme.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "Cancel",
                                  style: textTheme.bodyMedium,
                                )),
                            TextButton(
                                onPressed: () {
                                  Get.find<AuthController>()
                                      .sharedPreferences
                                      .clear();
                                  Get.offAll(() => WalkThroughScreen());
                                },
                                child: Text(
                                  "Logout",
                                  style: textTheme.bodyMedium,
                                )),
                          ],
                        );
                      });
                }),
              ],
            ),
          )

          // InkWell(
          //   onTap: () {
          //     Get.to(() => ImportantScreen()); //link AboutUs Screen here!
          //   },
          //   child: Row(
          //     children: [
          //       Image.asset('assets/icons/Layer 2.png'),
          //       CustomText(
          //         Title: "  About Us",
          //         TitleFontSize: 16,
          //       )
          //     ],
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     Get.to(Success_Stories());
          //   },
          //   child: Row(
          //     children: [
          //       Image.asset('assets/icons/ic.png'),
          //       CustomText(
          //         Title: "  Success Stories",
          //         TitleFontSize: 16,
          //       )
          //     ],
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     Get.to(Payment());
          //   },
          //   child: Row(
          //     children: [
          //       Image.asset('assets/icons/phone.png'),
          //       CustomText(
          //         Title: "  Payment Details",
          //         TitleFontSize: 16,
          //       )
          //     ],
          //   ),
          // ),
          // InkWell(
          //   onTap: () {
          //     Get.to(WorkOuts()); //link LogOut Screen here
          //   },
          //   child: Row(
          //     children: [
          //       Image.asset('assets/icons/Logout.png'),
          //       CustomText(
          //         Title: "Log Out",
          //         TitleFontSize: 16,
          //       )
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  rowWidget(String image, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                image,
                scale: 3,
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                text,
                style: TextStyle(
                    color: MyColors.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Divider(
            height: 1.h,
            color: Colors.black.withOpacity(0.2),
          )
        ],
      ),
    );
  }
}
