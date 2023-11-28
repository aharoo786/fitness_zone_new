import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../helper/validators.dart';
import '../../../values/constants.dart';
import '../../../values/dimens.dart';
import '../../../values/my_colors.dart';
import '../../../values/my_imgs.dart';
import '../../../widgets/app_bar_widget.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> signUpformKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: HelpingWidgets().appBarWidget(() {
        Get.back();
      }),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: signUpformKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 23.h,
                ),
                RichText(
                  text: TextSpan(
                    text: "Create a ",
                    style: textTheme.headline1!.copyWith(
                        fontSize: 24.sp,
                        color: MyColors.textColor,
                        fontWeight: FontWeight.w700),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'VerdePay',
                        style: textTheme.headline1!.copyWith(
                            fontSize: 24.sp,
                            color: MyColors.primaryColor,
                            fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                          text: '\naccount',
                          style: textTheme.headline1!.copyWith(
                              fontSize: 24.sp, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
                SizedBox(
                  height: 32.h,
                ),
                CustomTextField(
                  text: "Full name",
                  length: 500,
                  validator: (value) =>
                      Validators.firstNameValidation(value!.toString()),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
                SizedBox(
                  height: 16.h,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    color: MyColors.textFieldColor,
                    child: IntlPhoneField(
                      initialCountryCode: Constants.countryName,
                      initialValue: Constants.countryCode,
                      // dropdownIconPosition: IconPosition.trailing,
                      autovalidateMode: AutovalidateMode.disabled,
                      disableLengthCheck: true,
                      validator: (value) =>
                          Validators.phoneNumber(value!.toString()),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(20.w),

                        constraints: BoxConstraints(maxHeight: 56.h),
                        border: InputBorder.none,
                        errorText: "",
                        counterText: "",
                        hintText: "Mobile Number",
                        hintStyle: TextStyle(
                            color: MyColors.hintText,
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp),
                        errorStyle: TextStyle(fontSize: 0),
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
                          fontWeight: FontWeight.w600),
                      dropdownTextStyle: textTheme.bodyText1!
                          .copyWith(fontSize: 12, color: MyColors.black),
                      cursorWidth: 2.w,
                      cursorHeight: 20.h,
                      onChanged: (phone) {
                        Get.log(phone.completeNumber);
                      },
                      onCountryChanged: (country) {
                        Get.log('Country changed to: ' + country.name);
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
                ),
                SizedBox(
                  height: 16.h,
                ),
                CustomTextField(
                  text: "Email",
                  length: 500,
                  validator: (value) =>
                      Validators.emailValidator(value!.toString()),
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
                SizedBox(
                  height: 16.h,
                ),
                CustomTextField(
                  roundCorner: 16,
                  keyboardType: TextInputType.text,
                  validator: (value) => Validators.passwordValidator(value!),
                  text: "Password".tr,
                  length: 30,
                  inputFormatters:
                      FilteringTextInputFormatter.singleLineFormatter,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 50.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
                text: "Sign up".tr,
                onPressed: () async {
                  // if (!signUpformKey.currentState!.validate()) {
                  //   CustomToast.failToast(
                  //       msg: "Please provide all necessary information");
                  // } else {
                  //   if (Get.find<AuthController>().signUpPassword.text.length <
                  //       6) {
                  //     CustomToast.failToast(
                  //         msg: "Password should be at least 6 characters");
                  //   } else if (!Get.find<AuthController>()
                  //       .signUpEmail
                  //       .text
                  //       .isEmail) {
                  //     CustomToast.failToast(msg: "Please provide valid email");
                  //   } else {
                  //   await   Get.find<AuthController>().phoneVerification(
                  //         Get.find<AuthController>().signUPMobileNumber.text);
                  //   }
                  // }
                  // Get.offAll(() => OtpScreen());
                }),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
