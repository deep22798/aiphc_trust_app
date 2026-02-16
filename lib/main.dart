import 'dart:async';
import 'dart:convert';

import 'package:aiphc/controllers/screens/dashboardcontroller.dart';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'utils/app_theme.dart';
import 'utils/initialbinding.dart';
import 'utils/routes/routes.dart';
import 'controllers/theme/theme_controller.dart';

/// 🔔 Local notifications plugin (GLOBAL)
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// 🔔 Android notification channel (REQUIRED for Android 8+)
const AndroidNotificationChannel notificationChannel =
AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'Used for important notifications',
  importance: Importance.max,
);

/// 🔔 Firebase background message handler
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  debugPrint('🔕 Background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Firebase initialization
  if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.android,
    );
  } else if (GetPlatform.isIOS) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.ios,
    );
  } else {
    return;
  }

  /// 🔔 Register background handler
  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  /// 🔔 Initialize local notifications (v20+ API)
  const AndroidInitializationSettings androidInit =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
  InitializationSettings(android: androidInit);

  await flutterLocalNotificationsPlugin.initialize(
    settings: initSettings,
    // onDidReceiveNotificationResponse: (NotificationResponse response) {
    //   /// 🔔 Notification tap handling
    //   Get.toNamed(Routes.dashboard);
    // },
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        final data = jsonDecode(response.payload!);

        if (data['type'] == 'emergency') {
          Get.toNamed(Routes.emergencyList);
          return;
        }
      }

      Get.toNamed(Routes.dashboard);
    },

  );

  /// 🔔 Create Android notification channel
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(notificationChannel);

  /// 🔔 Android 13+ notification permission
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  /// 🔔 Status bar styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;

  // void _handleNotificationNavigation(RemoteMessage message) {
  //   final data = message.data;
  //
  //   if (data.isEmpty) {
  //     Get.toNamed(Routes.dashboard);
  //     return;
  //   }
  //
  //   if (data['type'] == 'emergency') {
  //     Get.toNamed(Routes.emergencyList);
  //   } else {
  //     Get.toNamed(Routes.dashboard);
  //   }
  // }

  void _openDashboardLiveHelpTab() {
    final DashboardController controller =
    Get.put(DashboardController());

    // Dashboard open karo (clean stack)
    Get.offAllNamed(Routes.dashboard);

    // Thoda delay, phir 2nd tab select
    Future.delayed(const Duration(milliseconds: 300), () {
      controller.changeTab(1); // 👈 Live Help tab
    });
  }


  @override
  void initState() {
    super.initState();

    /// 🔗 Deep links (PhonePe / App Links)
    _linkSub = _appLinks.uriLinkStream.listen((uri) {
      if (uri.path == '/return') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed('/autopay-success');
        });
      }

    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _handleNotificationNavigation(message);
          _openDashboardLiveHelpTab();
        });
      }
    });

    /// 🔔 FOREGROUND notification handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      if (notification != null && android != null) {
        final int notificationId =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;

        flutterLocalNotificationsPlugin.show(
          id: notificationId,
          title: notification.title,
          body: notification.body,
          payload: jsonEncode(message.data),
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              notificationChannel.id,
              notificationChannel.name,
              channelDescription: notificationChannel.description,
              importance: Importance.max,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });

    /// 🔔 App opened from notification (background)
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   Get.toNamed(Routes.dashboard);
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // _handleNotificationNavigation(message);
      _openDashboardLiveHelpTab();
    });


    /// 🔔 FCM token (use this for backend testing)
    FirebaseMessaging.instance.getToken().then((token) {
      debugPrint('🔥 FCM TOKEN: $token');
    });

    /// 🔔 Topic subscription
    FirebaseMessaging.instance.subscribeToTopic('all');
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());

    return Obx(
          () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialBinding: InitialBinding(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeController.themeMode,
        initialRoute: Routes.splash,
        // initialRoute: Routes.dashboard,
        getPages: getPages,
      ),
    );
  }
}













