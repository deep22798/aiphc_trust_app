import 'package:aiphc/controllers/screens/process_rules.dart';
import 'package:aiphc/controllers/theme/theme_controller.dart';
import 'package:aiphc/utils/Appconstants.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class ProcessRules extends StatelessWidget {
  const ProcessRules({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final processController = Get.put(ProcessController());

    return Obx(() {
      final isDark = themeController.isDark.value;
      final theme = Theme.of(context);

      return Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        // drawer: Drawer(),
        appBar: CustomeAppBar(title: "Process/Rules"),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            return CustomScrollView(
              slivers: [
                // 🔶 HEADER (SCROLLS & HIDES COMPLETELY)
                SliverAppBar(
                  expandedHeight: isDesktop ? 420 : 220,
                  pinned: false,
                  floating: false,
                  toolbarHeight: 0, // ✅ IMPORTANT
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,

                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        Image.asset(
                          Appconstants.loginbackground,
                          fit: BoxFit.cover,
                        ),

                        // Overlay
                        Container(
                          color: Colors.black.withOpacity(
                            isDark ? 0.65 : 0.45,
                          ),
                        ),

                        // Header Text
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'प्रक्रिया / निर्देश',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Rules',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),

                /// 🔶 REGISTER BUTTON (Theme Safe)
                SliverToBoxAdapter(
                  child: Center(
                    child: MaterialButton(
                      onPressed: () {},
                      color: theme.colorScheme.primary,
                      textColor: theme.colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "अभी पंजीकरण करें (Register Now)",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                // 🔶 CONTENT (TAKES OVER AFTER HEADER DISAPPEARS)

                SliverFillRemaining(
                  hasScrollBody: false,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                    child: Container(
                      color: theme.cardColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 260 : 20,
                        vertical: 30,
                      ),
                      child: Obx(() {

                        // Loader
                        if (processController.bannerloading.value) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // Empty state
                        if (processController.processrules.isEmpty) {
                          return Center(
                            child: Text(
                              'कोई नियम उपलब्ध नहीं है',textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                          );
                        }

                        // HTML Rules
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Html(
                                data: processController.processrules.reversed.first.description ?? '',
                                style: {
                                  "body": Style(
                                    margin: Margins.zero,
                                    padding: HtmlPaddings.zero,
                                    textAlign: TextAlign.center,
                                    color: theme.textTheme.bodyMedium?.color,
                                    fontSize: FontSize(18),
                                    lineHeight: const LineHeight(1.6),
                                  ),
                                  "h1": Style(
                                    fontSize: FontSize(22),
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    color: theme.textTheme.titleLarge?.color,
                                  ),"h2": Style(
                                    fontSize: FontSize(22),
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    color: theme.textTheme.titleLarge?.color,
                                  )
                                  ,"span": Style(
                                    fontSize: FontSize(22),
                                    fontWeight: FontWeight.bold,
                                    textAlign: TextAlign.center,
                                    color: theme.textTheme.titleLarge?.color,
                                  ),

                                  "p": Style(
                                    fontSize: FontSize(16),
                                    textAlign: TextAlign.justify,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                },
                              ),
                            ),
                          ],
                        );

                      }),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
