import 'package:fitnesss_app/UI/auth_module/login/login.dart';
import 'package:fitnesss_app/UI/dashboard_module/profile_screen/profile_screen.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/values/constants.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:fitnesss_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../../values/my_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../choose_any_one/choose_any_one.dart';

class WalkThroughScreen extends StatelessWidget {
  const WalkThroughScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  MyImgs.walkThroughBack,
                ),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome To",
              style: textTheme.titleLarge!
                  .copyWith(fontSize: 36.sp, color: MyColors.textColor2),
            ),
            Text(
              "Fitnesszone",
              style: textTheme.titleLarge!
                  .copyWith(fontSize: 36.sp, color: MyColors.primary2),
            ),
            SizedBox(
              height: 30.h,
            ),
            CustomButton(
                text: "Get Started",
                onPressed: () {
                  Get.to(() => ChooseAnyOne());
                }),

            SizedBox(
              height: 20.h,
            ),
            CustomButton(
                text: "Continue as guest",
                onPressed: () {
                  Get.find<AuthController>()
                      .sharedPreferences
                      .setBool(Constants.isGuest, true);
                  Get.to(() => ProfileScreen());
                }),
            SizedBox(
              height: 150.h,
            ),
            //  Container(height: 5.h,width: 140.w,decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
