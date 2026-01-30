import 'package:get/get.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> login() async {
    isLoading.value = true;

    // simulate API
    await Future.delayed(const Duration(seconds: 2));

    isLoading.value = false;

    Get.offAllNamed('/dashboard');
  }
}
