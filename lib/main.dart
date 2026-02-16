import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
import 'package:aiphc/controllers/screens/bannercontroller.dart';
import 'package:aiphc/controllers/screens/gallery.dart';
import 'package:aiphc/controllers/screens/memberscontroller.dart';
import 'package:aiphc/controllers/screens/process_rules.dart';
import 'package:aiphc/controllers/sharedprefres.dart';
import 'package:aiphc/utils/app_theme.dart';
import 'package:aiphc/utils/applink.dart';
import 'package:aiphc/utils/initialbinding.dart';
import 'package:aiphc/utils/routes/routes.dart';
import 'package:aiphc/view/auth/login.dart';
import 'package:aiphc/view/screens/autopay.dart';
import 'package:aiphc/view/screens/dashboard.dart';
import 'package:aiphc/view/screens/splash.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/theme/theme_controller.dart';
import 'dart:async';


void main() {WidgetsFlutterBinding.ensureInitialized();
  // Global error handling for release mode
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Optionally log errors to server
    print("FlutterError: ${details.exception}");
  };

  runZonedGuarded(() {

    runApp(MyApp());
  }, (error, stackTrace) {
    print("Uncaught error: $error");
    // Optionally send error logs to server here
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();

  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();

    _sub =_appLinks.uriLinkStream.listen((uri) {
      if (uri.path == '/return') {
        Get.offAllNamed('/autopay-success');
      }
    });

  }

  //
  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(ThemeController());
    return Obx(() =>
        GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: theme.themeMode,
      // initialRoute:Butttuon(key: key,),
      initialRoute: Routes.splash,
      // home: MerchantApp(),
      // home: ButtonPage(),
      getPages: getPages,
    )
    );


  }
}







// import 'package:aiphc/controllers/auth/login.dart';
// import 'package:aiphc/controllers/globalcontroller.dart';
// import 'package:aiphc/controllers/screens/bannercontroller.dart';
// import 'package:aiphc/controllers/screens/gallery.dart';
// import 'package:aiphc/controllers/screens/memberscontroller.dart';
// import 'package:aiphc/controllers/screens/process_rules.dart';
// import 'package:aiphc/controllers/sharedprefres.dart';
// import 'package:aiphc/utils/app_theme.dart';
// import 'package:aiphc/utils/routes/routes.dart';
// import 'package:aiphc/view/auth/login.dart';
// import 'package:aiphc/view/screens/dashboard.dart';
// import 'package:aiphc/view/screens/splash.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'controllers/theme/theme_controller.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   MyApp({super.key});
//
//   final SharedprefresController sharedprefresController = Get.put(SharedprefresController());
//   final AuthController authController = Get.put(AuthController());
//   final Bannerscontroller bannerscontroller = Get.put(Bannerscontroller());
//   final MembersController membersController = Get.put(MembersController());
//   final ProcessController processController = Get.put(ProcessController());
//   final GalleryController galleryController = Get.put(GalleryController());
//   final Globalcontroller global = Get.put(Globalcontroller());
//   @override
//   Widget build(BuildContext context) {
//     final theme = Get.put(ThemeController());
//     return Obx(() => GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: AppTheme.light,
//       darkTheme: AppTheme.dark,
//       themeMode: theme.themeMode,
//       initialRoute: Routes.splash,
//       getPages: getPages
//     ));
//   }
// }
