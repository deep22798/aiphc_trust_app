import 'dart:ui';

import 'package:aiphc/controllers/onboarding_controller.dart';
import 'package:aiphc/controllers/theme/theme_controller.dart';
import 'package:aiphc/utils/Appconstants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/onboarding_card.dart';
class OnboardingView extends StatelessWidget {
  OnboardingView({super.key});

  final onboarding = Get.put(OnboardingController());
  final theme = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final isDark = theme.isDark.value;
        final themeData = Theme.of(context);

        return Stack(
          fit: StackFit.expand,
          children: [
            /// 🔹 Background Image
            Image.asset(
              Appconstants.loginbackground2,
              fit: BoxFit.cover,
            ),

            /// 🔹 Blur Effect
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.transparent,
              ),
            ),

            /// 🔹 Dark / Light Overlay
            Container(
              color: isDark
                  ? Colors.black.withOpacity(0.55)
                  : Colors.blue.withOpacity(0.25),
            ),

            /// 🔹 Actual UI
            SafeArea(
              child: Column(
                children: [
                  /// Theme toggle
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: Colors.white,
                      ),
                      onPressed: theme.toggleTheme,
                    ),
                  ),

                  /// Pages
                  Expanded(
                    child: PageView.builder(
                      controller: onboarding.pageController,
                      onPageChanged: onboarding.onPageChanged,
                      itemCount: onboarding.pages.length,
                      itemBuilder: (_, index) {
                        return OnboardingCard(
                          data: onboarding.pages[index],
                        );
                      },
                    ),
                  ),

                  /// Bottom section
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Obx(
                          () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Dots
                          Row(
                            children: List.generate(
                              onboarding.pages.length,
                                  (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 6),
                                height: 8,
                                width: onboarding.currentIndex.value == index
                                    ? 28
                                    : 8,
                                decoration: BoxDecoration(
                                  color: onboarding.currentIndex.value == index
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),

                          /// Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: themeData.cardColor,
                              foregroundColor:
                              themeData.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.green,
                              elevation: 10,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 28, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: onboarding.nextPage,
                            child: Text(
                              onboarding.currentIndex.value ==
                                  onboarding.pages.length - 1
                                  ? 'Start Helping ❤️'
                                  : 'Next',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),

    );
  }
}




