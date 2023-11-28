import 'package:fitnesss_app/UI/dashboard_module/bottom_bar_screen/bottom_bar_screen.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:fitnesss_app/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../helper/validators.dart';
import '../../../values/constants.dart';
import '../../../values/dimens.dart';
import '../../../values/my_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class Login extends StatelessWidget {
  Login({super.key});

  // TextEditingController countryCode =

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;
    var mediaQuery = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 300.h,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage(MyImgs.loginCurve),
                      fit: BoxFit.cover,
                    )),
                    child: Text(
                      "Fitnesszone",
                      style: textTheme.headlineLarge!
                          .copyWith(fontSize: 48.sp, color: Colors.white),
                    ),
                  ),
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
                padding: EdgeInsets.symmetric(horizontal: Dimens.size20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi There!",
                      style: textTheme.headlineSmall!
                          .copyWith(fontSize: 24.sp, color: MyColors.black),
                    ),
                    SizedBox(
                      height: Dimens.size5.h,
                    ),
                    Text(
                      "Welcome back, Sign in to your account",
                      style: textTheme.bodyMedium!.copyWith(
                          color: MyColors.lightTextColor,
                          fontWeight: FontWeight.w400),
                    ),

                    SizedBox(
                      height: Dimens.size32.h,
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
                        controller: authController.loginUserPhone,
                        // dropdownIconPosition: IconPosition.trailing,
                        autovalidateMode: AutovalidateMode.disabled,
                        disableLengthCheck: true,
                        validator: (value) =>
                            Validators.phoneNumber(value!.toString()),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),

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
                          authController.countryCode = country.dialCode;
                          Get.log('Country changed to: ${country.dialCode}');
                        },
                        onSaved: (phoneNumber) {
                          print(phoneNumber);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),

                    CustomTextField(
                      controller: authController.loginUserPassword,
                      keyboardType: TextInputType.text,
                      text: "Password".tr,
                      length: 30,
                      inputFormatters:
                          FilteringTextInputFormatter.singleLineFormatter,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    SizedBox(
                      height: Dimens.size40.h,
                    ),
                    CustomButton(
                        text: "Sign In",
                        onPressed: () async {
                          if (authController.loginUserPhone.text.isEmpty ||
                              authController.loginUserPassword.text.isEmpty) {
                            CustomToast.failToast(
                                msg: "Please provide all information");
                          } else {
                            authController.loginUser();
                          }
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
