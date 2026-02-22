import 'dart:ui';
import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/emergencycontroller.dart';
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/controllers/paymentcontroller.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
import 'package:aiphc/controllers/screens/bannercontroller.dart';
import 'package:aiphc/controllers/screens/memberscontroller.dart';
import 'package:aiphc/controllers/trackcontroller.dart';
import 'package:aiphc/utils/Appconstants.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/view/auth/login.dart';
import 'package:aiphc/view/donationsscreen.dart';
import 'package:aiphc/view/screens/aboutus.dart';
import 'package:aiphc/view/screens/adminprofile.dart';
import 'package:aiphc/view/screens/autopay.dart';
import 'package:aiphc/view/screens/contactus.dart';
import 'package:aiphc/view/screens/emergencymap.dart';
import 'package:aiphc/view/screens/emergencyuserslist.dart';
import 'package:aiphc/view/screens/gallery/gallery.dart';
import 'package:aiphc/view/screens/kanyaddan.dart';
import 'package:aiphc/view/screens/members/member.dart';
import 'package:aiphc/view/screens/payments.dart';
import 'package:aiphc/view/screens/pensionhelpscreen.dart';
import 'package:aiphc/view/screens/process/process.dart';
import 'package:aiphc/view/screens/profile.dart';
import 'package:aiphc/view/screens/recentiniti.dart';
import 'package:aiphc/view/screens/supportquries.dart';
import 'package:aiphc/view/widgets/marquee.dart';
import 'package:aiphc/view/widgets/popup.dart';
import 'package:aiphc/view/widgets/switchtheme.dart';
import 'package:aiphc/view/widgets/willlpop.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/screens/dashboardcontroller.dart';
import '../../controllers/theme/theme_controller.dart';

class Dashboard extends StatefulWidget {
  Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final controller = Get.put(DashboardController());

  final themeController = Get.find<ThemeController>();

  final authcontroller = Get.find<AuthController>();

  final phonepecontroller = Get.find<PhonePeController>();

  final mebercn = Get.find<MembersController>();

  final banner = Get.find<Bannerscontroller>();

  final paymentsController = Get.find<PaymentsController>();

  final phonePeAuthController = Get.find<PhonePeController>();

  final EmergencyController emergencyController =
  Get.put(EmergencyController());

  final TrackController ctrackontroller =
  Get.put(TrackController());


