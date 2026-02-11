import 'dart:ui';
import 'package:aiphc/view/auth/registration/drivers.dart';
import 'package:aiphc/view/auth/registration/forceman.dart';
import 'package:aiphc/view/auth/registration/transport.dart';
import 'package:aiphc/view/screens/dashboard.dart';
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

  // 🔐 Text Controllers (NO late)
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 🔐 Auth Controller (created once)
  final AuthController login = Get.put(AuthController(), permanent: true);

  // 🎞️ Animation vars (NO late)
  AnimationController? controller;
  Animation<double>? fade;
  Animation<Offset>? slide;
  Animation<double>? scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    fade = Tween(begin: 0.0, end: 1.0).animate(controller!);

    slide = Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(parent: controller!, curve: Curves.easeOut),
    );

    scale = Tween(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: controller!, curve: Curves.easeOutBack),
    );

    controller!.forward();

    // 👇 POPUP after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDonationPopup();
    });
  }


  bool startsWithLetter(String value) {
    if (value.isEmpty) return false;
    return RegExp(r'^[A-Za-z]').hasMatch(value[0]);
  }



  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    controller?.dispose();
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
      opacity: fade!,
      child: SlideTransition(
        position: slide!,
        child: ScaleTransition(
          scale: scale!,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: isDark ? theme.cardColor : Colors.white,
              boxShadow: isDark
                  ? []
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.18),
                  blurRadius: 28,
                  offset: const Offset(0, 18),
                ),
              ],
              border: Border.all(
                color: theme.dividerColor.withOpacity(0.6),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: SingleChildScrollView(
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
                        controller: usernameController,
                        maxLength: 12,
                        // keyboardType: TextInputType.,
                        decoration: _inputDecoration(
                          "Aadhaar Number",
                          Icons.credit_card,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
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
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),
                          // onPressed: login.isLoading.value
                          //     ? null
                          //     : () {
                          //   if (usernameController.text.isEmpty ||
                          //       passwordController.text.isEmpty) {
                          //     Get.snackbar(
                          //       'Error',
                          //       'Please enter Aadhaar & password',
                          //       snackPosition:
                          //       SnackPosition.BOTTOM,
                          //     );
                          //     return;
                          //   }
                          //
                          //   login.adminLogin(
                          //     username: usernameController.text
                          //         .trim(),
                          //     password: passwordController.text
                          //         .trim(),
                          //   );
                          // },
                          onPressed: login.isLoading.value
                              ? null
                              : () {
                            final username = usernameController.text.trim();
                            final password = passwordController.text.trim();
                  
                            if (username.isEmpty || password.isEmpty) {
                              Get.snackbar(
                                'Error',
                                'Please enter Aadhaar & password',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return;
                            }
                  
                            // 👇 CHECK FIRST CHARACTER
                            if (startsWithLetter(username)) {
                              // 🔹 Call ANOTHER function
                              login.adminLogin(
                                username: username,
                                password: password,
                              );
                            } else {
                              // 🔹 Normal numeric login
                              login.userLogin(
                                aadhar: username,
                                password: password,
                              );
                            }
                          },
                          child: login.isLoading.value
                              ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                              : const Text(
                            "Login (लॉग इन)",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                      ),
                      Divider(),
                      Text("OR / या"),
                      Divider(),
                  
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width/2,
                        height: 40,
                        child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            theme.primaryColorDark,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),
                          // onPressed: login.isLoading.value
                          //     ? null
                          //     : () {
                          //   if (usernameController.text.isEmpty ||
                          //       passwordController.text.isEmpty) {
                          //     Get.snackbar(
                          //       'Error',
                          //       'Please enter Aadhaar & password',
                          //       snackPosition:
                          //       SnackPosition.BOTTOM,
                          //     );
                          //     return;
                          //   }
                          //
                          //   login.adminLogin(
                          //     username: usernameController.text
                          //         .trim(),
                          //     password: passwordController.text
                          //         .trim(),
                          //   );
                          // },
                          onPressed: (){
                            showBigRegistrationTypePopup();
                          },
                          child: login.isLoading.value
                              ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                              : const Text(
                            "Register (रजिस्टर)",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )),
                      ),SizedBox(height: 20,),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width/4,
                        height: 40,
                        child: Obx(() => ElevatedButton(
                          style: ElevatedButton.styleFrom(
                  
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(30),
                            ),
                          ),
                          // onPressed: login.isLoading.value
                          //     ? null
                          //     : () {
                          //   if (usernameController.text.isEmpty ||
                          //       passwordController.text.isEmpty) {
                          //     Get.snackbar(
                          //       'Error',
                          //       'Please enter Aadhaar & password',
                          //       snackPosition:
                          //       SnackPosition.BOTTOM,
                          //     );
                          //     return;
                          //   }
                          //
                          //   login.adminLogin(
                          //     username: usernameController.text
                          //         .trim(),
                          //     password: passwordController.text
                          //         .trim(),
                          //   );
                          // },
                          onPressed: (){
                            Get.offAll(()=>Dashboard());
                          },
                          child: login.isLoading.value
                              ? const CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          )
                              : const Text(
                            "skip>>>>",
                            style: TextStyle(
                              fontSize: 15,
                              color:  Colors.black,
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
            theme.colorScheme.surface,
            theme.colorScheme.surface.withOpacity(0.85),
          ]
              : const [
            Color(0xFF2E7D32),
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
              color: Colors.white,
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
              color: Colors.white70,
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

    return Scaffold(
      body: InkWell(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

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
                        ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                                sigmaX: 8, sigmaY: 8),
                            child: Container(
                              color:
                              Colors.black.withOpacity(0.25),
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

            // ---------- MOBILE / TABLET ----------
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
                    filter:
                    ImageFilter.blur(sigmaX: 8, sigmaY: 8),
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
      ),
    );
  }
  void _showDonationPopup() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false, // ❌ tap outside disabled
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // ❌ back button disabled
          child: Stack(
            children: [
                            // 🔹 FULL SCREEN BLUR
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                ),
              ),

              // 🔹 CENTER POPUP
              Center(
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                          theme.colorScheme.surface,
                          theme.colorScheme.surfaceVariant,
                        ]
                            : const [
                          Color(0xFF2E7D32),
                          Color(0xFF66BB6A),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: (){
                            Get.offAll(()=>Dashboard());
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Icon(Icons.close,color: Colors.white,size: 20,)),
                          ),
                        ),

                        const Icon(
                          Icons.volunteer_activism,
                          size: 60,
                          color: Colors.white,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "आपका एक छोटा सा दान\nकिसी परिवार की मदद बन सकता है ❤️",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "अभी रजिस्टर करें या लॉगिन करें\n"
                              "आपका एक दान किसी ज़रूरतमंद\n"
                              "परिवार का सहारा बन सकता है।",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 26),

                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side:
                                  const BorderSide(color: Colors.white),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                                onPressed: () {
                                  Get.back();
                                  // Get.to(()=>ForceManRegistrationScreen());
                                  showBigRegistrationTypePopup();
                                },
                                child: const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14),
                                ),
                                onPressed: () {
                                  Navigator.pop(context); // ✅ blur removed
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Color(0xFF2E7D32),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
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
  }
  Widget _themeAwareRegisterCard({
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


}
