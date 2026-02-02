import 'package:aiphc/controllers/sharedprefres.dart';
import 'package:aiphc/model/auth/adminresmodel.dart';
import 'package:aiphc/model/auth/usermodel.dart';
import 'package:aiphc/utils/routes/routes.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData; // adjust path if needed

class AuthController extends GetxController {


  final SharedprefresController sharedprefresController = Get.find<SharedprefresController>();
  var enablerole=0.obs;
  // var islogin=0.obs;
// 1 for admin and 2 for users

  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    ),
  );

  var isLoading = false.obs;
  final Rxn<AdminModel> adminData = Rxn<AdminModel>();
  final Rxn<UserModel> usermodel = Rxn<UserModel>();

  Future<void> adminLogin({required String username, required String password,}) async
  {
    try {
      isLoading.value = true;
      print("LOGIN RESPONSE ::: $username");
      print("LOGIN RESPONSE ::: $password");
      final formData = FormData.fromMap({
        'username': username,
        'password': password,
      });
      final response = await _dio.post(
        ServerConstants.adminLogin,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          responseType: ResponseType.json,
        ),
      );
      final data = response.data;
      print("LOGIN RESPONSE ::: $data");
      if (data['status'] == true) {
       await sharedprefresController.saveusernamepassword(username.toString(), password.toString());
       adminData.value = AdminModel.fromJson(data['data']);
        enablerole.value=1;
       print("jbjdshvfdsvfdj ${enablerole.value.toString()}:::::::::::: ${sharedprefresController.uusername.value.toString()}::::::::::${sharedprefresController.upassword.value.toString()}");
       // print("ADMIN::::::::::: ${adminData.value?.name.toString()}:::::::\n${adminData.value?.username.toString()}");
       Get.offAllNamed(Routes.dashboard);
        Get.snackbar(
          'Success',
          data['message'] ?? 'Login successful',
            snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.green,colorText: Colors.white
        );
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,colorText: Colors.white,backgroundColor: Colors.red
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.response?.data['message'] ?? 'Server not responding',
        snackPosition: SnackPosition.BOTTOM,colorText: Colors.white,backgroundColor: Colors.red
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> userLogin({required String aadhar, required String password,}) async
  {
    try {
      isLoading.value = true;
      print("LOGIN RESPONSE ::: $aadhar");
      print("LOGIN RESPONSE ::: $password");
      final formData = FormData.fromMap({
        'aadhar': aadhar,
        'password': password,
      });
      final response = await _dio.post(
        ServerConstants.userLogin,
        data: formData,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          responseType: ResponseType.json,
        ),
      );
      final data = response.data;
      print("LOGIN RESPONSE ::: $data");
      if (data['status'] == true) {
       await sharedprefresController.saveusernamepassword(aadhar.toString(), password.toString());
        usermodel.value = UserModel.fromJson(data['data']);
       enablerole.value=2;
        print("ADMIN::::::::::: ${usermodel.value?.name.toString()}:::::::\n${usermodel.value?.userPhoto.toString()}");
        print("jbjdshvfdsvfdj ${enablerole.value.toString()}:::::::::::: ${sharedprefresController.uusername.value.toString()}::::::::::${sharedprefresController.upassword.value.toString()}");
       Get.offAllNamed(Routes.dashboard);
        Get.snackbar(
          'Success',
          data['message'] ?? 'Login successful',
          snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.green,colorText: Colors.white
        );
      } else {
        Get.snackbar(
          'Error',
          data['message'] ?? 'Invalid credentials',
          snackPosition: SnackPosition.BOTTOM,colorText: Colors.white,backgroundColor: Colors.red
        );
      }
    } on DioException catch (e) {
      Get.snackbar(
        'Login Failed',
        e.response?.data['message'] ?? 'Server not responding',
        snackPosition: SnackPosition.BOTTOM,colorText: Colors.white,backgroundColor: Colors.red
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void>logout()async{
    await sharedprefresController.deleteshared();
    enablerole.value=0;
    Get.offAllNamed(Routes.login);
  }
}



