import 'package:fitnesss_app/UI/dashboard_module/session_screen/session_screen.dart';
import 'package:fitnesss_app/data/controllers/home_controller/home_controller.dart';
import 'package:fitnesss_app/values/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:uni_links/uni_links.dart';

import '/helper/get_di.dart' as di;
import 'UI/auth_module/splash.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await di.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // @override;
  MyApp();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    initUniLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return GetBuilder<LocalizationController>(builder: (localizeController) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      builder: (context, Widget) => GetMaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,

        theme: Styles.appTheme,
        getPages: [
          GetPage<void>(page: () => SplashScreen(), name: '/'),
        ],
        // home: BuySubscriptions(),
      ),
    );
    // });
  }
}

Future<void> initUniLinks() async {
  // ... check initialLink

  // Attach a listener to the stream
  linkStream.listen((String? link) {
    if (link != null) {
      print(link);
      Get.find<HomeController>().generatedToken = link.split("/").last;
      Get.to(() => SessionScreen());
    }
    // Parse the link and warn the user, if it is not correct
  }, onError: (err) {
    // Handle exception by warning the user their action did not succeed
  });

  // NOTE: Don't forget to call _sub.cancel() in dispose()
}
