import 'dart:ui';
import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/screens/memberscontroller.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:aiphc/view/screens/members/memberdetails.dart';
import 'package:aiphc/view/screens/payments.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Members extends StatefulWidget {
  const Members({super.key});

  @override
  State<Members> createState() => _MembersState();
}

class _MembersState extends State<Members> {
  final MembersController controller = Get.put(MembersController());
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final RxInt statusFilter = 0.obs; // 0=All, 1=Active, 2=Inactive
  RxInt autoPayFilter = 0.obs; // 0=All, 1=Active, 2=Inactive

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF020617), const Color(0xFF0F172A)]
                : [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(()=>Column(
              children: [
                _header(),
                // authController.enablerole.value.toString()!="1"?SizedBox():_searchBar(),
                _searchBar(),
                authController.enablerole.value.toString()!="1"?SizedBox():_statsRow(),
                authController.enablerole.value.toString()!="1"?SizedBox(): _filtersAndTotal(),
                Text("Total Members: ${_filteredMembers().length}",style: TextStyle(fontWeight: FontWeight.bold),),SizedBox(height: 10,),
                Expanded(child: _memberList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _header() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          const SizedBox(width: 8),
          const Text(
            "Members (सदस्य)",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(Icons.groups),
        ],
      ),
    );
  }

  // ================= SEARCH BAR =================
  Widget _searchBar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 12,
            ),
          ],
        ),
        child: TextField(
          controller: searchController,
          onChanged: (v) => searchQuery.value = v,
          decoration: InputDecoration(
            hintText: "Search by ID, Name, Phone",
            prefixIcon: const Icon(Icons.search),
            suffixIcon: Obx(() => searchQuery.value.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                searchController.clear();
                searchQuery.value = '';
              },
            )
                : const SizedBox.shrink()),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  // ================= FILTER + TOTAL =================
  Widget _filtersAndTotal() {
    return Obx(() {
      final filtered = _filteredMembers();

      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Row(
          children: [
            _filterChip("All", 0),
            const SizedBox(width: 8),
            _filterChip("Active", 1),
            const SizedBox(width: 8),
            _filterChip("Inactive", 2),
            const Spacer(),
            Text(
              "Total: ${filtered.length}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _filterChip(String label, int value) {
    return Obx(() {
      return ChoiceChip(
        label: Text(label),
        selected: statusFilter.value == value,
        selectedColor: Colors.green.withOpacity(0.2),
        onSelected: (_) => statusFilter.value = value,
      );
    });
  }

  // ================= MEMBER LIST =================
  Widget _memberList() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      if (controller.bannerloading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final filtered = _filteredMembers();

      if (filtered.isEmpty) {
        return const Center(child: Text("No members found"));
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filtered.length,
        itemBuilder: (_, index) {
          final m = filtered[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: theme.cardColor,
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.6)
                      : Colors.black.withOpacity(0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _avatar(m.userPhoto),
                  const SizedBox(width: 10),
                  Expanded(child: _memberInfo(m)),
                ],
              ),
            ),
          );
        },
      );
    });
  }

  // ================= FILTER LOGIC (SINGLE SOURCE OF TRUTH) =================
  // List<dynamic> _filteredMembers() {
  //   final query = searchQuery.value.toLowerCase();
  //
  //   return controller.members.where((m) {
  //     final matchesSearch =
  //         m.name.toLowerCase().contains(query) ||
  //             m.mobile.toLowerCase().contains(query) ||
  //             m.id.toString().contains(query);
  //
  //     final matchesStatus = statusFilter.value == 0 ||
  //         (statusFilter.value == 1 && m.status == 1) ||
  //         (statusFilter.value == 2 && m.status != 1);
  //
  //     return matchesSearch && matchesStatus;
  //   }).toList();
  // }

  List<dynamic> _filteredMembers() {
    final query = searchQuery.value.toLowerCase();

    return controller.members.where((m) {
      final idString = m.id.toString();
      final fullId = "aipvst$idString";

      final matchesSearch =
          m.name.toLowerCase().contains(query) ||
              m.mobile.toLowerCase().contains(query) ||
              idString.contains(query) ||
              fullId.contains(query);

      final matchesStatus = statusFilter.value == 0 ||
          (statusFilter.value == 1 && m.status == 1) ||
          (statusFilter.value == 2 && m.status != 1);

      final isAutoPayActive = m.autoPayStatus.toString() == "1";

      final matchesAutoPay = autoPayFilter.value == 0 ||
          (autoPayFilter.value == 1 && isAutoPayActive) ||
          (autoPayFilter.value == 2 && !isAutoPayActive);

      return matchesSearch && matchesStatus && matchesAutoPay;
    }).toList();
  }

  Map<String, int> _memberStats() {
    final all = controller.members;

    int total = all.length;

    // int active = all.where((m) => m.status == 1).length;
    // int inactive = all.where((m) => m.status != 1).length;

    int autopayactive = all.where((m) => m.autoPayStatus.toString()=="1").length;

    print("dsfkjbdsjkfsd :${autopayactive.toString()}");
    int autopayoff = total - autopayactive;

    print("dsfkjbdsjkfsd :${autopayoff.toString()}");


    return {
      "total": total,
      "active": autopayactive,
      "inactive": autopayoff,
      // "autopayActive": autopayActive,
      // "autopayOff": autopayOff,
    };
  }

  Widget _statsRow() {
    return Obx(() {
      final stats = _memberStats();

      return Container(
decoration: BoxDecoration(color: Colors.green.shade200),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("Autopay Status"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(child: _statCard("Total", stats["total"]??0, Colors.blue, 0)),
                    Expanded(child: _statCard("Active", stats["active"]??0, Colors.green, 1)),
                    Expanded(child: _statCard("Inactive", stats["inactive"]??0, Colors.red, 2)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _statCard(String title, int value, Color color, int filterValue) {
    return Obx(() {
      final isSelected = autoPayFilter.value == filterValue;

      return GestureDetector(
        onTap: () {
          autoPayFilter.value = filterValue;
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(isSelected ? 1 : 0.7),
                color.withOpacity(isSelected ? 0.8 : 0.4),
              ],
            ),

            // 🔥 Selected border
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,

            // 🔥 Shadow highlight
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? color.withOpacity(0.6)
                    : Colors.black.withOpacity(0.1),
                blurRadius: isSelected ? 12 : 4,
                offset: const Offset(0, 4),
              )
            ],
          ),

          // 🔥 Slight zoom effect
          transform: Matrix4.identity()
            ..scale(isSelected ? 1.05 : 1.0),

          child: Column(
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    });
  }

  // ================= AVATAR =================
  Widget _avatar(String photo) {
    return GestureDetector(
      onTap: () {
        if (photo.isNotEmpty) {
          showDialog(
            context: context,
            builder: (_) => Dialog(
              backgroundColor: Colors.transparent,
              child: GestureDetector(
                onTap: () => Navigator.pop(context), // close on tap
                child: InteractiveViewer(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      "${ServerAssets.users}$photo",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.green.withOpacity(0.2),
        backgroundImage: photo.isNotEmpty
            ? NetworkImage("${ServerAssets.users}$photo")
            : null,
        child: photo.isEmpty
            ? const Icon(Icons.person, size: 32, color: Colors.green)
            : null,
      ),
    );
  }

  // ================= MEMBER INFO =================
  Widget _memberInfo(dynamic m) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
               "Name: "+ m.name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _statusBadge(m.status),
                authController.enablerole.toString()!="1"?SizedBox(): IconButton(onPressed: ()=>Get.to(()=>EditMemberDetails(member: m)), icon: Icon(Icons.edit))
              ],
            ),
          ],
        ),
        // authController.enablerole.toString()!="1"?SizedBox():const SizedBox(height: 4),
        authController.enablerole.toString()!="1"?SizedBox():Text("Autopay status: ${m.autoPayStatus.toString()==""||m.autoPayStatus.toString()=="0"||m.autoPayStatus==null||m.autoPayStatus.toString()=="null"?"NO":"Active"}",
            style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        // const SizedBox(height: 4),
        const SizedBox(height: 4),
        Text("F/H. name: ${m.fatherHusband}",
            style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        const SizedBox(height: 4),
        Text("ID: AIPVST${m.id}",
            style:
            const TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),

        const SizedBox(height: 4),

        // _infoRow(Icons.family_restroom, m.fatherHusband),
        _infoRow(Icons.work,"Category: ${m.category_name}"),
        _infoRow(Icons.work,"Occupation: ${m.occupation}"),
        _infoRow(Icons.location_on, "State: ${m.state_name}"),
        // _infoRow(Icons.location_on, "District: ${m.district_name}"),
        // _infoRow(Icons.call, m.mobile),
        _infoRow(
          Icons.calendar_today,
          _formatDate(m.dateCreated),
        ),
        authController.enablerole.value.toString()!=1?SizedBox():MaterialButton(onPressed: (){
Get.to(()=>Payments(member_id: m.id.toString(),));
        },child: Text("Show Payments",style: TextStyle(color: Colors.white),),color: Colors.green.shade800,)

      ],
    );
  }
  String _formatDate(String date) {
    final dt = DateTime.parse(date);
    return "${dt.day.toString().padLeft(2, '0')}-"
        "${dt.month.toString().padLeft(2, '0')}-"
        "${dt.year}";
  }

  Widget _infoRow(IconData icon, String text) {
    if (text.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.green),
          const SizedBox(width: 6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  // ================= STATUS BADGE =================
  Widget _statusBadge(int status) {
    final active = status == 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active
            ? Colors.green.withOpacity(0.15)
            : Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? "ACTIVE" : "INACTIVE",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: active ? Colors.green : Colors.red,
        ),
      ),
    );
  }
}
