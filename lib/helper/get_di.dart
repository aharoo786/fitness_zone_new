
import 'package:fitnesss_app/data/controllers/auth_controller/auth_controller.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future init() async {
  Get.log("int di");
  final sharedPreferences = await SharedPreferences.getInstance();
   Get.lazyPut(() => sharedPreferences);
   Get.lazyPut(() => AuthController(sharedPreferences: sharedPreferences));
   Get.lazyPut(() => HomeController(sharedPreferences: sharedPreferences));
  // Get.lazyPut(() => AuthController(sharedPreferences:sharedPreferences));


}
