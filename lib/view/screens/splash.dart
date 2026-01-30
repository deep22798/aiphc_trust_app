import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aiphc/controllers/screens/splashcontroller.dart';
import 'package:aiphc/controllers/theme/theme_controller.dart';
import 'package:aiphc/utils/Appconstants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<double> _fade;

  final splashCtrl = Get.put(SplashController());
  final themeCtrl = Get.find<ThemeController>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // ================= 1. BACKGROUND IMAGE =================
          Positioned.fill(
            child: Image.asset(
              Appconstants.loginbackground2,
              fit: BoxFit.cover,
            ),
          ),

          // ================= 2. BLUR LAYER (REAL BLUR) =================
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.transparent,
                ),

              ),
            ),
          ),

          // ================= 3. SEMI-TRANSPARENT GRADIENT =================
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                    const Color(0xFF020617).withOpacity(0.65),
                    const Color(0xFF0F172A).withOpacity(0.55),
                  ]
                      : [
                    // const Color(0xFF0D47A1).withOpacity(0.55),
                    // const Color(0xFF1976D2).withOpacity(0.45),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // ================= 4. THEME TOGGLE ICON =================
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: Obx(() => Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(
                  themeCtrl.isDark.value
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: Colors.white,
                ),
                onPressed: themeCtrl.toggleTheme,
              ),
            )),
          ),

          // ================= 5. CENTER LOGO (ANIMATED) =================
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: ScaleTransition(
                scale: _scale,
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.45),
                        blurRadius: 45,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                  child: Image.asset(
                    Appconstants.applogo,
                    height: size.width > 700 ? 120 : 90,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
