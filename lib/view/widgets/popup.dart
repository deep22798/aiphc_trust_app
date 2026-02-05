import 'package:aiphc/utils/Appconstants.dart';
import 'package:aiphc/view/auth/registration/drivers.dart';
import 'package:aiphc/view/auth/registration/forceman.dart';
import 'package:aiphc/view/auth/registration/transport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


void showBigRegistrationTypePopup() {
  Get.bottomSheet(
    Container(
      height: Get.height * 0.88,
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Drag Indicator
          Container(
            width: 60,
            height: 5,
            decoration: BoxDecoration(
              color: Get.isDarkMode
                  ? Colors.grey.shade700
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text(
            "Select Registration Type",
            style: Get.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "रजिस्ट्रेशन का प्रकार चुनें",
            style: Get.textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.78,
              children: [
                _themeAwareRegisterCard(
                  title: "Force Man\n(फोर्स मैन)",
                  image: "${Appconstants.forcemanregi}",
                  onTap: () {
                    Get.back();
                    Get.to(()=>ForceManRegistrationScreen());
                  },

                ),
                _themeAwareRegisterCard(
                  title: "Driver\n(ड्राइवर)",
                  image: "${Appconstants.driverregi}",
                  onTap: () {
                    Get.back();
                    Get.to(()=>DriversRegistrationScreen());
                  },
                ),
                _themeAwareRegisterCard(
                  title: "Transport\n(परिवहन)",
                  image: "${Appconstants.transregi}",
                  onTap: () {
                    Get.back();
                    Get.to(()=>TransportRegistrationScreen());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}  Widget _themeAwareRegisterCard({
  required String title,
  required String image,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(22),
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Get.theme.cardColor,
        border: Border.all(
          color: Get.theme.primaryColor.withOpacity(0.4),
        ),
        boxShadow: Get.isDarkMode
            ? []
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(22),
              ),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}