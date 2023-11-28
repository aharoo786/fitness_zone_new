import 'package:fitnesss_app/widgets/CustomText.dart';
import 'package:fitnesss_app/widgets/custom_button.dart';
import 'package:fitnesss_app/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../widgets/app_bar_widget.dart';

class Payment extends StatelessWidget {
  const Payment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HelpingWidgets().appBarWidget(
        () {
          Get.back();
        },
        text: "Payment Detail",
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 20.w, right: 20.w, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              Title: "Card Holder",
            ),
            SizedBox(
              height: 8.h,
            ),
            CustomTextField(
                text: "Name",
                length: 7,
                keyboardType: TextInputType.text,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter),
            SizedBox(
              height: 20,
            ),
            CustomText(
              Title: "Card N0",
            ),
            SizedBox(
              height: 8.h,
            ),
            CustomTextField(
                text: "5476******6789",
                length: 7,
                keyboardType: TextInputType.text,
                inputFormatters:
                    FilteringTextInputFormatter.singleLineFormatter),
            SizedBox(
              height: 20,
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      Title: "Expiry",
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomTextField(
                        text: "04/12/2023",
                        length: 7,
                        width: 185.w,
                        keyboardType: TextInputType.text,
                        inputFormatters:
                            FilteringTextInputFormatter.singleLineFormatter),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      Title: "CVV",
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    CustomTextField(
                        text: "*******",
                        length: 7,
                        width: 185.w,
                        keyboardType: TextInputType.text,
                        inputFormatters:
                            FilteringTextInputFormatter.singleLineFormatter),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 60,
            ),
            CustomButton(text: "Save", onPressed: () {})
          ],
        ),
      ),
    );
  }
}