// import 'package:aiphc/controllers/auth/login.dart';
// import 'package:aiphc/controllers/globalcontroller.dart';
// import 'package:aiphc/controllers/phonepaycontroller.dart';
// import 'package:aiphc/controllers/screens/bannercontroller.dart';
// import 'package:aiphc/controllers/screens/gallery.dart';
// import 'package:aiphc/controllers/screens/memberscontroller.dart';
// import 'package:aiphc/controllers/screens/process_rules.dart';
// import 'package:aiphc/controllers/sharedprefres.dart';
// import 'package:aiphc/firebase_options.dart';
// import 'package:aiphc/utils/app_theme.dart';
// import 'package:aiphc/utils/applink.dart';
// import 'package:aiphc/utils/initialbinding.dart';
// import 'package:aiphc/utils/routes/routes.dart';
// import 'package:aiphc/view/auth/login.dart';
// import 'package:aiphc/view/screens/autopay.dart';
// import 'package:aiphc/view/screens/dashboard.dart';
// import 'package:aiphc/view/screens/splash.dart';
// import 'package:app_links/app_links.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'controllers/theme/theme_controller.dart';
// import 'dart:async';
//
//
//
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp();
// //
// //   // FlutterError.onError = (FlutterErrorDetails details) {
// //   //   FlutterError.presentError(details);
// //   //   debugPrint("FlutterError: ${details.exception}");
// //   // };
// //
// //   runApp(MyApp()); // ✅ THIS WAS MISSING
// // }
//
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
// FlutterLocalNotificationsPlugin();
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   print('Handling a background message: ${message.messageId}');
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Firebase based on platform
//   if (GetPlatform.isAndroid) {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.android,
//     );
//   } else if (GetPlatform.isIOS) {
//     await Firebase.initializeApp(
//       options: DefaultFirebaseOptions.ios,
//     );
//   }
//   // else if (GetPlatform.isWeb) {
//   //   await Firebase.initializeApp(
//   //     options: DefaultFirebaseOptions.web,
//   //   );
//   // }
//   else {
//     return;
//   }
//
//   // Setup background message handler
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//
//   // Set system overlay style
//   SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//     statusBarColor: Colors.transparent,
//     statusBarIconBrightness: Brightness.dark,
//   ));
//   const AndroidInitializationSettings initializationSettingsAndroid =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   const InitializationSettings initializationSettings =
//   InitializationSettings(android: initializationSettingsAndroid);
//
//   await flutterLocalNotificationsPlugin.initialize(settings:initializationSettings );
//
//   runApp(MyApp());
// }
//
//
//
// class MyApp extends StatefulWidget {
//   MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   final AppLinks _appLinks = AppLinks();
//
//   StreamSubscription<Uri>? _sub;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _sub = _appLinks.uriLinkStream.listen((uri) {
//       if (uri.path == '/return') {
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           Get.offAllNamed('/autopay-success');
//         });
//       }
//     });
//
//
//     // Request permission for notifications
//     FirebaseMessaging.instance.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     ).then((settings) {
//       print('User granted permission: ${settings.authorizationStatus}');
//     });
//
//     // Listen to foreground messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print('Got a message whilst in the foreground!');
//       print('Message data: ${message.data}');
//
//       if (message.notification != null) {
//         print('Message also contained a notification: ${message.notification}');
//
//
//       }
//     });
//
//     // Handle when the app is opened via notification
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       // You can handle the logic for opening a specific screen here
//     });
//
//     // Get the FCM token and print it
//     FirebaseMessaging.instance.getToken().then((String? token) {
//       assert(token != null);
//       print("FCM Token: $token");
//     });
//
//     // Subscribe to a topic
//     FirebaseMessaging.instance.subscribeToTopic('all');
//   }
//
//
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Get.put(ThemeController());
//     return Obx(() =>
//         GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialBinding: InitialBinding(),
//       theme: AppTheme.light,
//       darkTheme: AppTheme.dark,
//       themeMode: theme.themeMode,
//       // initialRoute:Butttuon(key: key,),
//       initialRoute: Routes.splash,
//       // home: MerchantApp(),
//       // home: ButtonPage(),
//       getPages: getPages,
//     )
//     );
//
//   }
// }
//
//
//
//
//
//
//
// // import 'package:aiphc/controllers/auth/login.dart';
// // import 'package:aiphc/controllers/globalcontroller.dart';
// // import 'package:aiphc/controllers/screens/bannercontroller.dart';
// // import 'package:aiphc/controllers/screens/gallery.dart';
// // import 'package:aiphc/controllers/screens/memberscontroller.dart';
// // import 'package:aiphc/controllers/screens/process_rules.dart';
// // import 'package:aiphc/controllers/sharedprefres.dart';
// // import 'package:aiphc/utils/app_theme.dart';
// // import 'package:aiphc/utils/routes/routes.dart';
// // import 'package:aiphc/view/auth/login.dart';
// // import 'package:aiphc/view/screens/dashboard.dart';
// // import 'package:aiphc/view/screens/splash.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'controllers/theme/theme_controller.dart';
// //
// // void main() {
// //   runApp(MyApp());
// // }
// //
// // class MyApp extends StatelessWidget {
// //   MyApp({super.key});
// //
// //   final SharedprefresController sharedprefresController = Get.put(SharedprefresController());
// //   final AuthController authController = Get.put(AuthController());
// //   final Bannerscontroller bannerscontroller = Get.put(Bannerscontroller());
// //   final MembersController membersController = Get.put(MembersController());
// //   final ProcessController processController = Get.put(ProcessController());
// //   final GalleryController galleryController = Get.put(GalleryController());
// //   final Globalcontroller global = Get.put(Globalcontroller());
// //   @override
// //   Widget build(BuildContext context) {
// //     final theme = Get.put(ThemeController());
// //     return Obx(() => GetMaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       theme: AppTheme.light,
// //       darkTheme: AppTheme.dark,
// //       themeMode: theme.themeMode,
// //       initialRoute: Routes.splash,
// //       getPages: getPages
// //     ));
// //   }
// // }
