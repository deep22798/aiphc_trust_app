import 'package:aiphc/controllers/theme/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget themeToggle(ThemeController theme) {
  return Obx(() {
    final isDark = theme.isDark.value;
    return GestureDetector(
      onTap: theme.toggleTheme,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        width: 110,
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: isDark
                ? [
              const Color(0xFF1E1E1E),
              const Color(0xFF121212),
            ]
                : [
              const Color(0xFF2E7D32),
              const Color(0xFF66BB6A),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.6)
                  : Colors.green.withOpacity(0.45),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 🌙 / 🌞 icons
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.light_mode,
                      size: 18,
                      color: isDark
                          ? Colors.white38
                          : Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.dark_mode,
                      size: 18,
                      color: isDark
                          ? Colors.white
                          : Colors.white38,
                    ),
                  ),
                ],
              ),
            ),

            // 🔘 MOVING THUMB
            AnimatedAlign(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutBack,
              alignment:
              isDark ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  size: 18,
                  color: isDark
                      ? const Color(0xFF121212)
                      : const Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}
