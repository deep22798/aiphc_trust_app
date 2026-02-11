// import 'dart:async';
// import 'package:aiphc/view/screens/autopay.dart';
// import 'package:get/get.dart';
//
// class AppLinkService {
//   static StreamSubscription? _sub;
//
//   static void init() {
//     _sub = uriLinkStream.listen((Uri? uri) {
//       if (uri == null) return;
//
//       print("APP LINK => $uri");
//
//       if (uri.path == "/autopay/success") {
//         Get.offAll(() => Autopay());
//       }
//
//       if (uri.path == "/autopay/failure") {
//         Get.snackbar("Payment Failed", "Autopay setup failed");
//       }
//     });
//   }
//
//   static void dispose() {
//     _sub?.cancel();
//   }
// }
