import 'package:aiphc/controllers/theme/theme_controller.dart';
import 'package:aiphc/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aiphc/controllers/auth/login.dart';

class Adminprofile extends StatelessWidget {
  Adminprofile({super.key});

  final AuthController authController = Get.put(AuthController());
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bool isDark = themeController.isDark.value;
      final ThemeData theme =
      isDark ? AppTheme.dark : AppTheme.light;

      final admin = authController.adminData.value;

      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.primaryColor,
          title: const Text('Admin Profile'),
          centerTitle: true,
        ),
        body: admin == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              /// ================= HEADER =================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      theme.primaryColor,
                      theme.primaryColor.withOpacity(0.75),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor:
                      theme.scaffoldBackgroundColor,
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 52,
                        color: theme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      admin.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? Colors.white
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      admin.username,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// ================= DETAILS CARD =================
              _infoCard(theme, isDark, [
                _infoRow('Admin ID', admin.id),
                _infoRow(
                  'Status',
                  admin.status == '1'
                      ? 'Active'
                      : 'Inactive',
                ),
                _infoRow('Username', admin.username),
                _infoRow('Created On', admin.dateCreated),
              ]),
            ],
          ),
        ),
      );
    });
  }

  // ================= UI HELPERS =================

  Widget _infoCard(
      ThemeData theme,
      bool isDark,
      List<Widget> children,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.6 : 0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.circle,
            size: 8,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
