import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recyclens_app/controllers/drawer_controller.dart';
import 'package:recyclens_app/controllers/home_bottombar_controller.dart';
import 'package:recyclens_app/pages/auth/sign_in.dart';
import 'package:recyclens_app/pages/home/drawer.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Fully transparent status bar
      //statusBarIconBrightness: Brightness.dark, // or Brightness.light
    ),
  );

  Get.put<MyDrawerController>(MyDrawerController());
  Get.put<HomeBottombarController>(HomeBottombarController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Recyclens',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignInPage(),
      builder: EasyLoading.init(),
    );
  }
}
