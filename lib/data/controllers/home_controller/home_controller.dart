import 'dart:typed_data';

import 'package:agora_token_service/agora_token_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../values/constants.dart';
import '../../../widgets/toasts.dart';
import '../../GetServices/CheckConnectionService.dart';
import '../../models/measurement_model/measurement_model.dart';

class HomeController extends GetxController implements GetxService {
  SharedPreferences sharedPreferences;

  HomeController({required this.sharedPreferences});
  CheckConnectionService connectionService = CheckConnectionService();

  ///Firebase variables
  var auth = FirebaseAuth.instance;
  var database = FirebaseFirestore.instance;

  ///Agora token
  String? generatedToken;

  ///Measurement controllers Weekly
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController firstDay = TextEditingController();
  TextEditingController currentDate = TextEditingController();
  TextEditingController firstWeight = TextEditingController();
  TextEditingController currentWeight = TextEditingController();
  TextEditingController waist = TextEditingController();
  TextEditingController hips = TextEditingController();
  TextEditingController shoulder = TextEditingController();
  TextEditingController arms = TextEditingController();
  TextEditingController chest = TextEditingController();
  TextEditingController abdonmen = TextEditingController();
  TextEditingController thighs = TextEditingController();

  /// call screen variabls
  var muteAudio = false.obs;
  var muteVideo = false.obs;

  ///My Weekly Report Function

  updateMyWeeklyReport() async {
    await connectionService.checkConnection().then((value) async {
      if (!value) {
        CustomToast.noInternetToast();
      } else {
        Get.dialog(const Center(
          child: CircularProgressIndicator(),
        ));
        await database
            .collection(Constants.weeklyReports)
            .add(MeasurementModel(
                    firstName: firstName.text,
                    userId: sharedPreferences.getString(Constants.userId)!,
                    lastName: lastName.text,
                    firstDate: firstDay.text,
                    currentDate: currentDate.text,
                    firstWeight: firstWeight.text,
                    currentWeight: currentWeight.text,
                    waist: waist.text,
                    hips: hips.text,
                    shoulder: shoulder.text,
                    arms: arms.text,
                    chest: chest.text,
                    abdomnen: abdonmen.text,
                    thighs: thighs.text)
                .toJson())
            .then((value) {
          Get.back();
          CustomToast.successToast(msg: "User updated successfully");

          Share.share(
              "Name:  ${firstName.text} ${lastName.text}\n1st Day Date:  ${firstDay.text}\nCurrent Day Date:  ${currentDate.text}\n1st Day Weight:  ${firstWeight.text}\nCurrent Weight:  ${currentWeight.text}\nWaist:  ${waist.text}\nHips:  ${hips.text}\nShoulder:  ${shoulder.text}\nArms:  ${arms.text}\nChest:  ${chest.text}\nAbdomnen:  ${abdonmen.text}\nThighs:  ${thighs.text}");
          clearTextController();
        }).onError((error, stackTrace) {
          CustomToast.failToast(msg: "Something went wrong");
        });
      }
    });
  }

  clearTextController() {
    firstName.clear();
    lastName.clear();
    firstDay.clear();
    currentDate.clear();
    firstWeight.clear();
    currentWeight.clear();
    currentDate.clear();
    waist.clear();
    shoulder.clear();
    hips.clear();
    arms.clear();
    chest.clear();
    abdonmen.clear();
    thighs.clear();
  }

  Future<String?> getAgoraToken(String channelName) async {
    const expirationInSeconds = 84600;
    final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final expireTimestamp = currentTimestamp + expirationInSeconds;
    final token = RtcTokenBuilder.build(
      appId: Constants.appID,
      appCertificate: "71a1aa7106d9447ba8e10ffcee0a2545",
      channelName: channelName,
      uid: "0",
      role: RtcRole.publisher,
      expireTimestamp: expireTimestamp,
    );
    generatedToken = token;
    print("token    $token");
    update();
    return token;
  }

  Future<void> uploadFramesToFirebase(frames) async {
    // Convert RawFrame instances to bytes (this is just an example)
    Uint8List? byteData;
    if (frames==null) {
      print("frames nulll ");
    } else {
      List bytes = frames.map((frame) {
        // Assuming frame is a RawFrame with an Image property
        byteData = frame.image.buffer.asUint8List();
        return byteData!.toList();
      }).toList();
    }

    // Upload bytes to Firebase Storage
    await uploadBytesToFirebaseStorage(byteData!);
  }

  Future<void> uploadBytesToFirebaseStorage(Uint8List bytes) async {
    // Use Firebase Storage to upload bytes
    // Replace 'yourStorageReference' with the appropriate reference in your Firebase Storage
    // This might be something like "gs://your-project-id.appspot.com/path/to/file"
    // or a reference obtained from Firebase Storage API
    // Make sure to check the Firebase Storage documentation for your specific setup
    final storageReference = FirebaseStorage.instance.ref('videos');

    // Create a reference to the file you want to upload
    final fileReference = storageReference.child('firstVideo');

    // Upload the file to Firebase Storage
    await fileReference.putData(bytes);

    print('File uploaded to Firebase Storage!');
  }
}
