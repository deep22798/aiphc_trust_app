import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class supportquries extends StatelessWidget {
   supportquries({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Globalcontroller());
    final auth = Get.find<AuthController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Support Queries'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),

      body: Obx(() {
        if (controller.contactLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (auth.enablerole==1?controller.supportquries.isEmpty: controller.supportquries.where((s)=>s.id.toString()==auth.usermodel.value?.id.toString()).length<1) {
          return Center(
            child: Text(
              'कोई सहायता अनुरोध उपलब्ध नहीं है',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(

          padding: const EdgeInsets.all(16),
          itemCount:auth.enablerole==2? controller.supportquries.where((s)=>s.id.toString()==auth.usermodel.value?.id.toString()).length:controller.supportquries.length,
          itemBuilder: (context, index) {
            final item =auth.enablerole==1? controller.supportquries[index]: controller.supportquries.where((s)=>s.id.toString()==auth.usermodel.value?.id.toString()).toList()[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(18),

                // ⭐ Better contrast in dark & light
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 HEADER (Avatar + Name + Email)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.15),
                        child: Icon(
                          Icons.person_outline,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.email,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🔹 MESSAGE BUBBLE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(
                        isDark ? 0.15 : 0.08,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      item.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.6,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// 🔹 FOOTER (Status / Info – optional)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.help_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'User Query',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
