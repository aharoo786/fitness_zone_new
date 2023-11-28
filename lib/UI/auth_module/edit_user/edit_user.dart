import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/data/models/user_model/user_model.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../helper/validators.dart';
import '../../../values/constants.dart';
import '../../../values/dimens.dart';
import '../../../values/my_colors.dart';
import '../../../widgets/app_bar_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class EditUser extends StatelessWidget {
  EditUser({Key? key, required this.userModel}) : super(key: key);
  final AuthController authController = Get.find();
  final UserModel userModel;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: HelpingWidgets().appBarWidget(() {
        Get.back();
      }, text: "Edit User"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.size20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dimens.size32.h,
              ),
              Text(
                "Extend Date",
                style: textTheme.bodySmall,
              ),
              SizedBox(
                height: 5.h,
              ),
              CustomTextField(
                keyboardType: TextInputType.text,
                text: "Duration Extend".tr,
                length: 30,
                controller: authController.dateExtendController,
                Readonly: true,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter,
                suffixIcon: GestureDetector(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                        context: context,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.light().copyWith(
                              primaryColor: MyColors
                                  .buttonColor, // OK button background color
                              hintColor:
                                  MyColors.buttonColor, // OK button text color
                              dialogBackgroundColor:
                                  Colors.white, // Dialog background color
                            ),
                            child: child!,
                          );
                        },
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2099));
                    if (picked != null) {
                      authController.dateExtendController.text =
                          "${picked.difference(DateTime.now()).inDays} days";
                    }
                  },
                  child: Image.asset(
                    MyImgs.calender2,
                    scale: 3,
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Package State",
                style: textTheme.bodySmall,
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: MyColors.textFieldColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  style: TextStyle(
                      color: MyColors.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    border: InputBorder.none,
                  ),

                  //padding: EdgeInsets.symmetric(horizontal: 10.w),
                  value: userModel.packageStatus == "start"
                      ? authController.packageState[1]
                      : authController.packageState[0],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      if (newValue == "Start") {
                        userModel.packageStatus = "start";
                      } else {
                        userModel.packageStatus = "pause";
                      }
                      //authController.loginAsA.value = newValue;
                      // When a new item is selected, update the selectedFruit variable
                    }
                  },
                  items: authController.packageState.map((String user) {
                    return DropdownMenuItem<String>(
                      value: user,
                      child: Text(
                        user,
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Screenshot Permission",
                style: textTheme.bodySmall,
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: MyColors.textFieldColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  style: TextStyle(
                      color: MyColors.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    border: InputBorder.none,
                  ),

                  //padding: EdgeInsets.symmetric(horizontal: 10.w),
                  value: userModel.screenShot
                      ? authController.screenShot[0]
                      : authController.screenShot[1],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      if (newValue == "Yes") {
                        userModel.screenShot = true;
                      } else {
                        userModel.screenShot = false;
                      }
                    }
                  },
                  items: authController.screenShot.map((String user) {
                    return DropdownMenuItem<String>(
                      value: user,
                      child: Text(
                        user,
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                "Recording Permission",
                style: textTheme.bodySmall,
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: MyColors.textFieldColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  style: TextStyle(
                      color: MyColors.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    border: InputBorder.none,
                  ),

                  //padding: EdgeInsets.symmetric(horizontal: 10.w),
                  value: userModel.recording
                      ? authController.recording[0]
                      : authController.recording[1],
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      if (newValue == "Yes") {
                        userModel.recording = true;
                      } else {
                        userModel.recording = false;
                      }
                    }
                  },
                  items: authController.recording.map((String user) {
                    return DropdownMenuItem<String>(
                      value: user,
                      child: Text(
                        user,
                        style:
                            textTheme.bodySmall!.copyWith(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: Dimens.size24.h,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
                text: "Update",
                onPressed: () async {
                  userModel.subscriptionDuration =
                      authController.dateExtendController.text;
                  userModel.startDate = DateTime.now().toIso8601String();
                  userModel.expireDate = DateTime.now()
                      .add(Duration(
                          days: int.parse(authController
                              .dateExtendController.text
                              .split(" ")
                              .first)))
                      .toIso8601String();
                  authController.updateUser(userModel);
                }),
          ],
        ),
      ),
    );
  }
}
