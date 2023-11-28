import 'package:fitnesss_app/UI/dashboard_module/add_new_user/add_new_user.dart';
import 'package:fitnesss_app/UI/dashboard_module/home_screen/home_screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/my_daily_meal/my_daily_meal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../UI/dashboard_module/all_user_screens/all_users_screen.dart';
import '../UI/dashboard_module/all_weekly_reports/all_weekly_report.dart';
import '../UI/dashboard_module/session_screen/session_screen.dart';
import '../values/my_colors.dart';
import '../values/my_imgs.dart';
import 'package:get/get.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
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
              Image.asset(
                MyImgs.girl,
                scale: 3,
              ),
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => AllUsersScreen());
            },
            child: containerWidget(
                const Color(0xffCCF2FE), "All Users", MyImgs.userIcon),
          ),
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => AllWeeklyReport());
            },
            child: containerWidget(const Color(0xffFCE4D1),
                "All Weekly Reports", MyImgs.myWeeklyReport),
          ),
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => SessionScreen());
            },
            child: containerWidget(
                const Color(0xffFFF1FE), "Ongoing Sessions", MyImgs.joinLive),
          ),
          SizedBox(
            height: 16.h,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => AddNewUser(isMember: true,));
            },
            child: containerWidget(
                const Color(0xffE9ECEF), "Add Team Member", MyImgs.addMember),
          ),
          SizedBox(
            height: 20.h,
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => MyDailyMeal(isAnnouceMent: true,));
            },
            child: containerWidget(
                const Color(0xffE6EEFF), "Announcements", MyImgs.annoucements),
          ),
        ],
      ),
    );
  }
}
