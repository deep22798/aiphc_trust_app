import 'package:aiphc/controllers/paymentcontroller.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
import 'package:aiphc/controllers/screens/bannercontroller.dart';
import 'package:aiphc/controllers/screens/gallery.dart';
import 'package:aiphc/controllers/screens/memberscontroller.dart';
import 'package:aiphc/controllers/screens/process_rules.dart';
import 'package:get/get.dart';
import '../controllers/auth/login.dart';
import '../controllers/globalcontroller.dart';
import '../controllers/sharedprefres.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // ONLY light & required controllers
    Get.put(SharedprefresController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(Bannerscontroller(), permanent: true);
    Get.put(MembersController(), permanent: true);
    Get.put(ProcessController(), permanent: true);
    Get.put(GalleryController(), permanent: true);
    Get.put(PaymentsController(), permanent: true);
    Get.put(Globalcontroller(), permanent: true);
    // Get.put(PhonePeController(), permanent: true);
  }
}