  void showResetPasswordPopup(String userId) {

    final currentPass = TextEditingController();
    final newPass = TextEditingController();
    final confirmPass = TextEditingController();

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset Password\n(पासवर्ड बदलें)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password\nवर्तमान पासवर्ड',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: newPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password\nनया पासवर्ड',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: confirmPass,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password\nपासवर्ड की पुष्टि कीजिये',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          Obx(() => ElevatedButton(
            onPressed: controller.isLoading.value
                ? null
                : () async{
              if (newPass.text != confirmPass.text) {
                Get.snackbar('Error', 'Passwords do not match');
                return;
              }

             await authcontroller.resetPassword(
                userId: userId,
                currentPassword: currentPass.text.trim(),
                newPassword: newPass.text.trim(),
              );
            },
            child: controller.isLoading.value
                ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Text('Update'),
          )),
        ],
      ),
    );
  }

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

  // ================= HERO =================
  Widget _hero(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF020617)]
              : [const Color(0xFF0D5314), const Color(0xFF17610E)],
        ),
        image: DecorationImage(
          image: AssetImage(Appconstants.loginbackground2),
          fit: BoxFit.cover,
          opacity: isDark ? 0.06 : 0.14,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(isDark ? 0.55 : 0.35),
                    Colors.black.withOpacity(0.05),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "ALL INDIA POLICE\nVITTIYA SAHAYATA\nTRUST",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(width: 10),
                    Image.asset(Appconstants.applogo, scale: 6),
                    const SizedBox(width: 10),
                    const Text(
                      "ऑल इंडिया पुलिस\nवित्तीय सहायता \nट्रस्ट",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    // Obx(() => IconButton(
                    //   icon: Icon(
                    //     themeController.isDark.value
                    //         ? Icons.light_mode
                    //         : Icons.dark_mode,
                    //     color: Colors.white,
                    //   ),
                    //   onPressed: themeController.toggleTheme,
                    // )),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "${authcontroller.enablerole.value == 1
                            ? "Welcome, ${authcontroller.adminData.value?.name}\nआपका स्वागत है, ${authcontroller.adminData.value?.name}"
                            : authcontroller.enablerole.value == 2
                            ? "Welcome, ${authcontroller.usermodel.value?.name}\nआपका स्वागत है, ${authcontroller.usermodel.value?.name}"
                            : ""}",
                        style: TextStyle(
                          color: isDark ? Colors.green : Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
               authcontroller.enablerole.toString()=="1"||authcontroller.enablerole.toString()=="0"?SizedBox(): Obx(() => emergencyController.isLoading.value==true?CircularProgressIndicator():authcontroller.enablerole==0?SizedBox(): Padding(
                  padding:  EdgeInsets.only(right: 10,top: 2,bottom: 2),
                  child: ElevatedButton(style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.red)),
                    onPressed: () async{
                    print("sdvkdjsnvkjds :${!emergencyController.isActive.value}");
                      if (!emergencyController.isActive.value) {
                        emergencyController.trigger(int.parse(authcontroller.usermodel.value?.id??""));
                        SharedPreferences prefs= await SharedPreferences.getInstance();
                        var u= await prefs.getString("username");
                        var p= await prefs.getString("password");

                        await authcontroller.userLogintemp(aadhar: u.toString(), password: p.toString());
                      } else {
                        emergencyController.end(int.parse(authcontroller.usermodel.value?.id??""));
                        SharedPreferences prefs= await SharedPreferences.getInstance();
                        var u= await prefs.getString("username");
                        var p= await prefs.getString("password");

                        await authcontroller.userLogintemp(aadhar: u.toString(), password: p.toString());
                      }
                    },

                    child: Text(emergencyController.isActive.value==true||authcontroller.usermodel.value?.is_emergency.toString()=="1"
                        ? "END EMERGENCY"
                        : "SOS EMERGENCY",style: TextStyle(color: Colors.white),),
                  ),
                ))

                // MaterialButton(onPressed: (){},child: Text("HELP"),)
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SLIDER =================
  Widget slider(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Bannerscontroller bannerController = Get.find();

    return Container(
      height: 230,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F172A), const Color(0xFF020617)]
              : [const Color(0xFFACC8B0), const Color(0xFFABB3AA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage("${Appconstants.loginbackground2}"),
          fit: BoxFit.cover,
          opacity: isDark ? 0.06 : 0.14,
        ),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(isDark ? 0.55 : 0.35),
                  Colors.black.withOpacity(0.05),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Obx(() {
                if (bannerController.bannerloading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                if (bannerController.banners.isEmpty) {
                  return const Center(
                    child: Text(
                      "No banners available",
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CarouselSlider.builder(
                      itemCount: bannerController.banners.length,
                      itemBuilder: (context, index, realIndex) {
                        final banner = bannerController.banners[index];

                        return GestureDetector(
                          onTap: () {
                            // Hero full screen preview if you want
                            Get.to(
                                  () =>
                                  BannerPreview(
                                    image: "${ServerAssets.banner}${banner
                                        .image}",
                                    tag: "banner_$index",
                                  ),
                            );
                          },
                          child: Hero(
                            tag: "banner_$index",
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                children: [
                                  // ImageFiltered(
                                  //   imageFilter: ImageFilter.blur(
                                  //     sigmaX: 4,
                                  //     sigmaY: 4,
                                  //   ),
                                  // adjust blur intensity
                                  // child:
                                  Image.network(
                                    "${ServerAssets.banner}${banner.image}",
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (c, w, p) {
                                      if (p == null) return w;
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      );
                                    },
                                    errorBuilder: (_, __, ___) =>
                                    const Icon(
                                      Icons.broken_image,
                                      color: Colors.white,
                                    ),
                                  ),
                                  // ),
                                  Column(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                            right: 8,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "${banner.subtitle}",
                                                  style: TextStyle(
                                                    backgroundColor: isDark
                                                        ? Colors.black
                                                        : Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Expanded(child: Container(

                                              ))
                                              // Expanded(
                                              //   child: Padding(
                                              //     padding: const EdgeInsets.all(
                                              //       15.0,
                                              //     ),
                                              //     child: Container(
                                              //       decoration: BoxDecoration(
                                              //         shape: index % 2 == 0
                                              //             ? BoxShape.circle
                                              //             : BoxShape.rectangle,
                                              //         image: DecorationImage(
                                              //           image: NetworkImage(
                                              //             "${ServerAssets.banner}${banner.image}",
                                              //           ),
                                              //           fit: BoxFit.cover,
                                              //         ),
                                              //       ),
                                              //       // child: Image.network(
                                              //       //   "${ServerAssets.banner}${banner.image}",
                                              //       //   fit: BoxFit.cover,
                                              //       //   width: double.infinity,
                                              //       //   loadingBuilder: (c, w, p) {
                                              //       //     if (p == null) return w;
                                              //       //     return const Center(
                                              //       //       child: CircularProgressIndicator(color: Colors.white),
                                              //       //     );
                                              //       //   },
                                              //       //   errorBuilder: (_, __, ___) => const Icon(
                                              //       //     Icons.broken_image,
                                              //       //     color: Colors.white,
                                              //       //   ),
                                              //       // ),
                                              //     ),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          color: isDark
                                              ? Colors.black
                                              : Colors.white,
                                          width: double.infinity,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "${banner.title}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
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
                        );
                      },
                      options: CarouselOptions(
                        height: 200,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(
                          milliseconds: 800,
                        ),
                        enlargeCenterPage: true,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: true,
                        pauseAutoPlayOnTouch: true,
                        onPageChanged: (index, reason) {
                          // Optional: sync with controller
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Dots indicator
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: List.generate(
                    //     bannerController.banners.length,
                    //         (index) => Obx(() {
                    //       final current =
                    //           bannerController.currentCarouselIndex.value;
                    //       return Container(
                    //         margin: const EdgeInsets.symmetric(horizontal: 4),
                    //         width: current == index ? 14 : 8,
                    //         height: 8,
                    //         decoration: BoxDecoration(
                    //           color: current == index
                    //               ? Colors.white
                    //               : Colors.white38,
                    //           borderRadius: BorderRadius.circular(4),
                    //         ),
                    //       );
                    //     }),
                    //   ),
                    // ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // ================= GRID =================
  Widget gridview(BuildContext context, isweb) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [
            const Color(0xFF0F172A), // dark navy
            const Color(0xFF020617),
          ]
              : [const Color(0xFF0D5314), const Color(0xFF17610E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage("${Appconstants.loginbackground2}"),
          fit: BoxFit.cover,
          opacity: isDark ? 0.06 : 0.14,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12), // reduced padding
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(isDark ? 0.55 : 0.35),
              Colors.black.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: isweb ? _webGrid(context) : _mobileGrid(context),
      ),
    );
  }

  //
  Widget _webGrid(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradients = themedGradients(isDark);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: controller.gridItems.length,
      itemBuilder: (_, index) {
        final item = controller.gridItems[index];
        final gradient = gradients[index % gradients.length];

        return InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.6)
                      : gradient.first.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _iconFromKey(item["icon"]!),
                  size: 30,
                  color: isDark ? Colors.white : theme.colorScheme.primary,
                ),
                const SizedBox(height: 8),
                Text(
                  item["label"]!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<List<Color>> themedGradients(bool isDark) {
    if (isDark) {
      return const [
        [Color(0xFF1E293B), Color(0xFF0F172A)], // slate
        [Color(0xFF1F2937), Color(0xFF020617)], // gray
        [Color(0xFF0F766E), Color(0xFF042F2E)], // teal
        [Color(0xFF4C1D95), Color(0xFF2E1065)], // purple
        [Color(0xFF7C2D12), Color(0xFF431407)], // brown
        [Color(0xFF064E3B), Color(0xFF022C22)], // green
      ];
    } else {
      return const [
        [Color(0xFFE8F5E9), Color(0xFFC8E6C9)], // green
        [Color(0xFFE3F2FD), Color(0xFFBBDEFB)], // blue
        [Color(0xFFFFF3E0), Color(0xFFFFE0B2)], // orange
        [Color(0xFFF3E5F5), Color(0xFFE1BEE7)], // purple
        [Color(0xFFE0F2F1), Color(0xFFB2DFDB)], // teal
        [Color(0xFFFFEBEE), Color(0xFFFFCDD2)], // red
      ];
    }
  }

  Widget _mobileGrid(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradients = themedGradients(isDark);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1,
      ),
      itemCount: controller.gridItems.length,
      itemBuilder: (_, index) {
        final item = controller.gridItems[index];
        final gradient = gradients[index % gradients.length];

        return InkWell(
          onTap: () {
            if (item["icon"] == "people") {
              Get.to(() => Members());
            } else if (item["icon"] == "gallery") {
              Get.to(() => Gallery());
            } else if (item["icon"] == "rules") {
              Get.to(() => ProcessRules());
            } else {}
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.7)
                      : Colors.black.withOpacity(0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isDark
                      ? Colors.white.withOpacity(0.12)
                      : theme.colorScheme.primary.withOpacity(0.2),
                  child: Icon(
                    _iconFromKey(item["icon"]!),
                    size: 28,
                    color: isDark ? Colors.white : theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item["label"]!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget _list(BuildContext context) {
  List<List<Color>> themedGradientss(bool isDark) {
    if (isDark) {
      return const [
        [Color(0xFF1E293B), Color(0xFF0F172A)],
        [Color(0xFF1F2937), Color(0xFF020617)],
        [Color(0xFF0F766E), Color(0xFF042F2E)],
        [Color(0xFF4C1D95), Color(0xFF2E1065)],
        [Color(0xFF7C2D12), Color(0xFF431407)],
        [Color(0xFF064E3B), Color(0xFF022C22)],
      ];
    } else {
      return const [
        [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        [Color(0xFFE3F2FD), Color(0xFFBBDEFB)],
        [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
        [Color(0xFFE0F2F1), Color(0xFFB2DFDB)],
        [Color(0xFFFFEBEE), Color(0xFFFFCDD2)],
      ];
    }
  }

  IconData _listIconFromKey(String key) {
    switch (key) {
      case "vhelp":
        return Icons.groups;
      case "help":
        return Icons.photo_library;
      case "donate":
        return Icons.volunteer_activism;
      default:
        return Icons.notifications;
    }
  }

  Widget _list(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradients = themedGradientss(isDark);

    return Column(
      children: List.generate(controller.listItems.length, (index) {
        final item = controller.listItems[index];
        final gradient = gradients[index % gradients.length];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: navigation
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.6)
                      : gradient.first.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),

            child: InkWell(
              onTap: () async{
                if (item["icon"] == "vhelp") {
                  Get.to(() => RecentHelp());
                } else if (item["icon"] == "help") {
                  Get.to(() => PensionHelpScreeen());
                } else if (item["icon"] == "donate") {
                  print("djkbvjksdbjkvsdjkvjkbv");
                  Get.to(()=>DonationList());
                  // await authcontroller.updateFcmToken("dfkjsdbjkjkbjkbjKBJBJBJBJKBjkbBKJBjkbKBkbJKKJbk");
                } else {}
              },
              child: Row(
                children: [
                  // ICON BADGE
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withOpacity(0.15)
                          : Colors.black.withOpacity(0.06),
                    ),
                    child: Icon(
                      _listIconFromKey(item["icon"]!),
                      size: 24,
                      color: isDark ? Colors.white : theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // TEXT
                  Expanded(
                    child: Text(
                      item["label"]!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),

                  // ARROW
                  Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white70 : theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _list2(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradients = themedGradientss(isDark);

    return Column(
      children: List.generate(controller.listItems2.length, (index) {
        final item = controller.listItems2[index];
        final gradient = gradients[index % gradients.length];

        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: navigation
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.6)
                      : gradient.first.withOpacity(0.35),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: InkWell(
              onTap: () async{
                if (item["icon"] == "vhelp") {
                  Get.to(() => RecentHelp());
                } else if (item["icon"] == "help") {
                  Get.to(() => PensionHelpScreeen());
                }else if (item["label"] == "कन्यादान \nKanyadaan") {
                  print("djkbvjksdbjkvsdjkvjkbv");
                  Get.to(()=>Kanyaddan());
                  // await authcontroller.updateFcmToken("dfkjsdbjkjkbjkbjKBJBJBJBJKBjkbBKJBjkbKBkbJKKJbk");
                }  else if (item["icon"] == "donate") {
                  print("djkbvjksdbjkvsdjkvjkbv");
                  Get.to(()=>DonationList());
                  // await authcontroller.updateFcmToken("dfkjsdbjkjkbjkbjKBJBJBJBJKBjkbBKJBjkbKBkbJKKJbk");
                } else {}
              },
              child: Row(
                children: [
                  // ICON BADGE
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? Colors.white.withOpacity(0.15)
                          : Colors.black.withOpacity(0.06),
                    ),
                    child: Icon(
                      _listIconFromKey(item["icon"]!),
                      size: 24,
                      color: isDark ? Colors.white : theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(width: 14),

                  // TEXT
                  Expanded(
                    child: Text(
                      item["label"]!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),

                  // ARROW
                  Icon(
                    Icons.chevron_right,
                    color: isDark ? Colors.white70 : theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  // ================= OTHER SCREENS =================
  Widget donatescreen(BuildContext context) {
    final controller = Get.find<Globalcontroller>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        _hero(context),

        Expanded(
          child: Obx(() {
            if (controller.contactLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            if (controller.donation.isEmpty) {
              return Center(
                child: Text(
                  'कोई दान उपलब्ध नहीं है',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }

            // 🔥 SORT BY AMOUNT (TOP DONATORS)
            final topDonators = [...controller.donation]
              ..sort(
                    (a, b) =>
                    double.parse(b.amount).compareTo(double.parse(a.amount)),
              );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🏆 TOP DONATORS
                  Text(
                    '🏆 Top Donators',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 160,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: topDonators.length > 5
                          ? 5
                          : topDonators.length,
                      itemBuilder: (context, index) {
                        final d = topDonators[index];

                        return Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),

                            border: isDark
                                ? Border.all(
                              color: Colors.white.withOpacity(0.08),
                            )
                                : null,

                            boxShadow: isDark
                                ? null
                                : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: theme.colorScheme.primary
                                        .withOpacity(0.15),
                                    child: Icon(
                                      Icons.volunteer_activism,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      d.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              Text(
                                '₹ ${d.amount}',
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                d.message.isNotEmpty
                                    ? d.message
                                    : 'दान के लिए धन्यवाद',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  /// 📋 ALL DONATIONS
                  Text(
                    'All Donations',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.donation.length,
                    itemBuilder: (context, index) {
                      final d = controller.donation[index];
                      final success = d.status == "success";

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),

                          border: isDark
                              ? Border.all(
                            color: Colors.white.withOpacity(0.08),
                          )
                              : null,

                          boxShadow: isDark
                              ? null
                              : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.10),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    d.name,
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: success
                                        ? Colors.green.withOpacity(0.15)
                                        : Colors.orange.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    success ? 'Success' : 'Pending',
                                    style: TextStyle(
                                      color: success
                                          ? Colors.green
                                          : Colors.orange,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹ ${d.amount}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            if (d.message.isNotEmpty)
                              Text(d.message, style: theme.textTheme.bodySmall),
                            const SizedBox(height: 6),
                            Text(
                              d.dateCreated,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget MyteamScreen(BuildContext context, bool isWeb) {
    final controller = Get.find<Globalcontroller>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        _hero(context),

        Expanded(
          child: Obx(() {
            if (controller.contactLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              );
            }

            // 🔍 APPLY SEARCH + FILTER
            final filteredList = controller.myteamlist.where((m) {
              final q = controller.searchQuery.value.toLowerCase();

              final matchesSearch = m.title.toLowerCase().contains(q);

              final matchesStatus =
                  controller.statusFilter.value == 'all' ||
                      (controller.statusFilter.value == 'active' &&
                          m.status == "1") ||
                      (controller.statusFilter.value == 'inactive' &&
                          m.status == "0");

              return matchesSearch && matchesStatus;
            }).toList();

            if (filteredList.isEmpty) {
              return Center(
                child: Text(
                  'कोई टीम सदस्य उपलब्ध नहीं है',
                  style: theme.textTheme.bodyMedium,
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isWeb ? 80 : 16,
                vertical: 16,
              ),
              child: Column(
                children: [
                  // 📊 STATS
                  authcontroller.enablerole.value.toString()!="1"?SizedBox():_statsHeader(theme, controller.myteamlist),

                  authcontroller.enablerole.value.toString()!="1"?SizedBox():const SizedBox(height: 16),

                  // 🔍 SEARCH + FILTER
                authcontroller.enablerole.value.toString()!="1"?SizedBox():Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onChanged: (v) => controller.searchQuery.value = v,
                          decoration: InputDecoration(
                            hintText: 'Search by name',
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: theme.cardColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      authcontroller.enablerole.value.toString()!="1"?SizedBox():const SizedBox(width: 12),
                      authcontroller.enablerole.value.toString()!="1"?SizedBox():DropdownButton<String>(
                        value: controller.statusFilter.value,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'all', child: Text('All')),
                          DropdownMenuItem(
                            value: 'active',
                            child: Text('Active'),
                          ),
                          DropdownMenuItem(
                            value: 'inactive',
                            child: Text('Inactive'),
                          ),
                        ],
                        onChanged: (v) => controller.statusFilter.value = v!,
                      ),
                    ],
                  ),

                  authcontroller.enablerole.value.toString()!="1"?SizedBox():const SizedBox(height: 16),
Text("Team"),
                  // 📋 LIST / GRID
                  Expanded(
                    child: isWeb
                        ? GridView.builder(
                      itemCount: filteredList.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.35,
                      ),
                      itemBuilder: (_, i) =>
                          _teamCard(
                            context,
                            filteredList.reversed.toList()[i],
                            isDark,
                          ),
                    )
                        : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (_, i) =>
                          _teamCard(
                            context,
                            filteredList.reversed.toList()[i],
                            isDark,
                          ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _teamCard(BuildContext context, dynamic m, bool isDark) {
    final theme = Theme.of(context);
    final isActive = m.status == "1";

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () =>authcontroller.enablerole.value.toString()!="1"?(): _showTeamDetail(context, m),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.06),
            ),
            boxShadow: isDark
                ? []
                : [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  "${ServerAssets.baseUrl}/admin/${m.image}",
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(
                        width: 60,
                        height: 60,
                        color: theme.colorScheme.primary.withOpacity(0.15),
                        child: Icon(
                            Icons.person, color: theme.colorScheme.primary),
                      ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            m.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        authcontroller.enablerole.value.toString()!="1"?SizedBox():Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.green.withOpacity(0.15)
                                : Colors.red.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            isActive ? 'Active' : 'Deactivated',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isActive ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(m.position, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      'State: ${m.state_name} | District: ${m.district_name}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statsHeader(ThemeData theme, List list) {
    final total = list.length;
    final active = list
        .where((e) => e.status == "1")
        .length;
    final inactive = total - active;

    Widget box(String label, int value, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Text(
                value.toString(),
                style: theme.textTheme.titleLarge?.copyWith(color: color),
              ),
              Text(label, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        box('Total', total, theme.colorScheme.primary),
        const SizedBox(width: 12),
        box('Active', active, Colors.green),
        const SizedBox(width: 12),
        box('Inactive', inactive, Colors.red),
      ],
    );
  }

  void _showTeamDetail(BuildContext context, dynamic m) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isActive = m.status == "1";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.55, // 🔥 Half screen
          child: Column(
            children: [
              // 🔹 Drag Handle
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              // 🔹 Profile Image
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) {
                      return Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(16),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: InteractiveViewer(
                            child: Image.network(
                              ServerAssets.baseUrl + "admin/" + m.image,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image, size: 80),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                child: CircleAvatar(
                  radius: 46,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  backgroundImage: NetworkImage(
                    ServerAssets.baseUrl + "admin/" + m.image,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // 🔹 Name
              Text(
                m.title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              // 🔹 Position
              Text(
                m.position,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 10),

              // 🔹 Status Chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.green.withOpacity(0.15)
                      : Colors.red.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isActive ? 'Active' : 'Deactivated',
                  style: TextStyle(
                    color: isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 18),
              Divider(color: theme.dividerColor),

              // 🔹 DETAILS (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _detailTile(theme, Icons.map, 'State', m.stateId),
                      _detailTile(
                        theme,
                        Icons.location_city,
                        'District',
                        m.districtId,
                      ),
                      _detailTile(
                        theme,
                        Icons.calendar_today,
                        'Created',
                        m.dateCreated.toString(),
                      ),
                      _detailTile(
                        theme,
                        Icons.update,
                        'Updated',
                        m.dateUpdated.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _detailTile(ThemeData theme,
      IconData icon,
      String label,
      String value,) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: theme.brightness == Brightness.dark
            ? null
            : [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAuthRequiredSheet(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.6 : 0.25),
                blurRadius: 18,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Drag Handle
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.dividerColor,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              /// Lock Icon
              CircleAvatar(
                radius: 34,
                backgroundColor:
                theme.colorScheme.primary.withOpacity(isDark ? 0.25 : 0.15),
                child: Icon(
                  Icons.lock_outline_rounded,
                  size: 34,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 16),

              /// Hindi Title
              Text(
                "कृपया लॉगिन करें",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              /// English subtitle
              Text(
                "Please login or register to continue",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.75),
                ),
              ),

              const SizedBox(height: 24),

              /// LOGIN BUTTON ✅ FIXED
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    // 🔥 IMPORTANT
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: isDark ? 2 : 4,
                  ),
                  onPressed: () {
                    Get.back();
                    Get.to(() => LoginPage());
                  },
                  child: const Text(
                    "Login / लॉगिन करें",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),


              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.primary, // 🔥 IMPORTANT
                    side: BorderSide(
                      color: theme.colorScheme.primary,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    showBigRegistrationTypePopup();
                  },
                  child: const Text(
                    "Register / पंजीकरण करें",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
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

  Widget _profileScreen(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget _card({
      required IconData icon,
      required String title,
      required VoidCallback onTap,
    }) {
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.black.withOpacity(0.06),
              ),
              boxShadow: isDark
                  ? []
                  : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                  child: Icon(icon, color: theme.colorScheme.primary, size: 26),
                ),
                const SizedBox(height: 10),
                Text(
                  title,textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _hero(context),
         Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _card(
                  icon: Icons.person_outline,
                  title: 'Profile\nपहचान',
                  // onTap: () {
                  // },

                  onTap: () async{

                    final role = authcontroller.enablerole.value;

                    if (role == 0) {
                      _showAuthRequiredSheet(Get.context!);
                    } else if (role == 1) {
                      Get.to(() => Adminprofile());
                    } else {
                      Get.to(() => UserProfile());
                    }
                    // print("mdsbhvjhsdv ${mebercn.selectedMemberIds.toString()}");
                   // await mebercn.submitMemberDrivers(aadhar: "382826585757");
                    // phonepecontroller.startTransaction(10);
                    // phonepecontroller.uploadPaymentData(aadhar: "382826585757", amount: 100, orderId: "514684654156468546115", transactionId:"5565645656", status: "SUCCESS");
                  },

                  // onTap: () => Get.to(
                  //   () => authcontroller.enablerole == 1
                  //       ? Adminprofile()
                  //       : UserProfile(),
                  // ),
                ),
                const SizedBox(width: 16),
                _card(
                  icon: Icons.info_outline,
                  title: 'About Us\nहमारे बारे में',
                  onTap: () => Get.to(() => const Aboutus()),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _card(
                  icon: Icons.contact_mail_outlined,
                  title: 'Contact Us\nहमसे संपर्क करें',
                  onTap: () => Get.to(() => const ContactUs()),
                ),
                const SizedBox(width: 16),
                authcontroller.enablerole==0?SizedBox():  _card(
                  icon: Icons.help_outline,
                  title: 'Support Queries\nसमर्थन प्रश्न',
                  onTap: () => Get.to(() => supportquries(

                  )),
                ),
              ],
            ),
          ),

          authcontroller.enablerole==0?SizedBox():Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
            child: Row(
              children: [
                _card(
                  icon: Icons.currency_rupee,
                  title: 'Payments',
                  onTap: () async {
                    Get.to(()=>Payments());
                  },
                  // onTap: () => Get.to(() => const SettingsScreen()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: (){

                      Get.to(()=>Autopay());
                    },
                    child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withOpacity(0.08)
                              : Colors.black.withOpacity(0.06),
                        ),
                        boxShadow: isDark
                            ? []
                            : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 10,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: theme.colorScheme.primary
                                .withOpacity(0.15),
                            child: Icon(
                              Icons.text_rotate_up,
                              color: theme.colorScheme.primary,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text("Autopay")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                authcontroller.enablerole==0?SizedBox(): _card(
                  icon: Icons.power_settings_new,
                  title: 'Logout\nलॉग आउट',
                  onTap: () async {
                    await authcontroller.logout();
                    emergencyController.isActive.value=false;

                  },
                  // onTap: () => Get.to(() => const SettingsScreen()),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : Colors.black.withOpacity(0.06),
                      ),
                      boxShadow: isDark
                          ? []
                          : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.primary
                              .withOpacity(0.15),
                          child: Icon(
                            Icons.brightness_6_outlined,
                            color: theme.colorScheme.primary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(height: 10),
                        themeToggle(themeController)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(()=>authcontroller.enablerole.toString()!="2"?SizedBox():Padding(
              padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showResetPasswordPopup(authcontroller.usermodel.value?.id??"");
                      },
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.black.withOpacity(0.06),
                          ),
                          boxShadow: isDark
                              ? []
                              : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: theme.colorScheme.primary
                                  .withOpacity(0.15),
                              child: Icon(
                                Icons.password,
                                color: theme.colorScheme.primary,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Change Password \n(पासवर्ड बदलें)",textAlign: TextAlign.center,)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= BODY SWITCH =================
  Widget _bodyByIndex(BuildContext context, bool isWeb) {
    return Obx(
          () =>
          IndexedStack(
            index: controller.currentIndex.value,
            children: [
              Column(
                children: [
                  _hero(context),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          InfiniteMarquee(
                            text:
                            "🚨 ऑल इंडिया पुलिस वित्तीय सहायता ट्रस्ट में आपका स्वागत है 🚨",
                            speed: 60,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          slider(context),
                          gridview(context, isWeb),

                      Obx(()=>authcontroller.enablerole.value.toString()=="0"||authcontroller.enablerole.value.toString()=="1"?SizedBox(height: 10,):SizedBox()),
                          Obx(()=>authcontroller.enablerole.value.toString()=="0"||authcontroller.enablerole.value.toString()=="1"?SizedBox(): Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFFE0EC),
                                    Color(0xFFFFF5F9),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  // BoxShadow(
                                  //   color: Colors.pink.withOpacity(0.15),
                                  //   blurRadius: 12,
                                  //   offset: const Offset(0, 6),
                                  // ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: (){},
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.pink.withOpacity(0.15),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.volunteer_activism,
                                            color: Colors.pink,
                                            size: 26,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        const Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Kanyadaan (कन्यादान)",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.2,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                "बेटी की मुस्कान का हिस्सा बनिए",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                       Obx(()=> authcontroller.usermodel.value?.kanyadaan=="2"?SizedBox(): authcontroller.usermodel.value?.kanyadaan=="0"||authcontroller.usermodel.value?.kanyadaan==null?MaterialButton(onPressed: (){
                                         showKanyadaanDialog(context);

                                       },color: Colors.green.shade900,
                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                           child: Padding(
                                             padding: const EdgeInsets.all(4.0),
                                             child: Text("Register now\nअभी पंजीकरण करें",style: TextStyle(color: Colors.white),),
                                           )
                                       ):authcontroller.usermodel.value!.kanyadaan=="1"?Container(decoration: BoxDecoration(color:Colors.green,borderRadius: BorderRadius.circular(10)),child: Padding(
                                         padding: const EdgeInsets.all(8.0),
                                         child: Text("Verification \nPending....",style: TextStyle(color: Colors.yellow,fontWeight: FontWeight.bold),),
                                       )):SizedBox())
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _list(context),

                          // authcontroller.enablerole.value!=0?_list2(context):_list(context),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // donatescreen(context),
              // EmergencyMapScreen(),
              EmergencyListScreen(),
              MyteamScreen(context, isWeb),
              _profileScreen(context),
            ],
          ),
    );
  }

  // ================= BOTTOM NAV =================
  Widget _mobileBottomNav(BuildContext context) {
    if (MediaQuery
        .of(context)
        .size
        .width >= 1000) {
      return const SizedBox.shrink();
    }

    return Obx(
          () =>
          BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: controller.changeTab,
            type: BottomNavigationBarType.fixed,
            items:  [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home\nमुख्य पृष्ठ"),
              BottomNavigationBarItem(
                icon: Icon(Icons.location_on_sharp),
                label: "Live Help\nलाइव सहायता",
                activeIcon: Stack(
                  children: [
                    Center(child: Icon(Icons.circle,color: int.parse(ctrackontroller.emergencyList.length.toString())<1?Colors.green:Colors.red,)),
                    Center(child: Text(ctrackontroller.emergencyList.length.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
                  ],
                )
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                label: "Our Team\nहमारी टीम",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Profile\nरूपरेखा"),
            ],
          ),
    );
  }

  // ================= BUILD =================
  bool isload=false;

  void showDonateDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController mobileController = TextEditingController();
    TextEditingController messageController = TextEditingController();
    TextEditingController amountController = TextEditingController();


    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Title
                    Text(
                      "Make a Donation ❤️",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    /// Full Name
                    authcontroller.enablerole!=0?SizedBox(): TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter your name" : null,
                    ),

                    authcontroller.enablerole!=0?SizedBox():SizedBox(height: 15),

                    /// Mobile Number
                    authcontroller.enablerole!=0?SizedBox():TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Mobile Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter mobile number" : null,
                    ),

                    SizedBox(height: 15),

                    /// Amount
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Donation Amount",
                        prefixText: "₹ ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter amount" : null,
                    ),

                    SizedBox(height: 15),

                    /// Message
                    authcontroller.enablerole!=0?SizedBox():TextFormField(
                      controller: messageController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Message (Optional)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 25),

                    /// Donate Button
                    isload==true?CircularProgressIndicator():SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async{
                            setState(() {
                              isload=true;
                            });
                            final payAmount = amountController.text;
                            print("Proceed to pay ₹$payAmount");
                            // startUpiPayment(payAmount);
                            await phonePeAuthController.startTransaction(int.parse(payAmount.toString()));

                            if(phonePeAuthController.paymentsuccess.value.toString()=="1"){

                              if(authcontroller.enablerole!=0) {
                                await phonePeAuthController.uploadPaymentData(
                                    amount: payAmount.toString(),
                                    orderId: phonePeAuthController.orderid
                                        .toString(),
                                    transactionId: phonePeAuthController.orderid
                                        .value.toString(),
                                    status: phonePeAuthController.paymentstatus
                                        .value.toString(),
                                    aadhar: authcontroller.usermodel.value
                                        ?.aadhar.toString() ?? "",
                                    screenshotPhoto: '',
                                    mop: 'donation');
                                phonePeAuthController.paymentsuccess.value.toString()=="0";
                              }else{

                                if (_formKey.currentState!.validate()) {
                                  await controller.addDonationSimple(
                                      nameController.text,
                                      mobileController.text,
                                      messageController.text,
                                      phonePeAuthController.orderid
                                          .toString(),
                                      phonePeAuthController.orderid
                                          .value.toString(),
                                      phonePeAuthController.paymentstatus
                                          .value.toString(),
                                      amountController.text);
                                  phonePeAuthController.paymentsuccess.value.toString()=="0";
                                }
                              }
                              await paymentsController.fetchPayments(memberId: authcontroller.usermodel.value?.id.toString()??"");

                              // Get.back();
                            }
                            // await controller.addDonationSimple();
                            setState(() {
                              isload=false;
                            });
                            Navigator.pop(context);
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     content: Text("Thank you for your donation ❤️"),
                            //   ),
                            // );
                          },
                        child: Text(
                          "Donate Now\nअभी दान करें",
                          style: TextStyle(
                            fontSize: 16,color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  void showKanyadaanDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController();
    TextEditingController mobileController = TextEditingController();
    TextEditingController banknameController = TextEditingController();
    TextEditingController accnoController = TextEditingController();
    TextEditingController accifscController = TextEditingController();
    final List<int> suggestedAmounts = [501, 1001, 5001];

    final RxInt selectedAmount = 501.obs;
    final TextEditingController amountController =
    TextEditingController(text: '501');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    /// Title
                    Text(
                      "Make a Donation ❤️",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 20),

                    /// Full Name
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Daughter Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter your Daughter name" : null,
                    ),

                   SizedBox(height: 15),


                    /// Mobile Number
                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,maxLength: 10,
                      decoration: InputDecoration(
                        labelText: "Daughter Mobile Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter Daughter's mobile number" : null,
                    ),

                    SizedBox(height: 15),

                    /// Amount
                    TextFormField(
                      controller: banknameController,
                      decoration: InputDecoration(
                        labelText: "Bank name",
                        // prefixText: "₹ ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) =>
                      value!.isEmpty ? "Enter Bank name" : null,
                    ),

                    SizedBox(height: 15),

                    /// Message
                    TextFormField(
                      controller: accnoController,
                      // maxLines: 3,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Account Number",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ), validator: (value) =>
                    value!.isEmpty ? "Enter Account number" : null,
                    ),

                    SizedBox(height: 15),

                    /// Message
                    TextFormField(
                      controller: accifscController,
                      // maxLines: 3,
                      decoration: InputDecoration(
                        labelText: "Account IFSC code",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ), validator: (value) =>
                    value!.isEmpty ? "Enter Bank IFSC code" : null,
                    ),

                    SizedBox(height: 15),
                    Text("starts with.."),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: suggestedAmounts.map((amount) {
                        return Obx(
                              () => ChoiceChip(
                            label: Text("₹$amount"),
                            selected: selectedAmount.value == amount,
                            onSelected: (_) {
                              selectedAmount.value = amount;
                              amountController.text = amount.toString();
                            },
                            selectedColor: Get.theme.colorScheme.primary,
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selectedAmount.value == amount
                                  ? Colors.white
                                  : Get.theme.colorScheme.onSurface,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 25),

                    /// Donate Button
                    isload==true?CircularProgressIndicator():SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async{
                            setState(() {
                              isload=true;
                            });

                            final payAmount = selectedAmount.value;
                            print("Proceed to pay ₹$payAmount");
                            // startUpiPayment(payAmount);
                                if (_formKey.currentState!.validate()) {
                                  await phonePeAuthController.startTransaction(payAmount);

                                  if(phonePeAuthController.paymentsuccess.value.toString()=="1"){
                                    await phonePeAuthController.uploadPaymentData( amount: payAmount.toString(), orderId: phonePeAuthController.orderid.toString(), transactionId: phonePeAuthController.orderid.value.toString(), status: phonePeAuthController.paymentstatus.value.toString(),aadhar: authcontroller.usermodel.value?.aadhar.toString()??"",screenshotPhoto: '', mop: 'kanyadaan');
                                    await paymentsController.fetchPayments(memberId: authcontroller.usermodel.value?.id.toString()??"");
                                    await controller.addKanyadaan(
                                        authcontroller.usermodel.value?.id.toString()??"",
                                        nameController.text,
                                        mobileController.text,
                                        banknameController.text,
                                        accnoController.text,
                                        accifscController.text,context);
                                    SharedPreferences prefs= await SharedPreferences.getInstance();
                                    var u= await prefs.getString("username");
                                    var p= await prefs.getString("password");
                                    await authcontroller.userLogintemp(aadhar: u.toString(), password: p.toString());
                                    Get.back();
                                  }

                                }
                            //
                            // await controller.addDonationSimple();
                            setState(() {
                              isload=false;
                            });
                            // Navigator.pop(context);

                          },
                        child: Text(
                          "Register Now",
                          style: TextStyle(
                            fontSize: 16,color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // if(authcontroller.enablerole.toString()=="1"){
    //   // if (authcontroller.adminData.value?.is_emergency.toString() == "1") {
    //   //   emergencyController.isActive.value = true;
    //   // }else{
    //     emergencyController.isActive.value = false;
    //   // }
    // }else{
    if(authcontroller.enablerole.toString()=="1"){
      authcontroller.usermodel.value=null;
    }else{
      authcontroller.adminData.value=null;
    }
      if (authcontroller.usermodel.value?.is_emergency.toString() == "1") {
        emergencyController.isActive.value = true;
      }else{
        emergencyController.isActive.value = false;
      // }
    }
      if (authcontroller.usermodel.value?.is_emergency.toString() == "1") {
        emergencyController.isActive.value = true;
      }else{
        emergencyController.isActive.value = false;
      }
    // });
  }

  @override
  Widget build(BuildContext context) {
    // if(authcontroller.usermodel.value?.is_emergency.toString()=="1"){
    //   emergencyController.isActive.value=true;
    // }
    return PopScope(
      canPop: false, // 🔥 VERY IMPORTANT
      onPopInvoked: (didPop) async {
        if (didPop) return;

        final shouldExit = await onWillPop();
        if (shouldExit) {
          Get.back(); // closes app / page
        }
      },
      child: Scaffold(
        bottomNavigationBar: _mobileBottomNav(context),
        floatingActionButton: SizedBox(
          height: 55,
          child: FloatingActionButton.extended(
            onPressed: () {
              showDonateDialog(context);
            },
            backgroundColor: Colors.pinkAccent,
            elevation: 8,
            icon: Icon(Icons.favorite, color: Colors.white),
            label: Text(
              "Donate Now\nअभी दान करें",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.right,

        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWeb = constraints.maxWidth >= 1000;
            return _bodyByIndex(context, isWeb);
          },
        ),
      ),
    );
  }
}

// ================= PREVIEW =================
class BannerPreview extends StatelessWidget {
  final String image;
  final String tag;

  const BannerPreview({super.key, required this.image, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.network(image, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
