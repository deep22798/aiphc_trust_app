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
import 'package:get/get.dart' hide FormData;
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

  @override
  void onReady() {
    super.onReady();
    safeFetchAll();
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
