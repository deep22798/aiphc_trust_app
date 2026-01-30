import 'package:aiphc/utils/app_theme.dart';
import 'package:aiphc/view/auth/login.dart';
import 'package:aiphc/view/screens/dashboard.dart';
import 'package:aiphc/view/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(ThemeController());

    return Obx(() => GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme.themeMode,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashPage()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/dashboard', page: () => Dashboard()),
      ],
    ));
  }
}
