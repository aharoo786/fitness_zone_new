import 'package:fitnesss_app/UI/auth_module/login/login.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:fitnesss_app/widgets/app_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../values/constants.dart';
import '../../../values/my_colors.dart';

class ChooseAnyOne extends StatelessWidget {
  ChooseAnyOne({Key? key}) : super(key: key);
  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return Scaffold(
      // appBar: HelpingWidgets().appBarWidget(() {
      //   Get.back();
      // }),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(MyImgs.chooseAnyOne),
              Positioned(
                left: 0.w,
                top: 30.h,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30.w,
                    )),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Text(
                  "Choose Any One",
                  style: textTheme.titleLarge!.copyWith(
                    fontSize: 28.sp,
                  ),
                ),
                Text(
                  "Select your account type",
                  style: textTheme.titleLarge!.copyWith(
                      fontSize: 11.sp, color: MyColors.black.withOpacity(0.6)),
                ),
                SizedBox(
                  height: 40.h,
                ),
                GetBuilder<AuthController>(builder: (cont) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      containerWidget(context, "i’am a\nUser", MyImgs.userIcon,
                          Constants.user, () {
                           cont.loginAsA.value=Constants.user;
                           cont.update();
                          }),
                      containerWidget(context, "i’am a\nHost", MyImgs.hostIcon,
                          Constants.host, () {
                            cont.loginAsA.value=Constants.host;
                            cont.update();
                          }),
                      containerWidget(context, "i’am a\nAdmin",
                          MyImgs.adminIcon, Constants.admin, () {
                            cont.loginAsA.value=Constants.admin;
                            cont.update();
                          }),
                    ],
                  );
                })
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => Login());
        },
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
        backgroundColor: MyColors.buttonColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  containerWidget(BuildContext context, String text, String image, String user,
      VoidCallback onTap) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: 120.h,
            alignment: Alignment.bottomCenter,
            // color: Colors.black,
            child: Container(
              height: 100.h,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(
                  top: 49.h, left: 30.w, right: 30.w, bottom: 10.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: authController.loginAsA.value == user
                    ? Colors.white
                    : const Color.fromRGBO(211, 211, 214, 0.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    blurRadius: 33.0,
                    spreadRadius: 0.0,
                    offset: const Offset(
                        0.0, 2.0), // shadow direction: bottom right
                  )
                ],
              ),
              child: Text(
                text,
                style: textTheme.bodySmall!.copyWith(
                    fontWeight: FontWeight.w500,
                    color: authController.loginAsA.value == user
                        ? Colors.black
                        : Colors.black.withOpacity(0.33)),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            height: 50.h,
            width: 50.h,
            alignment: Alignment.center,
            //  margin: EdgeInsets.only(bottom: 30),
            decoration: BoxDecoration(
                color: authController.loginAsA.value == user
                    ? MyColors.buttonColor
                    : Colors.white,
                shape: BoxShape.circle),
            child: Image.asset(
              image,
              scale: 4,
              color: authController.loginAsA.value == user
                  ? Colors.white
                  : const Color.fromRGBO(211, 211, 214, 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
