import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/screens/dashboardcontroller.dart';
import '../../controllers/theme/theme_controller.dart';

class Dashboard extends StatelessWidget {
  Dashboard({super.key});

  final controller = Get.put(DashboardController());
  final themeController = Get.find<ThemeController>();

  IconData _iconFromKey(String key) {
    switch (key) {
      case "school":
        return Icons.school;
      case "hospital":
        return Icons.local_hospital;
      case "people":
        return Icons.people;
      case "donate":
        return Icons.volunteer_activism;
      default:
        return Icons.dashboard;
    }
  }

  // ================= HERO SECTION =================

  Widget _hero(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 240,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            const Color(0xFF0F172A), // dark navy
            const Color(0xFF020617),
          ]
              : [
            const Color(0xFF0D47A1),
            const Color(0xFF1976D2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: const AssetImage("assets/images/loginback.jpg"),
          fit: BoxFit.cover,
          opacity: isDark ? 0.06 : 0.14,
        ),
      ),

      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(isDark ? 0.55 : 0.35),
              Colors.black.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Trust Dashboard",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Manage trust services, members & activities",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            // 🌙 ☀ THEME TOGGLE
            Obx(() => Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                icon: Icon(
                  themeController.isDark.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: themeController.toggleTheme,
              ),
            )),
          ],
        ),
      ),
    );
  }

  // ================= WEB GRID =================

  Widget _webGrid(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
      ),
      itemCount: controller.gridItems.length,
      itemBuilder: (_, index) {
        final item = controller.gridItems[index];

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(
                    theme.brightness == Brightness.dark ? 0.35 : 0.08,
                  ),
                  blurRadius: 14,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _iconFromKey(item["icon"]!),
                  size: 28,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  item["label"]!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= MOBILE GRID =================

  Widget _mobileGrid(BuildContext context) {
    final theme = Theme.of(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
      ),
      itemCount: controller.gridItems.length,
      itemBuilder: (_, index) {
        final item = controller.gridItems[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.4 : 0.1,
                ),
                blurRadius: 14,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor:
                theme.colorScheme.primary.withOpacity(0.18),
                child: Icon(
                  _iconFromKey(item["icon"]!),
                  size: 26,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item["label"]!,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================= LIST =================

  Widget _list(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: controller.listItems.map((text) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: theme.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  theme.brightness == Brightness.dark ? 0.35 : 0.08,
                ),
                blurRadius: 12,
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                Icons.notifications,
                size: 20,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Icon(Icons.chevron_right,
                  color: theme.iconTheme.color),
            ],
          ),
        );
      }).toList(),
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth >= 1000;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _hero(context),
                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      isWeb
                          ? _webGrid(context)
                          : _mobileGrid(context),
                      const SizedBox(height: 28),
                      _list(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
