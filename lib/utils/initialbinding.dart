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
    Get.put(Globalcontroller() );
    Get.put(Bannerscontroller() );
    Get.put(MembersController() );
    Get.put(ProcessController() );
    Get.put(GalleryController() );
    Get.put(PaymentsController() );
    // Get.lazyPut(() => Bannerscontroller());
    // Get.lazyPut(() => MembersController());
    // Get.lazyPut(() => ProcessController());
    // Get.lazyPut(() => GalleryController());
    // Get.lazyPut(() => PaymentsController());
    // Get.put(PhonePeController(), );
  }
}
