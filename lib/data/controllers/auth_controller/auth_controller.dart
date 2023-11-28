import 'package:fitnesss_app/UI/auth_module/walt_through/walk_through_screenn.dart';
import 'package:fitnesss_app/UI/dashboard_module/bottom_bar_screen/bottom_bar_screen.dart';
import 'package:fitnesss_app/UI/dashboard_module/home_screen/home_screen.dart';
import 'package:fitnesss_app/data/models/user_model/user_model.dart';
import 'package:fitnesss_app/values/constants.dart';
import 'package:fitnesss_app/widgets/toasts.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../GetServices/CheckConnectionService.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AuthController extends GetxController implements GetxService {
  SharedPreferences sharedPreferences;
  CheckConnectionService connectionService = CheckConnectionService();
  AuthController({required this.sharedPreferences});

  ///Firebase variables
  var auth = FirebaseAuth.instance;
  var database = FirebaseFirestore.instance;

  ///Generating unique id
  var uuid = const Uuid();

  ///TextEditing Controller for Adding User
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ///countryCode
  var countryCode = Constants.countryCode;
  final List<String> users = [
    'Admin',
    'Host',
    'User',
  ];

  ///Sign in User
  TextEditingController loginUserPhone = TextEditingController();
  TextEditingController loginUserPassword = TextEditingController();

  ///Update user
  TextEditingController dateExtendController = TextEditingController();

  String daysDurationValue = "";
  String monthDurationValue = "";

  bool daysSelected = false;
  bool monthSelected = false;

  ///User Model
  UserModel? logInUser;

  List<String> durationList = [
    "None",
    "1 day",
    "2 days",
    "3 days",
    "4 days",
    "5 days",
    "6 days",
    "7 days",
    "8 days",
    "9 days",
    "10 days",
    "11 days",
    "12 days",
    "13 days",
    "14 days",
    "14 days",
    "16 days",
    "17 days",
    "18 days",
    "19 days",
    "20 days",
    "21 days",
    "21 days",
    "22 days",
    "23 days",
    "24 days",
    "25 days",
    "26 days",
    "27 days",
    "28 days",
    "29 days",
  ];
  List<String> durationListMonths = [
    "None",
    "1 month",
    "2 months",
    "3 months",
    "4 months",
    "5 months",
    "6 months",
    "7 months",
    "8 months",
    "9 months",
    "10 months",
    "11 months",
    "12 months",
  ];
  var loginAsA = Constants.user.obs;

  List<String> packageState = [
    "Start",
    "Pause",
  ];
  List<String> screenShot = [
    "Yes",
    "No",
  ];
  List<String> recording = [
    "Yes",
    "No",
  ];
  List<String> memberDesignation = [
    "Trainer",
    "Dietitian",
  ];

  var memerDesig = "Trainer";

  List<XFile> mealImages = [];
  int i = 0;

  /// getting days function
  int gettingDays() {
    if (daysSelected) {
      return int.parse(daysDurationValue.split(" ").first);
    } else {
      return int.parse(monthDurationValue.split(" ").first) * 30;
    }
  }

  ///Admin adding user
  addingUserToFireStore(bool isMember) async {
    var userId = uuid.v1();
    await connectionService.checkConnection().then((value) async {
      if (!value) {
        CustomToast.noInternetToast();
      } else {
        Get.dialog(const Center(
          child: CircularProgressIndicator(),
        ));

        bool isUserExist = await userExist(phoneNumberController.text);
        if (isUserExist) {
          Get.back();
          CustomToast.failToast(msg: "User already exist");
        } else {
          await database
              .collection(Constants.customers)
              .doc(userId)
              .set(UserModel(
                      fullName: fullNameController.text,
                      packageStatus: "start",
                      password: passwordController.text,
                      recording: isMember,
                      screenShot: isMember,
                      subscriptionDuration:
                          daysSelected ? daysDurationValue : monthDurationValue,
                      type: isMember ? "Host" : "User",
                      userCountryCode: countryCode,
                      userId: userId,
                      userMobileNumber: phoneNumberController.text,
                      memberDesignation: isMember ? memerDesig : "",
                      startDate:
                          isMember ? "" : DateTime.now().toIso8601String(),
                      expireDate: isMember
                          ? ""
                          : DateTime.now()
                              .add(Duration(days: gettingDays()))
                              .toIso8601String())
                  .toJson())
              .then((value) async {
            Get.back();
            CustomToast.successToast(msg: "User added successfully");
            passwordController.clear();
            fullNameController.clear();
            phoneNumberController.clear();
            daysSelected = false;
            monthSelected = false;
          }).onError((error, stackTrace) {
            CustomToast.failToast(msg: "Something went wrong");
          });
        }
      }
    });
  }

  deleteUser(String userId) async {
    await connectionService.checkConnection().then((value) async {
      if (!value) {
        CustomToast.noInternetToast();
      } else {
        Get.dialog(const Center(
          child: CircularProgressIndicator(),
        ));
        await database
            .collection(Constants.customers)
            .doc(userId)
            .delete()
            .then((value) {
          Get.back();
          CustomToast.successToast(msg: "User deleted successfully");
        }).onError((error, stackTrace) {
          CustomToast.failToast(msg: "Something went wrong");
        });
      }
    });
  }

  updateUser(UserModel userModel) async {
    await connectionService.checkConnection().then((value) async {
      if (!value) {
        CustomToast.noInternetToast();
      } else {
        Get.dialog(const Center(
          child: CircularProgressIndicator(),
        ));
        await database
            .collection(Constants.customers)
            .doc(userModel.userId)
            .update(userModel.toJson())
            .then((value) {
          Get.back();
          CustomToast.successToast(msg: "User updated successfully");
        }).onError((error, stackTrace) {
          CustomToast.failToast(msg: "Something went wrong");
        });
      }
    });
  }

  Future<bool> userExist(String phone) async {
    bool isUserExist = false;
    QuerySnapshot users = await database.collection(Constants.customers).get();
    for (var user in users.docs) {
      if (user[Constants.userMobileNumber] == phone) {
        isUserExist = true;
        break;
      }
    }
    return isUserExist;
  }

  Future<List> userExistWithPassword(String phone, String password) async {
    List list = [null, false];
    QuerySnapshot users = await database.collection(Constants.customers).get();
    for (var user in users.docs) {
      Get.log("${user.data()}");
      if (user[Constants.userMobileNumber] == phone &&
          user[Constants.password] == password &&
          user[Constants.type] == loginAsA.value) {
        if (user[Constants.type] == Constants.user) {
          if (DateTime.now().isAfter(DateTime.parse(user["expireDate"]))) {
            list[1] = true;
            list[0] = UserModel.fromJson(user.data() as Map<String, dynamic>);
          } else {
            list[0] = UserModel.fromJson(user.data() as Map<String, dynamic>);
          }
        } else {
          list[0] = UserModel.fromJson(user.data() as Map<String, dynamic>);
        }
        break;
      }
    }
    return list;
  }

  Future<UserModel?> gettingUserById(String id) async {
    UserModel? userModel;
    Get.log("id $id");
    await database.collection(Constants.customers).doc(id).get().then((value) {
      Get.log("id ${value.data()}");
      if (value.data() == null) {
        userModel = null;
      } else {
        print("Else");
        userModel = UserModel.fromJson(value.data()!);
      }
    }).onError((error, stackTrace) {
      userModel = null;
    });

    return userModel;
  }

  sessionCheck() async {
    await connectionService.checkConnection().then((value) async {
      if (!value) {
        CustomToast.noInternetToast();
      } else {
        logInUser = await gettingUserById(
            sharedPreferences.getString(Constants.userId) ?? "");
        if (logInUser == null) {
          sharedPreferences.clear();
          Get.to(() => const WalkThroughScreen());
          CustomToast.failToast(msg: "Session Expire");
        } else {
          sharedPreferences.setBool(Constants.login, true);
          sharedPreferences.setString(Constants.userId, logInUser!.userId);
          loginAsA.value = logInUser!.type;
          Get.offAll(() => BottomBarScreen());
          //   CustomToast.successToast(msg: "Login Successfully");
        }
      }
    });
  }

  loginUser() async {
    await connectionService.checkConnection().then((value) async {
      if (!value) {
        CustomToast.noInternetToast();
      } else {
        Get.dialog(const Center(
          child: CircularProgressIndicator(),
        ));

        var list = await userExistWithPassword(
            loginUserPhone.text, loginUserPassword.text);
        logInUser = list[0];
        if (logInUser == null) {
          Get.back();
          CustomToast.failToast(msg: "Invalid Credentials");
        } else if (list[1]) {
          Get.back();
          CustomToast.failToast(msg: "Your package has been expire");
        } else {
          sharedPreferences.setBool(Constants.login, true);
          sharedPreferences.setBool(Constants.isGuest, false);
          sharedPreferences.setString(Constants.userId, logInUser!.userId);
          loginAsA.value = logInUser!.type;
          Get.offAll(() => BottomBarScreen());
          CustomToast.successToast(msg: "Login Successfully");
        }
      }
    });
  }
}
