import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnesss_app/data/models/measurement_model/measurement_model.dart';
import 'package:flutter/material.dart';

import '../../../values/constants.dart';
import '../../../values/my_colors.dart';
import '../../../widgets/app_bar_widget.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllWeeklyReport extends StatelessWidget {
  const AllWeeklyReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: HelpingWidgets().appBarWidget(() {
        Get.back();
      }, text: "All Weekly Reports"),
      body: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(Constants.weeklyReports)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                      child: ListView.separated(

                        padding: EdgeInsets.all(20),
                        itemBuilder: (BuildContext context, int index) {
                          var measure=MeasurementModel.fromJson(snapshot.data!.docs[index].data());

                          return Container(
                            padding: EdgeInsets.all(20.h),
                            decoration: BoxDecoration(
                                color: MyColors.appBackground,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black.withOpacity(0.6))
                            ),
                            child: Column(children: [
                              reportRow("Name", "${measure.firstName} ${measure.lastName}", context),
                              reportRow("Starting Date", measure.firstDate, context),
                              reportRow("End Date", measure.currentDate, context),
                              reportRow("1st Day Weight", measure.firstWeight, context),
                              reportRow("Current Day Weight", measure.currentWeight, context),
                              reportRow("Waist", measure.waist, context),
                              reportRow("Shoulder", measure.shoulder, context),
                              reportRow("Arms", measure.arms, context),
                              reportRow("Chest", measure.chest, context),
                              reportRow("Abdomen", measure.abdomnen, context),
                              reportRow("Hips", measure.hips, context),
                              reportRow("Thighs", measure.thighs , context),


                            ]),
                          );
                        },
                        itemCount: snapshot.data!.docs.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(
                            height: 20.h,
                          );
                        },
                      ));
                }
               else {
                  return const Center(child: Text("No Weekly Reports"));
                }
              }),

        ],
      ),
    );
  }
  Widget reportRow(String text1,String text2,context){
    var textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text1,
              style: textTheme.bodyMedium!
                  .copyWith(color: MyColors.textColor.withOpacity(0.6),fontWeight: FontWeight.w400),
            ),
            Text(
              text2,
              style: textTheme.bodySmall
              !
                  .copyWith(color: MyColors.textColor,fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 5.h,)
      ],
    );
  }
}
