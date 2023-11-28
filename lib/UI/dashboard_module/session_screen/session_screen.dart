import 'package:fitnesss_app/UI/dashboard_module/call_screen/call_screen.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:fitnesss_app/widgets/custom_button.dart';
import 'package:fitnesss_app/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

import '../../../values/constants.dart';
import '../../../values/dimens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../values/my_colors.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/custom_textfield.dart';
import 'package:get/get.dart';

class SessionScreen extends StatelessWidget {
  SessionScreen({Key? key}) : super(key: key);
  final AuthController authController = Get.find();
  final HomeController homeController = Get.find();
  final TextEditingController channelName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("link token  ${homeController.generatedToken}");
    var textTheme = Theme.of(context).textTheme;
    return GetBuilder<HomeController>(builder: (con) {
      return Scaffold(
        appBar: HelpingWidgets().appBarWidget(() {
          Get.back();
        },
            text: authController.loginAsA.value == Constants.host
                ? "Create Channel"
                : "Join Channel"),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.size20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(authController.loginAsA.value == Constants.host
                    ? MyImgs.createChannel
                    : MyImgs.joinChannel),
                SizedBox(
                  height: 20.h,
                ),
                const Text(
                  "Welcome Back, Enter Channel Name To Join.",
                  // style:
                  //     textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 20.h,
                ),
                // Text(
                //   "Channel Name",
                //   style:
                //       textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500),
                // ),
                // SizedBox(
                //   height: Dimens.size5.h,
                // ),
                CustomTextField(
                  roundCorner: 16,
                  keyboardType: TextInputType.text,
                  text: "Channel name",
                  length: 30,
                  controller: channelName,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
                SizedBox(
                  height: 60.h,
                ),
             CustomButton(
                        text: authController.loginAsA.value == Constants.host
                            ? "Start"
                            : "Join",
                        onPressed: () async {
                          if (channelName.text.isEmpty) {
                            CustomToast.failToast(
                                msg: "Please provide channel name to join");
                          } else {
                            await _handleCameraAndMic(Permission.camera);
                            await _handleCameraAndMic(Permission.microphone);
                            homeController.getAgoraToken(channelName.text);
                            Get.to(() => CallScreen(
                                  channelName: channelName.text,
                                   token: homeController.generatedToken!,
                                  userId: Get.find<AuthController>().logInUser!.userId,
                                ));
                          }
                        }),
                SizedBox(
                  height: 20.h,
                ),
               // CustomButton(
               //          text: homeController.generatedToken == null
               //              ? "Create channel"
               //              : "Share",
               //          onPressed: () async {
               //            if (channelName.text.isEmpty) {
               //              CustomToast.failToast(
               //                  msg: "Please provide channel name to join");
               //            } else {
               //              if (homeController.generatedToken == null) {
               //                homeController.getAgoraToken(channelName.text);
               //              } else {
               //                Share.share(
               //                    "Channel Name: ${channelName.text}\n${Uri.parse("https://fominobackend.myace.app/${channelName.text}/${homeController.generatedToken}")}");
               //              }
               //            }
               //          })

              ],
            ),
          ),
        ),
      );
    });
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}
