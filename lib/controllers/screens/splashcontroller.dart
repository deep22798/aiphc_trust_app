import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/utils/routes/routes.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  AuthController authController =Get.find();


  bool startsWithLetter(String value) {
    if (value.isEmpty) return false;
    return RegExp(r'^[A-Za-z]').hasMatch(value[0]);
  }

  @override
  void onInit(){
    super.onInit();
    Future.delayed(const Duration(seconds: 3), () async{
      final prefs = await SharedPreferences.getInstance();
      var a= prefs.getBool("onboard");
      var u= prefs.getString("username");
      var p= prefs.getString("password");
      await checkForUpdate();
      print("dflklkwefbewfebw ${a.toString()}");
      if(a==true){
        if(u==null||u.toString()==""){
          Get.offAllNamed(Routes.login);
        }else{
          if (startsWithLetter(u)) {
            // 🔹 Call ANOTHER function
            authController.adminLogin(
              username: u.toString(),
              password: p.toString(),
            );
          } else {
            // 🔹 Normal numeric login
            authController.userLogin(
              aadhar: u.toString(),
              password: p.toString(),
            );
          }
        }
      }else{
       Get.offAllNamed(Routes.onboarding);
      }
    });
  }

  Future<void> checkForUpdate() async {
    print("Error during updatescjkjshj:");
    InAppUpdate.checkForUpdate().then((info) {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          print("Error during update: $e");
        });
      }
    }).catchError((e) {
      print("Error checking for update: $e");
    });
  }


}
