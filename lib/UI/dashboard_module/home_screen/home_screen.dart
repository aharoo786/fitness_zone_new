import 'package:fitnesss_app/UI/auth_module/sign_up_screen/sign_up_screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/all_user_screens/all_users_screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/all_weekly_reports/all_weekly_report.dart';
import 'package:fitnesss_app/UI/dashboard_module/measurement_screen/measurement_screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/my_daily_meal/my_daily_meal.dart';
import 'package:fitnesss_app/UI/dashboard_module/my_recordings/my_recordings_screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/session_screen/session_screen.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:fitnesss_app/widgets/admin_home_screen.dart';
import 'package:fitnesss_app/widgets/user_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../values/constants.dart';
import '../../../values/my_colors.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/toasts.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
  final TextEditingController controller = TextEditingController();
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
        backgroundColor: MyColors.primaryColor,
        body: Obx(() {
          if (authController.loginAsA.value == Constants.user) {
            return UserHomeScreen();
          } else if (authController.loginAsA.value == Constants.host) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 42.h, bottom: 42.h, right: 15.w, left: 130.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xffFAD8CD)),
                        child: Text(
                          "Make Your Body\nHealthy & Fit With Us",
                          style: textTheme.headlineMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Image.asset(MyImgs.girl,scale: 3,),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
              GestureDetector(
                  onTap: () {
                    Get.to(() => SessionScreen());
                  },
                  child: containerWidget(const Color(0xffCCF2FE),
                      "My Sessions", MyImgs.myRecordings)),
                  SizedBox(
                    height: 16.h,
                  ),
                ],
              ),
            );
          } else {
            return AdminHomeScreen();
          }
        }));
  }


}
containerWidget(Color color, String text, String image) {
  return Container(
    padding: EdgeInsets.all(6.h),
    decoration: BoxDecoration(
      color: MyColors.appBackground,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          blurRadius: 22.0,
          spreadRadius: 0.0,
          offset: const Offset(0.0, 0.0), // shadow direction: bottom right
        )
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8), color: color),
              child: Image.asset(
                image,
                scale: 4,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Text(
              text,
              style: TextStyle(
                  color: MyColors.textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ],
    ),
  );
}