// import 'package:camera/camera.dart';
import 'package:fitnesss_app/UI/dashboard_module/call_screen/call_screen.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:fitnesss_app/helper/permissions.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:fitnesss_app/widgets/custom_button.dart';
import 'package:fitnesss_app/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
                        //final cameras = await availableCameras();
                       // final firstCamera = cameras.first;
                        Get.to(() => CallScreen(
                              channelName: channelName.text,
                              token: homeController.generatedToken!,
                              userId:
                                  Get.find<AuthController>().logInUser!.userId,
                              // camera: firstCamera,
                            ));
                      }
                    }),
                SizedBox(
                  height: 20.h,
                ),
                Get.find<AuthController>().logInUser!.type == Constants.host
                    ? CustomButton(
                        text: "Upload session video",
                        onPressed: () async {
                          _pickVideo(context);
                        })
                    : SizedBox()
                // GetBuilder<HomeController>(builder: (c) {
                //   return homeController.videoFile == null
                //       ? SizedBox()
                //       :
                // })
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

Future<void> _pickVideo(BuildContext context) async {
  try {
    PermissionOfPhotos().getFromGallery(context).then((value) async {
      if (value) {
        XFile? pickedVideo =
            await ImagePicker().pickVideo(source: ImageSource.gallery);
        if (pickedVideo != null) {
          Get.find<HomeController>()
              .uploadBytesToFirebaseStorage(pickedVideo.path);
        }
      }
    });
  } catch (e) {
    print('Error picking video: $e');
  }
}
