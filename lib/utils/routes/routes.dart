// The Flutter code developed by Kuldeep Singh is protected under copyright law. No individual or entity is permitted to copy, distribute, or use this code in any form without explicit permission from Kuldeep Singh. Unauthorized use, duplication, or modification of this code is strictly prohibited. Any violation of these terms will be subject to legal action, and Kuldeep Singh reserves the right to take appropriate legal measures against any individual or organization found infringing upon these rights. This Flutter code is copyrighted by Kuldeep Singh.

import 'package:aiphc/view/auth/login.dart';
import 'package:aiphc/view/screens/dashboard.dart';
import 'package:aiphc/view/screens/emergencyuserslist.dart';
import 'package:aiphc/view/screens/onboarding_view.dart';
import 'package:aiphc/view/screens/splash.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/splash';
  static String onboarding = '/onboarding';
  static String login = '/login';
  static String dashboard = '/dashboard';
  static const emergencyList = '/emergency-list';
}


final getPages = [
  GetPage(
    name: Routes.emergencyList,
    page: () => const EmergencyListScreen(),
  ),

  GetPage(name: Routes.splash, page: () => const SplashPage()),
  GetPage(name: Routes.login, page: () => const LoginPage()),
  GetPage(name: Routes.dashboard, page: () => Dashboard()),
  GetPage(name: Routes.onboarding, page: () => OnboardingView()),
];


// The Flutter code developed by Kuldeep Singh is protected under copyright law. No individual or entity is permitted to copy, distribute, or use this code in any form without explicit permission from Kuldeep Singh. Unauthorized use, duplication, or modification of this code is strictly prohibited. Any violation of these terms will be subject to legal action, and Kuldeep Singh reserves the right to take appropriate legal measures against any individual or organization found infringing upon these rights. This Flutter code is copyrighted by Kuldeep Singh.
