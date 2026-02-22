import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: CustomeAppBar(title: 'Support Queries\nसमर्थन प्रश्न',),

      /// ✅ ADDED FLOATING BUTTON (NO EXISTING CODE REMOVED)
      floatingActionButton: Obx(()=>auth.enablerole.value.toString()=="1"?SizedBox():FloatingActionButton.extended(
          icon: const Icon(Icons.add),
          label: const Text("Add a Query"),
          onPressed: () {
            Get.bottomSheet(_AddQuerySheet(),);
          },
        ),
      ),

      body: Obx(() {
        if (controller.contactLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.primary,
            ),
          );
        }

        if (auth.enablerole == 1
            ? controller.supportquries.isEmpty
            : controller.supportquries
            .where((s) =>
        s.memberid.toString() ==
            auth.usermodel.value?.id.toString())
            .length <
            1) {
          return Center(
            child: Text(
              'कोई सहायता अनुरोध उपलब्ध नहीं है',
              style: theme.textTheme.bodyMedium,
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: auth.enablerole == 2
              ? controller.supportquries
              .where((s) =>
          s.memberid.toString() ==
              auth.usermodel.value?.id.toString())
              .length
              : controller.supportquries.length,
          itemBuilder: (context, index) {
            final item = auth.enablerole == 1
                ? controller.supportquries[index]
                : controller.supportquries
                .where((s) =>
            s.memberid.toString() ==
                auth.usermodel.value?.id.toString())
                .toList()[index];

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
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
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                color: theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ───────── HEADER ─────────
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.15),
                            child: Icon(
                              Icons.person,
                              size: 28,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// NAME
                                Text(
                                  item.name ?? '',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                /// EMAIL
                                GestureDetector(
                                  onTap: () => controller.openEmail(
                                    email: item.email ?? '',
                                    subjectPrefix: "Regarding your query",
                                    body: "Hello ${item.name},",
                                  ),
                                  onLongPress: () {
                                    Clipboard.setData(
                                      ClipboardData(text: item.email ?? ''),
                                    );
                                    Get.snackbar("Copied", "Email copied");
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.mail_outline,
                                          size: 16,
                                          color: theme.colorScheme.primary),
                                      const SizedBox(width: 6),
                                      Flexible(
                                        child: Text(
                                          item.email ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: theme.colorScheme.primary,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),


                  Obx(()=>auth.enablerole.value.toString()!="1"?SizedBox():const SizedBox(height: 14)),

                      /// ───────── ACTION BUTTONS ─────────
                      Obx(()=>auth.enablerole.value.toString()!="1"?SizedBox(): Row(
                          children: [

                            /// CALL
                            _ActionButton(
                              icon: Icons.call,
                              label: "Call",
                              color: Colors.green,
                              onTap: () => controller.openDialer(item.mobileNo ?? ''),
                              onLongPress: () {
                                Clipboard.setData(
                                    ClipboardData(text: item.mobileNo ?? ''));
                                Get.snackbar("Copied", "Mobile number copied");
                              },
                            ),

                            const SizedBox(width: 10),

                            /// WHATSAPP
                            _ActionButton(
                              icon: Icons.call,
                              label: "WhatsApp",
                              color: Colors.green.shade700,
                              onTap: () =>
                                  controller.openWhatsApp(item.mobileNo ?? ''),
                            ),

                            const SizedBox(width: 10),

                            /// EMAIL
                            _ActionButton(
                              icon: Icons.email,
                              label: "Email",
                              color: theme.colorScheme.primary,
                              onTap: () => controller.openEmail(
                                email: item.email ?? '',
                                subjectPrefix: "Support",
                                body: "Hello ${item.name},",
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// ───────── MESSAGE ─────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              theme.colorScheme.primary.withOpacity(0.12),
                              theme.colorScheme.primary.withOpacity(0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          item.message ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// ───────── FOOTER ─────────
                      Obx(() => auth.enablerole.value.toString() == "1"
                          ? Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.help_outline,
                                size: 16,
                                color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              "User Query",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                          : const SizedBox()),
                    ],
                  ),
                ),
              )
            );
          },
        );
      }),
    );
  }

}
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _AddQuerySheet extends StatelessWidget {
  final name = TextEditingController();
  final email = TextEditingController();
  final mobile = TextEditingController();
  final subject = TextEditingController();
  final message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<Globalcontroller>();
    final auth = Get.find<AuthController>();
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ───── DRAG HANDLE ─────
              Center(
                child: Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// ───── HEADER ─────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary,
                          theme.colorScheme.primary.withOpacity(0.7),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.help_outline,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Add a Query",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              /// ───── FORM FIELDS ─────
              Obx(
                ()=>auth.enablerole.toString()!='2'?_ModernField(
                  controller: name,
                  label: "Full Name",
                  icon: Icons.person_outline,
                  keyboardType: TextInputType.name,
                ):SizedBox(),
              ),

              const SizedBox(height: 18),

              _ModernField(
                controller: email,
                label: "Email Address",
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

        Obx(
              ()=>auth.enablerole.toString()!='2'?const SizedBox(height: 18):SizedBox()),

        Obx(
              ()=>auth.enablerole.toString()!='2'?_ModernField(
                controller: mobile,
                label: "Mobile Number",
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.number,
                maxLength: 10,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ):SizedBox()),

              const SizedBox(height: 18),

              _ModernField(
                controller: subject,
                label: "Subject",
                icon: Icons.subject_outlined,
              ),

              const SizedBox(height: 18),

              _ModernField(
                controller: message,
                label: "Message",
                icon: Icons.message_outlined,
                maxLines: 4,
              ),

              const SizedBox(height: 32),

              /// ───── SUBMIT BUTTON ─────
              Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: controller.contactLoading.value
                      ? null
                      : () async{
                    controller.addQuery(
                      name:auth.enablerole.toString()!='2'? name.text.trim():auth.usermodel.value?.name.toString()??"",
                      email: email.text.trim(),
                      mobile: auth.enablerole.toString()!='2'? mobile.text.trim():auth.usermodel.value?.mobile.toString()??"",
                      subject: subject.text.trim(),
                      message: message.text.trim(),memberid: auth.usermodel.value?.id.toString()??""
                    );
                    Get.back();
                    await controller.safeFetchAll();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: controller.contactLoading.value
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Submit Query",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
class _ModernField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;

  const _ModernField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.45),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// import 'package:aiphc/controllers/auth/login.dart';
// import 'package:aiphc/controllers/globalcontroller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class supportquries extends StatelessWidget {
//    supportquries({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(Globalcontroller());
//     final auth = Get.find<AuthController>();
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Scaffold(
//       backgroundColor: theme.scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: const Text('Support Queries'),
//         backgroundColor: theme.colorScheme.primary,
//         foregroundColor: theme.colorScheme.onPrimary,
//       ),
//
//       body: Obx(() {
//         if (controller.contactLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(
//               color: theme.colorScheme.primary,
//             ),
//           );
//         }
//
//         if (auth.enablerole==1?controller.supportquries.isEmpty: controller.supportquries.where((s)=>s.id.toString()==auth.usermodel.value?.id.toString()).length<1) {
//           return Center(
//             child: Text(
//               'कोई सहायता अनुरोध उपलब्ध नहीं है',
//               style: theme.textTheme.bodyMedium,
//             ),
//           );
//         }
//
//         return ListView.builder(
//
//           padding: const EdgeInsets.all(16),
//           itemCount:auth.enablerole==2? controller.supportquries.where((s)=>s.id.toString()==auth.usermodel.value?.id.toString()).length:controller.supportquries.length,
//           itemBuilder: (context, index) {
//             final item =auth.enablerole==1? controller.supportquries[index]: controller.supportquries.where((s)=>s.id.toString()==auth.usermodel.value?.id.toString()).toList()[index];
//             return Container(
//               margin: const EdgeInsets.only(bottom: 16),
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: theme.cardColor,
//                 borderRadius: BorderRadius.circular(18),
//
//                 // ⭐ Better contrast in dark & light
//                 border: Border.all(
//                   color: isDark
//                       ? Colors.white.withOpacity(0.08)
//                       : Colors.black.withOpacity(0.06),
//                 ),
//
//                 boxShadow: isDark
//                     ? []
//                     : [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 10,
//                     offset: const Offset(0, 6),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   /// 🔹 HEADER (Avatar + Name + Email)
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 22,
//                         backgroundColor:
//                         theme.colorScheme.primary.withOpacity(0.15),
//                         child: Icon(
//                           Icons.person_outline,
//                           color: theme.colorScheme.primary,
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               item.name,
//                               style: theme.textTheme.titleMedium?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                               ),
//                             ),
//                             const SizedBox(height: 2),
//                             Text(
//                               item.email,
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: theme.colorScheme.onSurface
//                                     .withOpacity(0.7),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   /// 🔹 MESSAGE BUBBLE
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(14),
//                     decoration: BoxDecoration(
//                       color: theme.colorScheme.primary.withOpacity(
//                         isDark ? 0.15 : 0.08,
//                       ),
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: Text(
//                       item.message,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         height: 1.6,
//                       ),
//                     ),
//                   ),
//
//                   const SizedBox(height: 10),
//
//                   /// 🔹 FOOTER (Status / Info – optional)
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Icon(
//                         Icons.help_outline,
//                         size: 16,
//                         color: theme.colorScheme.primary,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         'User Query',
//                         style: theme.textTheme.bodySmall?.copyWith(
//                           color: theme.colorScheme.primary,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       }),
//     );
//   }
// }
