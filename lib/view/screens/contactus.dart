import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/controllers/screens/memberscontroller.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/routes/serverassets.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Globalcontroller());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomeAppBar(title: "Contact Us"),
      body: Obx(() {
        if (controller.aboutLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (controller.profile.isEmpty) {
          return Center(
            child: Text(
              'जानकारी उपलब्ध नहीं है',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        /// ✅ FIRST ITEM ONLY
        final trust = controller.profile.first;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 HERO IMAGE
              if (trust.logo.isNotEmpty)
                Stack(
                  children: [
                    Image.network(
                      "${ServerAssets.baseUrl+"admin/" +trust.photo}",
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (_, __, ___) =>
                          Container(height: 240, color: Colors.grey.shade300),
                    ),
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.25),
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      right: 16,
                      child: Text(
                        trust.name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),

              /// 📍 ADDRESS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _infoTile(
                  theme,
                  icon: Icons.location_on,
                  title: "Address",
                  value: trust.address,
                ),
              ),

              const SizedBox(height: 12),

              /// 📞 CONTACT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _infoTile(
                  theme,
                  icon: Icons.call,
                  title: "Mobile",
                  value:
                  "${trust.mobileNo} ${trust.mobileNo2.isNotEmpty ? ', ${trust.mobileNo2}' : ''}",
                ),
              ),

              const SizedBox(height: 12),

              /// 📧 EMAIL
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _infoTile(
                  theme,
                  icon: Icons.email,
                  title: "Email",
                  value: trust.email,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  /// 🔹 INFO TILE
  Widget _infoTile(
      ThemeData theme, {
        required IconData icon,
        required String title,
        required String value,
      }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
