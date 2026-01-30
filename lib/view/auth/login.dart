import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/theme/theme_controller.dart';
import 'package:aiphc/utils/Appconstants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<Offset> slide;
  late Animation<double> scale;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fade = Tween(begin: 0.0, end: 1.0).animate(controller);
    slide = Tween(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));
    scale = Tween(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // ------------------ UI HELPERS ------------------

  InputDecoration _inputDecoration(String label, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: isDark
          ? theme.colorScheme.surface.withOpacity(0.6)
          : Colors.grey.shade100,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide:
        BorderSide(color: theme.colorScheme.primary, width: 1.6),
      ),
    );
  }

  Widget _themeToggle(ThemeController theme) {
    return Obx(() => IconButton(
      icon: Icon(
        theme.isDark.value ? Icons.light_mode : Icons.dark_mode,
        color: Colors.white,
      ),
      onPressed: theme.toggleTheme,
    ));
  }

  Widget _loginCard(AuthController login) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: ScaleTransition(
          scale: scale,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),

              // ✅ THEME-AWARE CARD COLOR
              color: isDark ? theme.cardColor : Colors.white,

              // ✅ LIGHT MODE SHADOW ONLY
              boxShadow: isDark
                  ? []
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 18),
                ),
              ],

              // ✅ THEME-AWARE BORDER
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.6),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(Appconstants.applogo, height: 100),
                    const SizedBox(height: 16),

                    Text(
                      "Trust Login",
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 28),

                    TextField(
                      maxLength: 12,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        "Aadhaar Number",
                        Icons.credit_card,
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      obscureText: true,
                      decoration:
                      _inputDecoration("Password", Icons.lock),
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: Obx(() => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          theme.colorScheme.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: login.isLoading.value
                            ? null
                            : login.login,
                        child: login.isLoading.value
                            ? const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        )
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _leftPanel(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            theme.colorScheme.surface,               // dark base
            theme.colorScheme.surface.withOpacity(0.85),
          ]
              : const [
            Color(0xFF2E7D32),                       // SAME green
            Color(0xFF66BB6A),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome to\nALL INDIA POLICE\nVITTIYA SAHAYATA TRUST",
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Serving society with dedication, transparency and trust.\n\n"
                "• एक छोटा सा योगदान, किसी चालक परिवार के नाम\n"
                "• Pension Sahayata\n"
                "• Community Welfare\n\n"
                "Together we build a better future.",
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isDark ? Colors.white70 : Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------ BUILD ------------------

  @override
  Widget build(BuildContext context) {
    final theme = Get.find<ThemeController>();
    final login = Get.put(AuthController());

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 900;

          // ================= DESKTOP / WEB =================
          if (isDesktop) {
            return Row(
              children: [
                Expanded(flex: 5, child: _leftPanel(context)),
                Expanded(
                  flex: 4,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          Appconstants.loginbackground,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // ✅ BLUR CONFINED TO RIGHT PANEL
                      ClipRect(
                        child: BackdropFilter(
                          filter:
                          ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ),
                      ),

                      Positioned(
                        top: 20,
                        right: 20,
                        child: _themeToggle(theme),
                      ),

                      Center(
                        child: ConstrainedBox(
                          constraints:
                          const BoxConstraints(maxWidth: 420),
                          child: _loginCard(login),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // ================= MOBILE / TABLET =================
          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  Appconstants.loginbackground,
                  fit: BoxFit.cover,
                ),
              ),

              ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                  child: Container(
                    color: Colors.black.withOpacity(0.25),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                right: 20,
                child: _themeToggle(theme),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: _loginCard(login),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
