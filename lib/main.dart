import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:itzon_task/screens/homepage/homepage.dart';
import 'package:itzon_task/screens/splashpage/splash.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'controller/dark_mode_controller.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("themeData");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(DarkModeController());
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'IT Zon',
          theme: ThemeData(
            brightness:
                controller.isDark.value ? Brightness.dark : Brightness.light,
            primarySwatch: Colors.blue,
          ),
          home: const HomePage(),
          getPages: [
            GetPage(name: "/homepage", page: () => const HomePage()),
            GetPage(
              name: "/splashScreen",
              page: () => const SplashScreen(),
            )
          ],
          initialRoute: "/splashScreen",
        ));
  }
}
