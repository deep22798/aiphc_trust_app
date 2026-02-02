import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt currentPage = 0.obs;

  final gridItems = const [
    {"icon": "people", "label": "सभी सदस्यों की सूची\nAll Member list"},
    {"icon": "gallery", "label": "गैलरी\nGallery"},
    {"icon": "rules", "label": "प्रक्रिया / निर्देश\nRules"},
  ];

  final carouselItems = const [
    "Education Support Programs",
    "Health & Medical Camps",
    "Community Welfare Initiatives",
  ];

  final listItems = const [
    {"icon": "vhelp", "label": "वित्तीय सहायता\nVittiya Sahayata"},
    {"icon": "help", "label": "पेंशन सहायता\nPension Help"},
    {"icon": "donate", "label": "दान\nDonations"},
  ];

  void updatePage(int index) {
    currentPage.value = index;
  }
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

}
