import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: Obx(() {
        final user = controller.usermodel.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Column(
            children: [

              /// 🔹 PROFILE HEADER
              _profileHeader(context, user),

              const SizedBox(height: 80),

              _sectionTitle(context, 'Personal Information'),
              _infoCard(context, [
                _infoRow(context, Icons.badge, 'Aadhaar', user.aadhar),
                _infoRow(context, Icons.person, 'Father / Husband', user.fatherHusband),
                _infoRow(context, Icons.cake, 'Date of Birth', user.birthday),
                _infoRow(context, Icons.wc, 'Gender', user.gender),
                _infoRow(context, Icons.email, 'Email', user.email),
                _infoRow(context, Icons.work, 'Occupation', user.occupation),
                _infoRow(context, Icons.apartment, 'Department', user.department),
                _infoRow(context, Icons.location_on, 'Address', user.permAddress),
              ]),

              _sectionTitle(context, 'Nominee Details'),
              _infoCard(context, [
                _infoRow(context, Icons.person_outline, 'Name', user.nomineeName),
                _infoRow(context, Icons.people, 'Relationship', user.nomineeRelationship),
                _infoRow(context, Icons.phone, 'Mobile', user.nomineeMobileNo),
              ]),

              _sectionTitle(context, 'Bank Information'),
              _infoCard(context, [
                _infoRow(context, Icons.account_balance, 'Bank Name', user.bankName),
                _infoRow(context, Icons.credit_card, 'Account No', user.accountNo),
                _infoRow(context, Icons.code, 'IFSC Code', user.ifscCode),
              ]),

              _sectionTitle(context, 'Account Status'),
              _infoCard(context, [
                _infoRow(context, Icons.verified_user, 'Status', user.status),
                _infoRow(context, Icons.lock, 'Locked', user.locked),
                _infoRow(context, Icons.autorenew, 'Autopay', user.autopayStatus),
                _infoRow(context, Icons.calendar_today, 'Joined On', user.dateCreated),
              ]),

              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // ================= HEADER =================

  Widget _profileHeader(BuildContext context, dynamic user) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [

        /// COVER
        Container(
          height: 220,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.primaryColor.withOpacity(0.7),
              ],
            ),
          ),
        ),

        /// PROFILE CARD
        Positioned(
          bottom: -60,
          left: 16,
          right: 16,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: theme.scaffoldBackgroundColor,
                    backgroundImage: user.userPhoto.isNotEmpty
                        ? NetworkImage(ServerAssets.users + user.userPhoto)
                        : null,
                    child: user.userPhoto.isEmpty
                        ? Icon(Icons.person, size: 50, color: theme.primaryColor)
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.mobile,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ================= UI HELPERS =================

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: children),
        ),
      ),
    );
  }

  Widget _infoRow(
      BuildContext context,
      IconData icon,
      String label,
      String value,
      ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: theme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isEmpty ? '-' : value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
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
