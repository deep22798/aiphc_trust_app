import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt currentPage = 0.obs;

  final gridItems = const [
    {"icon": "school", "label": "Education"},
    {"icon": "hospital", "label": "Health"},
    {"icon": "people", "label": "Members"},
    {"icon": "donate", "label": "Donations"},
  ];

  final carouselItems = const [
    "Education Support Programs",
    "Health & Medical Camps",
    "Community Welfare Initiatives",
  ];

  final listItems =
  List.generate(6, (i) => "Trust activity update ${i + 1}");

  void updatePage(int index) {
    currentPage.value = index;
  }
}
