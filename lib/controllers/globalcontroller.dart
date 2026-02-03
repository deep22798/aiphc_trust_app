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
import 'package:get/get.dart';

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
  void safeFetchAll() {
    fetchAboutus();
    fetchsupportqureies();
    fetchcontactus();
    fetchteamlist();
    fetchdonators();
    fetchsucessstories();
    fetchsucesrecentini();
    fetchsucespension();
    fetchStates();
  }

  /// Generic safe API call
  Future<Map<String, dynamic>?> _safeGet(String url) async {
    try {
      final response = await _dio.get(url);
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
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
