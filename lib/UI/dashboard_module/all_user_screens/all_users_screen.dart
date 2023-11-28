import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesss_app/UI/auth_module/edit_user/edit_user.dart';
import 'package:fitnesss_app/UI/dashboard_module/add_new_user/add_new_user.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/data/models/user_model/user_model.dart';
import 'package:fitnesss_app/values/my_imgs.dart';
import 'package:fitnesss_app/widgets/toasts.dart';
import 'package:flutter/material.dart';

import '../../../values/constants.dart';
import '../../../values/my_colors.dart';
import '../../../widgets/app_bar_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/custom_button.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: HelpingWidgets().appBarWidget(() {
        Get.back();
      }, text: "All Users"),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(Constants.customers)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    padding: EdgeInsets.all(20.h),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot doc = snapshot.data!.docs[index];
                      return doc[Constants.type]==Constants.admin?const SizedBox():Row(children: [
                        Container(
                          height: 32.h,
                          width: 32.h,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.black),
                          child: Image.asset(
                            MyImgs.userIcon,
                            scale: 4,
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doc["fullName"],
                              style: textTheme.bodyMedium!.copyWith(
                                  color: MyColors.textColor,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              doc["subscriptionDuration"],
                              style: textTheme.bodySmall!.copyWith(
                                  color: MyColors.textColor,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.find<AuthController>()
                                    .dateExtendController
                                    .text = doc["subscriptionDuration"];
                                Get.to(() => EditUser(
                                      userModel: UserModel.fromJson(
                                          doc.data() as Map<String, dynamic>),
                                    ));
                              },
                              child: Container(
                                height: 32.h,
                                width: 32.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffEBEBEB)),
                                child: const Icon(Icons.edit),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.defaultDialog(
                                    title: "Alert",
                                    content: const Text(
                                        "Do you really want to delete that user"),
                                    onConfirm: () async {
                                      Get.back();

                                      Get.find<AuthController>()
                                          .deleteUser(doc[Constants.userId]);
                                    },
                                    onCancel: () async {});
                              },
                              child: Container(
                                height: 32.h,
                                width: 32.h,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xffFFDAD3)),
                                child: Icon(Icons.delete),
                              ),
                            ),
                          ],
                        ),
                      ]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 20.h,
                      );
                    },
                  ));
                }
                {
                  return const Center(child: Text("No data"));
                }
              }),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
                text: "Add User",
                onPressed: () async {
                  Get.to(() => AddNewUser());
                }),
          ],
        ),
      ),
    );
  }
}
