import 'dart:io';

import 'package:aiphc/controllers/autopaycontroller.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
import 'package:aiphc/controllers/screens/memberscontroller.dart';
import 'package:aiphc/controllers/sharedprefres.dart';
import 'package:aiphc/model/auth/adminresmodel.dart';
import 'package:aiphc/model/auth/usermodel.dart';
import 'package:aiphc/utils/routes/routes.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart'; // adjust path if needed

class AuthController extends GetxController {


  final SharedprefresController sharedprefresController = Get.find<SharedprefresController>();


  final PhonePeController phonePeAuthController = Get.put(PhonePeController());
  // final AutopayController autopayController = Get.put(AutopayController());
  final MembersController membersController = Get.put(MembersController());


  var enablerole=0.obs;
  // var islogin=0.obs;
// 1 for admin and 2 for users




  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "${ServerConstants.baseUrl}", // 🔴 change
      headers: {
        "Content-Type": "application/json",
      },
    ),
  );

  /// 🔔 update fcm tokenupdateFcmToken
  Future<bool> updateFcmToken(String fcmToken) async {
    try {
      final res = await dio.post(
        "${ServerConstants.updateFcmToken}",
        data: {
          "member_id": usermodel.value?.id.toString()??"",
          "fcm_token": fcmToken,
        },
      );
      print("jbjdsjvbdjkvjkbdjf :${res.data.toString()}");
      return res.data['status'] == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateLocation() async {
    try {
      // 1️⃣ Check location service
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return false;

      // 2️⃣ Permission check
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) return false;

      // 3️⃣ Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4️⃣ Convert to string (lat,lng)
      String location = "${position.latitude},${position.longitude}";

      // 5️⃣ Send to server
      final res = await dio.post(
        "updateLocation",
        data: {
          "member_id": usermodel.value?.id.toString()??"",
          "location": location,
        },
      );

      return res.data['status'] == true;
    } catch (e) {
      return false;
    }
  }



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
       FirebaseMessaging messaging = FirebaseMessaging.instance;
       String? token = await messaging.getToken();
       print("FCM Token: $token");

       await updateFcmToken(token?.toString()??"");
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


  Future<void> userLogintemp({required String aadhar, required String password,}) async
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
       FirebaseMessaging messaging = FirebaseMessaging.instance;
       String? token = await messaging.getToken();
       print("FCM Token: $token");

       await updateFcmToken(token?.toString()??"");
       // Get.offAllNamed(Routes.dashboard);
        // Get.snackbar(
        //   'Success',
        //   data['message'] ?? 'Login successful',
        //   snackPosition: SnackPosition.BOTTOM,backgroundColor: Colors.green,colorText: Colors.white
        // );
      } else {
        // Get.snackbar(
        //   'Error',
        //   data['message'] ?? 'Invalid credentials',
        //   snackPosition: SnackPosition.BOTTOM,colorText: Colors.white,backgroundColor: Colors.red
        // );
      }
    } on DioException catch (e) {
      // Get.snackbar(
      //   'Login Failed',
      //   e.response?.data['message'] ?? 'Server not responding',
      //   snackPosition: SnackPosition.BOTTOM,colorText: Colors.white,backgroundColor: Colors.red
      // );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void>logout()async{
    await sharedprefresController.deleteshared();
    enablerole.value=0;
    Get.offAllNamed(Routes.login);
  }


  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> paymentScreenshot  = Rx<File?>(null);
  final Rx<File?> nomineeImage  = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickFromCamera() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
    Get.back();
  }


  Future<void> pickFromGallery() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
    Get.back();
  }

  Future<void> pickFromCameraqr() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      paymentScreenshot.value = File(image.path);
    }
    Get.back();
  }


  Future<void> pickFromGalleryqr() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      paymentScreenshot.value = File(image.path);
    }
    Get.back();
  }

  bool startsWithLetter(String value) {
    if (value.isEmpty) return false;
    return RegExp(r'^[A-Za-z]').hasMatch(value[0]);
  }


  var iagree=false.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedServiceStatus = ''.obs;
  final RxString selectedGender = ''.obs;
  final RxString selecteddrivetype = ''.obs;

  Future<void> registerForceMan({
    required String category,
    required String inservice,
    required String name,
    required String aadhar,
    required String fatherHusband,
    required String birthday,
    required String password,
    required String mobile,
    required String email,
    required String dlNo,
    required String gender,
    required String occupation,
    required String departmentId,
    required String stateId,
    required String districtId,
    required String block,
    required String permAddress,
    required String nomineeName,
    required String nomineeRelation,
    required String nomineeMobile,
    required String bankName,
    required String ifscCode,
    required String accountNo,


    required String type,

    required int amount,
    required String orderId,
    required String transactionId,
    required String status,






  }) async {
    try {
      isLoading.value = true;

      FormData formData = FormData.fromMap({
        // BASIC
        "category": category,
        "inservice": inservice,
        "name": name,
        "aadhar": aadhar,
        "fatherhusband": fatherHusband,
        "birthday": birthday.toString(),
        "password": password,
        "mobile": mobile,
        "email": email,
        "dlno": dlNo,
        "gender": gender,
        "occupation": occupation,

        // LOCATION
        "department": departmentId,
        "state": stateId,
        "district": districtId,
        "block": block,
        "perm_address": permAddress,

        // NOMINEE
        "nominee_name": nomineeName,
        "nominee_relationship": nomineeRelation,
        "nominee_mobileno": nomineeMobile,

        // BANK
        "bankname": bankName,
        "ifsccode": ifscCode,
        "accountno": accountNo,

        // SYSTEM (FIXED / HIDDEN)
        "announcement": "1",
        "role_id": "4", // Force Man
        "status": "1",
        "featured": "1",
        "locked": "0",
        "autopay_status": "0",
      });

      // FILES (OPTIONAL)
      if (selectedImage.value != null) {
        formData.files.add(
          MapEntry(
            "user_photo",
            await MultipartFile.fromFile(
              selectedImage.value!.path,
              filename: selectedImage.value!.path.split('/').last,
            ),
          ),
        );
      }

      if (nomineeImage.value != null) {
        formData.files.add(
          MapEntry(
            "nominee_image",
            await MultipartFile.fromFile(
              nomineeImage.value!.path,
              filename: nomineeImage.value!.path.split('/').last,
            ),
          ),
        );
      }

      if (paymentScreenshot.value != null) {
        formData.files.add(
          MapEntry(
            "payment_screenshot",
            await MultipartFile.fromFile(
              paymentScreenshot.value!.path,
              filename: paymentScreenshot.value!.path.split('/').last,
            ),
          ),
        );
      }

      print("jkfkbeskjfkjesbjkf :${ServerConstants.addMember}");
      final response = await Dio().post(
        ServerConstants.addMember, // 🔥 YOUR API URL
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      print("dssfljbesek : ${response.data.toString()}");
      if (response.data['status'] == true) {
        
        Get.snackbar("Success", response.data['message']);
        // startsWithLetter(aadhar.toString())
        if (startsWithLetter(aadhar)) {
          // 🔹 Call ANOTHER function
         await adminLogin(
              username: aadhar,
              password: password,
            );

           } else {

          if(type=="pay"){
            await phonePeAuthController.uploadPaymentData( amount: amount.toString(), orderId: orderId.toString(), transactionId: transactionId.toString(), status: status.toString(), aadhar: aadhar.toString(), mop: 'pg');
            // 🔹 Normal numeric login
          await userLogin(
            aadhar: aadhar,
            password: password,
          );}
          else{
            return print("ebcjkddbjkc");
          }
        }

      } else {
        Get.snackbar("Error", response.data['message']);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("sfljejnfjnesjfngj ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> registerDrivers({
    required String category,
    required String inservice,
    required String name,
    required String aadhar,
    required String fatherHusband,
    required String birthday,
    required String password,
    required String mobile,
    required String email,
    required String dlNo,
    required String gender,
    required String occupation,
    required String departmentId,
    required String stateId,
    required String districtId,
    required String block,
    required String permAddress,
    required String nomineeName,
    required String nomineeRelation,
    required String nomineeMobile,
    required String bankName,
    required String ifscCode,
    required String accountNo,
    required String driver_type,



    required String type,

    required int amount,
    required String orderId,
    required String transactionId,
    required String status,
  }) async {
    try {
      isLoading.value = true;

      FormData formData = FormData.fromMap({
        // BASIC
        "category": category,
        "inservice": inservice,
        "name": name,
        "aadhar": aadhar,
        "fatherhusband": fatherHusband,
        "birthday": birthday.toString(),
        "password": password,
        "mobile": mobile,
        "email": email,
        "dlno": dlNo,
        "gender": gender,
        "occupation": occupation,

        // LOCATION
        "department": departmentId,
        "state": stateId,
        "district": districtId,
        "block": block,
        "perm_address": permAddress,

        "driver_type":driver_type,
        // NOMINEE
        "nominee_name": nomineeName,
        "nominee_relationship": nomineeRelation,
        "nominee_mobileno": nomineeMobile,

        // BANK
        "bankname": bankName,
        "ifsccode": ifscCode,
        "accountno": accountNo,

        // SYSTEM (FIXED / HIDDEN)
        "announcement": "1",
        "role_id": "4", // Force Man
        "status": "1",
        "featured": "1",
        "locked": "0",
        "autopay_status": "0",


      });

      // FILES (OPTIONAL)
      if (selectedImage.value != null) {
        formData.files.add(
          MapEntry(
            "user_photo",
            await MultipartFile.fromFile(
              selectedImage.value!.path,
              filename: selectedImage.value!.path.split('/').last,
            ),
          ),
        );
      }

      if (nomineeImage.value != null) {
        formData.files.add(
          MapEntry(
            "nominee_image",
            await MultipartFile.fromFile(
              nomineeImage.value!.path,
              filename: nomineeImage.value!.path.split('/').last,
            ),
          ),
        );
      }

      if (paymentScreenshot.value != null) {
        formData.files.add(
          MapEntry(
            "payment_screenshot",
            await MultipartFile.fromFile(
              paymentScreenshot.value!.path,
              filename: paymentScreenshot.value!.path.split('/').last,
            ),
          ),
        );
      }

      print("jkfkbeskjfkjesbjkf :${ServerConstants.addMember}");
      final response = await Dio().post(
        ServerConstants.addMember, // 🔥 YOUR API URL
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      print("dssfljbesek : ${response.data.toString()}");
      if (response.data['status'] == true) {

        Get.snackbar("Success", response.data['message']);
        // startsWithLetter(aadhar.toString())
        if (startsWithLetter(aadhar)) {
          // 🔹 Call ANOTHER function
          adminLogin(
            username: aadhar,
            password: password,
          );
        } else {

          if(type=="pay"){
            await membersController.submitMemberDrivers(aadhar: aadhar);
            await phonePeAuthController.uploadPaymentData( amount: amount.toString(), orderId: orderId.toString(), transactionId: transactionId.toString(), status: status.toString(), aadhar: aadhar.toString(),mop: 'pg');
            // 🔹 Normal numeric login
            await userLogin(
              aadhar: aadhar,
              password: password,
            );}
          else{
            return print("ebcjkddbjkc");
          }

          // // 🔹 Normal numeric login
          // userLogin(
          //   aadhar: aadhar,
          //   password: password,
          // );
        }

      } else {
        Get.snackbar("Error", response.data['message']);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      print("sfljejnfjnesjfngj ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

}



