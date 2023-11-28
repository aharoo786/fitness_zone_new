import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/widgets/toasts.dart';
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

class AddNewUser extends StatelessWidget {
  AddNewUser({Key? key, this.isMember = false}) : super(key: key);
  final bool isMember;
  AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: HelpingWidgets().appBarWidget(() {
        Get.back();
      }, text: isMember ? "Add Member" : "Add User"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.size20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dimens.size32.h,
              ),
              CustomTextField(
                keyboardType: TextInputType.text,
                text: "Full name".tr,
                length: 30,
                controller: authController.fullNameController,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: MyColors.textFieldColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IntlPhoneField(
                  initialCountryCode: Constants.countryName,
                  initialValue: Constants.countryCode,
                  // dropdownIconPosition: IconPosition.trailing,
                  autovalidateMode: AutovalidateMode.disabled,
                  disableLengthCheck: true,
                  controller: authController.phoneNumberController,
                  validator: (value) =>
                      Validators.phoneNumber(value!.toString()),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                 contentPadding:   EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

                    constraints: BoxConstraints(maxHeight: 56.h),
                    border: InputBorder.none,
                    errorText: "",
                    counterText: "",
                    hintText: "Mobile Number",
                    hintStyle: TextStyle(
                        color: MyColors.hintText,
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp),
                    errorStyle: const TextStyle(fontSize: 0),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,

                    //     OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(16),
                    //   borderSide: BorderSide(
                    //       color: MyColors.red500, width: 0.5),
                    // ),
                  ),
                  style: TextStyle(
                      color: MyColors.textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400),
                  dropdownTextStyle: textTheme.bodyText1!
                      .copyWith(fontSize: 12, color: MyColors.black),
                  cursorWidth: 2.w,
                  cursorHeight: 20.h,
                  onChanged: (phone) {
                    Get.log(phone.completeNumber);
                  },
                  onCountryChanged: (country) {
                    Get.log('Country changed to: ${country.name}');
                    // profileController.updateCountryCode
                    //     .text = country.dialCode;

                    // Get.log('Country Code changed to: ' +
                    //     profileController
                    //         .updateCountryCode.text);
                    // profileController.update();
                  },
                  onSaved: (phoneNumber) {
                    print(phoneNumber);
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextField(
                keyboardType: TextInputType.text,
                text: "Password".tr,
                length: 30,
                controller: authController.passwordController,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter,
              ),
              SizedBox(
                height: 20.h,
              ),
              !isMember
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 180.w,
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              border: InputBorder.none,
                            ),

                            //padding: EdgeInsets.symmetric(horizontal: 10.w),
                            value: authController.durationList[0],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                authController.daysSelected = true;
                                authController.daysDurationValue = newValue;
                                if (authController.daysDurationValue ==
                                    "None") {
                                  authController.daysSelected = false;
                                }
                                //authController.loginAsA.value = newValue;
                                // When a new item is selected, update the selectedFruit variable
                              }
                            },
                            items:
                                authController.durationList.map((String user) {
                              return DropdownMenuItem<String>(
                                value: user,
                                child: Text(
                                  user,
                                  style: textTheme.bodySmall!
                                      .copyWith(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          width: 180.w,
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
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 12.h),
                              border: InputBorder.none,
                            ),

                            //padding: EdgeInsets.symmetric(horizontal: 10.w),
                            value: authController.durationListMonths[0],
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                authController.monthSelected = true;

                                authController.monthDurationValue = newValue;
                                if (authController.monthDurationValue ==
                                    "None") {
                                  authController.monthSelected = false;
                                }
                                //authController.loginAsA.value = newValue;
                                // When a new item is selected, update the selectedFruit variable
                              }
                            },
                            items: authController.durationListMonths
                                .map((String user) {
                              return DropdownMenuItem<String>(
                                value: user,
                                child: Text(
                                  user,
                                  style: textTheme.bodySmall!
                                      .copyWith(color: Colors.black),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    )
                  : Container(

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
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                          border: InputBorder.none,
                        ),

                        //padding: EdgeInsets.symmetric(horizontal: 10.w),
                        value: authController.memberDesignation[0],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            authController.memerDesig=newValue;

                            //authController.loginAsA.value = newValue;
                            // When a new item is selected, update the selectedFruit variable
                          }
                        },
                        items: authController.memberDesignation
                            .map((String user) {
                          return DropdownMenuItem<String>(
                            value: user,
                            child: Text(
                              user,
                              style: textTheme.bodySmall!
                                  .copyWith(color: Colors.black),
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
                text: "Add",
                onPressed: () async {
                  if (authController.daysSelected == true &&
                      authController.monthSelected == true) {
                    CustomToast.failToast(msg: "Please select one ");
                  } else if (authController.daysSelected == false &&
                      authController.monthSelected == false) {
                    CustomToast.failToast(msg: "Please select days or month ");
                  } else {
                    Get.find<AuthController>().addingUserToFireStore(isMember);
                  }
                }),
          ],
        ),
      ),
    );
  }
}
