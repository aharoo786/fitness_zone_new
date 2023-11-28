// import 'package:farm_sharing/common_utils/validators/validators.dart';
// import 'package:farm_sharing/ui/widgets/custom_textfield.dart';
// import 'package:farm_sharing/ui/widgets/toasts.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
//
// import '../../../../controllers/auth_controller/auth_controller.dart';
// import '../../../values/values.dart';
// import '../../../widgets/custom_button.dart';
//
// class ForgotPassword extends StatelessWidget {
//   TextEditingController email = TextEditingController();
//   GlobalKey<FormState> emailFormKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<AuthController>(builder: (authController) {
//       return GestureDetector(
//         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: MyColors.bodyBackground,
//             elevation: 0,
//             leading: IconButton(
//               icon: Image.asset(
//                 MyImgs.back1,
//                 height: (Dimens.size22.h),
//                 width: (Dimens.size22.w),
//                 color: MyColors.iconColor2,
//                 fit: BoxFit.cover,
//               ),
//               onPressed: () => Get.back(),
//             ),
//
//           ),
//           backgroundColor: MyColors.bodyBackground,
//           body: SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: Dimens.size36.w),
//               child: Form(
//                 key: emailFormKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       height: Dimens.size40.h,
//                     ),
//                     Text(
//                       'Forgot Password?'.tr,
//                       style: TextStyle(
//                           fontWeight: FontWeight.w400,
//                           fontSize: Dimens.size32.sp,
//                           color: MyColors.black),
//                     ),
//                     SizedBox(
//                       height: (Dimens.size42).h,
//                     ),
//                     Image.asset(
//                       MyImgs.lock2,
//                       height: 104.h,
//                       width: Dimens.size83.w,
//                       color: MyColors.primaryColor,
//                     ),
//                     SizedBox(
//                       height: 92.h,
//                     ),
//                     Text(
//                       'Please enter your email address to receive a verification code'.tr,
//                       style: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: (Dimens.size16).sp,
//                         color: MyColors.black,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                     SizedBox(
//                       height: 31.h,
//                     ),
//                     Container(
//                       alignment: Alignment.centerLeft,
//                       decoration: BoxDecoration(
//                         color: MyColors.textFieldColor,
//                         borderRadius: BorderRadius.circular(48),
//                         // boxShadow: [
//                         //   BoxShadow(
//                         //     color: Colors.grey.withOpacity(0.4),
//                         //     blurRadius: 2.0,
//                         //     spreadRadius: 0.0,
//                         //     offset: Offset(
//                         //         0.0, 2.0), // shadow direction: bottom right
//                         //   )
//                         // ],
//                       ),
//                       width: double.infinity,
//                       child: CustomTextField(
//                           height: 48.h,
//                           icon: null,
//                           controller: email,
//                           text: "Enter email".tr,
//                           background: MyColors.textFieldColor,
//                           roundCorner: 30,
//                           length: 50,
//                           validator: (value) =>
//                               Validators.emailValidator(value!),
//                           keyboardType: TextInputType.emailAddress,
//                           inputFormatters:
//                               FilteringTextInputFormatter.singleLineFormatter),
//                     ),
//                     SizedBox(
//                       height: Dimens.size60.h,
//                     ),
//                     CustomButton(
//
//                       text: 'Send Code'.tr,
//                       onPressed: () {
//                     if (emailFormKey.currentState!.validate()) {
//                       authController.forgotPassword(email: email.text);
//                     } else {
//                       CustomToast.failToast(msg: "Please enter valid data".tr);
//                     }
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
