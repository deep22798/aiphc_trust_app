import 'dart:io';

import 'package:aiphc/model/aboutus.dart';
import 'package:aiphc/model/contactus.dart';
import 'package:aiphc/model/department.dart';
import 'package:aiphc/model/districtmodel.dart';
import 'package:aiphc/model/donation.dart';
import 'package:aiphc/model/myteam.dart';
import 'package:aiphc/model/pensionhelp.dart';
import 'package:aiphc/model/recentInitiativesList.dart';
import 'package:aiphc/model/recenthelp.dart';
import 'package:aiphc/model/states.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class Globalcontroller extends GetxController {

  final aboutLoading = false.obs;
  final contactLoading = false.obs;

  final RxList<AboutUsModel> aboutus = <AboutUsModel>[].obs;
  final RxList<ContactMessageModel> supportquries = <ContactMessageModel>[].obs;
  final RxList<ContactusModelMprofile> profile = <ContactusModelMprofile>[].obs;
  final RxList<DonationModel> donation = <DonationModel>[].obs;
  final RxList<SuccessModel> successlist = <SuccessModel>[].obs;
  final RxList<RecentInitiativeModel> recentiniti = <RecentInitiativeModel>[].obs;
  final RxList<PensionHelpModel> pensionlist = <PensionHelpModel>[].obs;
  final RxList<TeamMemberModel> myteamlist = <TeamMemberModel>[].obs;

  final Rx<DepartmentModel?> selectedDepartment =
  Rx<DepartmentModel?>(null);

  final RxList<StateModel> states = <StateModel>[].obs;
  final RxList<DistrictModel> districts = <DistrictModel>[].obs;

  final Rx<StateModel?> selectedState = Rx<StateModel?>(null);
  final Rx<DistrictModel?> selectedDistrict = Rx<DistrictModel?>(null);

  final RxString searchQuery = ''.obs;
  final RxString statusFilter = 'all'.obs;

  final Dio _dio = Dio();


  final pensionTitleCtrl = TextEditingController();
  final pensionAmountCtrl = TextEditingController();
  final pensionDateCtrl = TextEditingController();
  final pensionDescCtrl = TextEditingController();


  Future<void> pickPensionMainImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (img != null) {
      pensionMainImage.value = File(img.path);
    }
  }

  Future<void> pickPensionMultipleImages() async {
    final picker = ImagePicker();
    final imgs = await picker.pickMultiImage(imageQuality: 80);
    if (imgs.isNotEmpty) {
      pensionImages.addAll(imgs.map((e) => File(e.path)));
    }
  }
  Future<void> addPensionHelp() async {
    if (pensionTitleCtrl.text.isEmpty || pensionMainImage.value == null) {
      Get.snackbar("Error", "Title & main image required");
      return;
    }

    try {
      pensionUploading.value = true;

      final dio = Dio();

      // 🔥 FORCE MULTIPART
      dio.options.headers["Content-Type"] = "multipart/form-data";
      dio.options.headers["Accept"] = "application/json";

      final formData = FormData();

      // ---------- FIELDS ----------
      formData.fields.addAll([
        MapEntry("title", pensionTitleCtrl.text),
        MapEntry("amount", pensionAmountCtrl.text),
        MapEntry("page_description", pensionDescCtrl.text),
        MapEntry("date", pensionDateCtrl.text),
        MapEntry("status", "1"),
      ]);

      // ---------- MAIN IMAGE ----------
      formData.files.add(
        MapEntry(
          "image",
          await MultipartFile.fromFile(
            pensionMainImage.value!.path,
            filename: pensionMainImage.value!.path.split('/').last,
          ),
        ),
      );

      // ---------- MULTIPLE IMAGES (🔥 THIS NOW WORKS) ----------
      for (File img in pensionImages) {
        formData.files.add(
          MapEntry(
            "images[]", // 👈 CI4 expects this
            await MultipartFile.fromFile(
              img.path,
              filename: img.path.split('/').last,
            ),
          ),
        );
      }

      final res = await dio.post(
        ServerConstants.addPensionHelp,
        data: formData,
      );

      pensionUploading.value = false;

      if (res.data["status"] == true) {
        clearPensionForm();
        Get.back();
        Get.snackbar("Success", res.data["message"]);
      } else {
        Get.snackbar("Failed", res.data["message"]);
      }
    } catch (e) {
      pensionUploading.value = false;
      Get.snackbar("Error", "Upload failed");
    }
  }
  void clearPensionForm() {
    pensionTitleCtrl.clear();
    pensionAmountCtrl.clear();
    pensionDateCtrl.clear();
    pensionDescCtrl.clear();
    pensionMainImage.value = null;
    pensionImages.clear();
  }

  final Rx<File?> pensionMainImage = Rx<File?>(null);
  final RxList<File> pensionImages = <File>[].obs;

  final RxBool pensionUploading = false.obs;


  final titleCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final descCtrl = TextEditingController();

  final Rx<File?> mainImage = Rx<File?>(null);
  final RxList<File> multipleImages = <File>[].obs;

  final RxBool initiativeUploading = false.obs;

  @override
  void onReady() {
    super.onReady();
    safeFetchAll();
  }


  Future<void> pickMainInitiativeImage() async {
    final picker = ImagePicker();
    final img = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (img != null) {
      mainImage.value = File(img.path);
    }
  }

  Future<void> pickMultipleInitiativeImages() async {
    final picker = ImagePicker();
    final images = await picker.pickMultiImage(imageQuality: 80);
    if (images.isNotEmpty) {
      multipleImages.addAll(images.map((e) => File(e.path)));
    }
  }


  Future<void> addRecentInitiative() async {
    if (titleCtrl.text.trim().isEmpty) {
      Get.snackbar("Error", "Title is required");
      return;
    }

    if (mainImage.value == null) {
      Get.snackbar("Error", "Main image is required");
      return;
    }

    try {
      initiativeUploading.value = true;

      final dio = Dio();
      final formData = FormData();

      // ---------- NORMAL FIELDS ----------
      formData.fields.addAll([
        MapEntry("title", titleCtrl.text.trim()),
        MapEntry("amount", amountCtrl.text.trim()),
        MapEntry("page_description", descCtrl.text.trim()),
        MapEntry("date", dateCtrl.text.trim()),
        MapEntry("status", "1"),
      ]);

      // ---------- MAIN IMAGE ----------
      formData.files.add(
        MapEntry(
          "image",
          await MultipartFile.fromFile(
            mainImage.value!.path,
            filename: mainImage.value!.path.split('/').last,
          ),
        ),
      );

      // ---------- MULTIPLE IMAGES (IMPORTANT PART) ----------
      for (File img in multipleImages) {
        formData.files.add(
          MapEntry(
            "images[]", // 👈 MUST be images[]
            await MultipartFile.fromFile(
              img.path,
              filename: img.path.split('/').last,
            ),
          ),
        );
      }

      // ---------- API CALL ----------
      final response = await dio.post(

        "${ServerConstants.addRecentInitiative}",
        data: formData,
        options: Options(
          headers: {"Accept": "application/json"},
        ),
      );

      initiativeUploading.value = false;

      if (response.data["status"] == true) {
        clearInitiativeForm();
        Get.back();
        Get.snackbar("Success", response.data["message"]);
      } else {
        Get.snackbar("Failed", response.data["message"]);
      }
    } catch (e) {
      initiativeUploading.value = false;
      Get.snackbar("Error", "Upload failed");
    }
  }


  void clearInitiativeForm() {
    titleCtrl.clear();
    amountCtrl.clear();
    dateCtrl.clear();
    descCtrl.clear();
    mainImage.value = null;
    multipleImages.clear();
  }

  /// Wrap all fetch calls to handle exceptions gracefully
  Future<void> safeFetchAll()async {
    await fetchAboutus();
    await fetchsupportqureies();
    await fetchcontactus();
    await fetchteamlist();
    await fetchdonators();
    await fetchsucessstories();
    await fetchsucesrecentini();
    await fetchsucespension();
    await fetchStates();
  }

  /// Generic safe API call
  Future<Map<String, dynamic>?> _safeGet(String url) async {
    try {
      final response = await _dio.get(url);
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        print("sdjkgbfsjkgfkd :${response.data.toString()}");
        return response.data;
      } else {
        print("API returned error ${response.statusCode} for $url");
        return null;
      }
    } on DioException catch (e) {
      print("DioException for $url: ${e.response?.statusCode} - ${e.message}");
      return null;
    } catch (e) {
      print("Unexpected error for $url: $e");
      return null;
    }
  }


  Future<void> openEmail({
    required String email,
    String subjectPrefix = "AIPHC",
    String body = "",
  }) async {
    if (email.isEmpty) {
      Get.snackbar("Error", "Invalid email");
      return;
    }

    final subject = Uri.encodeComponent(subjectPrefix);
    final emailBody = Uri.encodeComponent(body);

    /// ✅ Primary: mailto (opens Gmail app if available)
    final mailtoUri = Uri.parse(
      "mailto:$email?subject=$subject&body=$emailBody",
    );

    try {
      await launchUrl(
        mailtoUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      /// ✅ Fallback: Gmail Web Compose
      final gmailWebUri = Uri.parse(
        "https://mail.google.com/mail/?view=cm&fs=1"
            "&to=$email"
            "&su=$subject"
            "&body=$emailBody",
      );

      await launchUrl(
        gmailWebUri,
        mode: LaunchMode.externalApplication,
      );
    }
  }



  String sanitizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }




  Future<void> openDialer(String phone) async {
    final cleanPhone = sanitizePhone(phone);
    final uri = Uri(scheme: 'tel', path: cleanPhone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar("Error", "Cannot open dialer");
    }
  }



  Future<void> openWhatsApp(String phone) async {
    final cleanPhone = sanitizePhone(phone);

    final uri = Uri.parse(
      "https://wa.me/$cleanPhone",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar("Error", "WhatsApp not installed");
    }
  }




  Future<void> fetchAboutus() async {
    aboutLoading.value = true;
    try {
      final data = await _safeGet(ServerConstants.aboutUs);
      if (data != null && data['status'] == true) {
        aboutus.value = (data['data'] as List)
            .map((e) => AboutUsModel.fromJson(e))
            .toList();
      }
    } finally {
      aboutLoading.value = false;
    }
  }

  Future<void> fetchsupportqureies() async {
    contactLoading.value = true;
    supportquries.clear();
    try {
      final data = await _safeGet(ServerConstants.contactUs);
      if (data != null && data['status'] == true) {
        supportquries.value = (data['data'] as List)
            .map((e) => ContactMessageModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }


  var loading = false.obs;
  var supportQueries = <Map<String, dynamic>>[].obs;


  /// ADD SUPPORT QUERY
  Future<void> addQuery({
    required String name,
    required String email,
    required String mobile,
    required String subject,
    required String message,
    required String memberid,
  }) async {
    loading.value = true;

    try {
      final response = await Dio().post(
        "${ServerConstants.addContactUs}",
        data: FormData.fromMap({
          "name": name,
          "memberid": memberid,
          "email": email,
          "mobile_no": mobile,
          "subject": subject,
          "message": message,
        }),
      );

      if (response.data['status'] == true) {
        supportQueries.insert(0, {
          "id": response.data['id'],
          "name": name,
          "email": email,
          "message": message,
        });

        Get.snackbar(
          "Success",
          "Query added successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar("Error", response.data['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "Server error");
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchcontactus() async {
    contactLoading.value = true;
    profile.clear();
    try {
      final data = await _safeGet(ServerConstants.profile);
      if (data != null && data['status'] == true) {
        profile.value = (data['data'] as List)
            .map((e) => ContactusModelMprofile.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }

  Future<void> fetchteamlist() async {
    contactLoading.value = true;
    myteamlist.clear();
    try {
      final data = await _safeGet(ServerConstants.teamList);
      if (data != null && data['status'] == true) {
        myteamlist.value = (data['data'] as List)
            .map((e) => TeamMemberModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }

  Future<void> fetchdonators() async {
    contactLoading.value = true;
    donation.clear();
    try {
      final data = await _safeGet(ServerConstants.donations);
      if (data != null && data['status'] == true) {
        donation.value = (data['data'] as List)
            .map((e) => DonationModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }

  Future<void> fetchsucessstories() async {
    contactLoading.value = true;
    successlist.clear();
    try {
      final data = await _safeGet(ServerConstants.successList);
      if (data != null && data['status'] == true) {
        successlist.value = (data['data'] as List)
            .map((e) => SuccessModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }

  Future<void> fetchsucesrecentini() async {
    contactLoading.value = true;
    recentiniti.clear();
    try {
      final data = await _safeGet(ServerConstants.recentInitiativesList);
      if (data != null && data['status'] == true) {
        recentiniti.value = (data['data'] as List)
            .map((e) => RecentInitiativeModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }

  Future<void> fetchsucespension() async {
    contactLoading.value = true;
    pensionlist.clear();
    try {
      final data = await _safeGet(ServerConstants.pensionHelpList);
      if (data != null && data['status'] == true) {
        pensionlist.value = (data['data'] as List)
            .map((e) => PensionHelpModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }



  Future<void> fetchStates() async {
    contactLoading.value = true;
    states.clear();
    try {
      final data = await _safeGet(ServerConstants.states);
      if (data != null && data['status'] == true) {
        states.value = (data['data'] as List)
            .map((e) => StateModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }

  Future<void> fetchDistrictsByState(String stateId) async {
    contactLoading.value = true;
    districts.clear();
    try {
      final data = await _safeGet(
        "${ServerConstants.districts}?state_id=$stateId",
      );
      if (data != null && data['status'] == true) {
        districts.value = (data['data'] as List)
            .map((e) => DistrictModel.fromJson(e))
            .toList();
      }
    } finally {
      contactLoading.value = false;
    }
  }





  final RxList<File> images = <File>[].obs;
  final RxBool uploading = false.obs;

  Future<void> pickImages() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);

    if (picked.isNotEmpty) {
      images.addAll(picked.map((e) => File(e.path)));
    }
  }

  Future<void> uploadImages({required String id}) async {
    if (images.isEmpty) {
      Get.snackbar("Error", "Please select images");
      return;
    }

    try {
      uploading.value = true;

      final dio = Dio();
      final formData = FormData();

      formData.fields.add(MapEntry("id", id));

      // 🔥 IMPORTANT: images[]
      for (File img in images) {
        formData.files.add(
          MapEntry(
            "images[]",
            await MultipartFile.fromFile(
              img.path,
              filename: img.path.split('/').last,
            ),
          ),
        );
      }

      final res = await dio.post(
        "${ServerConstants.updateRecentInitiative}",
        data: formData,
      );

      uploading.value = false;

      if (res.data["status"] == true) {

        images.clear();
        Get.back();
        Get.snackbar("Success", res.data["message"]);
      } else {
        Get.snackbar("Failed", res.data["message"]);
      }
    } catch (e) {
      uploading.value = false;
      Get.snackbar("Error", "Upload failed");
    }
  }





  final RxList<File> imagess = <File>[].obs;
  final RxBool uploadingg = false.obs;

  Future<void> pickImagess() async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage(imageQuality: 80);

    if (picked.isNotEmpty) {
      imagess.addAll(picked.map((e) => File(e.path)));
    }
  }

  Future<void> uploadImagess(String pensionId) async {
    if (imagess.isEmpty) {
      Get.snackbar("Error", "Please select images");
      return;
    }

    try {
      uploadingg.value = true;

      final dio = Dio();
      dio.options.headers["Content-Type"] = "multipart/form-data";
      dio.options.headers["Accept"] = "application/json";

      final formData = FormData();

      // REQUIRED ID
      formData.fields.add(
        MapEntry("id", pensionId),
      );


      // 🔥 MULTIPLE IMAGES — MUST BE images[]
      for (File img in imagess) {
        formData.files.add(
          MapEntry(
            "images[]",
            await MultipartFile.fromFile(
              img.path,
              filename: img.path.split('/').last,
            ),
          ),
        );
      }


      final res = await dio.post(
        ServerConstants.updatePensionHelp,
        data: formData,
      );

      uploadingg.value = false;

      if (res.data["status"] == true) {
        imagess.clear();
        Get.back();

        Get.snackbar("Success", res.data["message"]);
      } else {
        Get.snackbar("Failed", res.data["message"]);
      }
    } catch (e) {
      uploadingg.value = false;
      Get.snackbar("Error", "Upload failed");
    }
  }
}



// import 'package:aiphc/model/aboutus.dart';
// import 'package:aiphc/model/contactus.dart';
// import 'package:aiphc/model/donation.dart';
// import 'package:aiphc/model/myteam.dart';
// import 'package:aiphc/model/pensionhelp.dart';
// import 'package:aiphc/model/pensionhelp.dart';
// import 'package:aiphc/model/recentInitiativesList.dart';
// import 'package:aiphc/model/recenthelp.dart';
// import 'package:aiphc/utils/serverconstants.dart';
// import 'package:dio/dio.dart';
// import 'package:get/get.dart';
//
// class Globalcontroller extends GetxController {
//
//   final aboutLoading = false.obs;
//   final contactLoading = false.obs;
//
//   final RxList<AboutUsModel> aboutus = <AboutUsModel>[].obs;
//   final RxList<ContactMessageModel> supportquries = <ContactMessageModel>[].obs;
//   final RxList<ContactusModelMprofile> profile = <ContactusModelMprofile>[].obs;
//   final RxList<DonationModel> donation = <DonationModel>[].obs;
//   final RxList<SuccessModel> successlist = <SuccessModel>[].obs;
//   final RxList<RecentInitiativeModel> recentiniti = <RecentInitiativeModel>[].obs;
//   final RxList<PensionHelpModel> pensionlist = <PensionHelpModel>[].obs;
//
//   final RxList<TeamMemberModel> myteamlist = <TeamMemberModel>[].obs;
//   final RxString searchQuery = ''.obs;
//   final RxString statusFilter = 'all'.obs; // all | active | inactive
//
//   @override
//   void onReady() {
//     super.onReady();
//     fetchAboutus();
//     fetchsupportqureies();
//     fetchcontactus();
//     fetchteamlist();
//     fetchdonators();
//     fetchsucessstories();
//     fetchsucesrecentini();
//     fetchsucespension();
//   }
//
//   Future<void> fetchAboutus() async {
//     try {
//       aboutLoading.value = true;
//
//       final response = await Dio().get(ServerConstants.aboutUs);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         aboutus.value =
//             (data['data'] as List)
//                 .map((e) => AboutUsModel.fromJson(e))
//                 .toList();
//       }
//     } finally {
//       aboutLoading.value = false;
//     }
//   }
//
//   Future<void> fetchsupportqureies() async {
//     try {
//       contactLoading.value = true;
//       supportquries.clear();
//
//       final response = await Dio().get(ServerConstants.contactUs);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         supportquries.value =
//             (data['data'] as List)
//                 .map((e) => ContactMessageModel.fromJson(e))
//                 .toList();
//       }
//     } finally {
//       contactLoading.value = false;
//     }
//   }
//
//
//   Future<void> fetchcontactus() async {
//     try {
//       contactLoading.value = true;
//       profile.clear();
//
//       final response = await Dio().get(ServerConstants.profile);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         profile.value =
//             (data['data'] as List)
//                 .map((e) => ContactusModelMprofile.fromJson(e))
//                 .toList();
//       }
//     } finally {
//       contactLoading.value = false;
//     }
//   }
//
//
//   Future<void> fetchteamlist() async {
//     try {
//       contactLoading.value = true;
//       myteamlist.clear();
//
//       final response = await Dio().get(ServerConstants.teamList);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         myteamlist.value =
//             (data['data'] as List)
//                 .map((e) => TeamMemberModel.fromJson(e))
//                 .toList();
//       }
//     } finally {
//       contactLoading.value = false;
//     }
//   }
//
//
//
//   Future<void> fetchdonators() async {
//     try {
//       contactLoading.value = true;
//       donation.clear();
//
//       final response = await Dio().get(ServerConstants.donations);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         donation.value =
//             (data['data'] as List)
//                 .map((e) => DonationModel.fromJson(e))
//                 .toList();
//       }
//     } finally {
//       contactLoading.value = false;
//     }
//   }
//
//
//   // final RxList<SuccessModel> successlist = <SuccessModel>[].obs;
//
//   Future<void> fetchsucessstories() async {
//     try {
//       contactLoading.value = true;
//       successlist.clear();
//
//       final response = await Dio().get(ServerConstants.successList);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         print("fekjkfbewbjewvbf :${data.toString()}");
//         successlist.value =
//             (data['data'] as List)
//                 .map((e) => SuccessModel.fromJson(e))
//                 .toList();
//       }
//     } finally {
//       contactLoading.value = false;
//     }
//   }
//
//
//   // final RxList<SuccessModel> successlist = <SuccessModel>[].obs;
//
//   Future<void> fetchsucesrecentini() async {
//     try {
//       contactLoading.value = true;
//       successlist.clear();
//
//       final response = await Dio().get(ServerConstants.recentInitiativesList);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         print("fekjkfbewbjewvbf :${data.toString()}");
//         recentiniti.value =
//             (data['data'] as List)
//                 .map((e) => RecentInitiativeModel.fromJson(e))
//                 .toList();
//       }
//     } finally {
//       contactLoading.value = false;
//     }
//   }
//   Future<void> fetchsucespension() async {
//     try {
//       contactLoading.value = true;
//       pensionlist.clear();
//
//       final response = await Dio().get(ServerConstants.pensionHelpList);
//       final data = response.data;
//
//       if (data['status'] == true) {
//         pensionlist.value = (data['data'] as List)
//             .map((e) => PensionHelpModel.fromJson(e))
//             .toList();
//       }
//     } finally {
//       contactLoading.value = false;
//     }
//   }
//
//
// }
//
