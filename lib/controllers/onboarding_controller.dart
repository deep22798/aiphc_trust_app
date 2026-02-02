import 'package:aiphc/model/onboarding_model.dart';
import 'package:aiphc/utils/Appconstants.dart';
import 'package:aiphc/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  RxInt currentIndex = 0.obs;

  final pages = [
    OnboardingModel(
      image: '${Appconstants.trust1}',
      title: 'Share Kindness',
      description: 'Make a difference by helping those in need.',
    ),
    OnboardingModel(
      image: '${Appconstants.trust2}',
      title: 'Support Communities',
      description: 'Join hands to uplift and support others.',
    ),
    OnboardingModel(
      image: '${Appconstants.trust3}',
      title: 'Bring Hope & Joy',
      description: 'Spread happiness and inspire change.',
    ),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> nextPage() async{
    if (currentIndex.value == pages.length - 1) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("onboard",true);
      Get.offAllNamed(Routes.login);
      // TODO: Navigate to login / home
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
