import 'package:aiphc/model/membermodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditMemberDetails extends StatefulWidget {
  final MemberModel member;

  const EditMemberDetails({super.key, required this.member});

  @override
  State<EditMemberDetails> createState() => _EditMemberDetailsState();
}

class _EditMemberDetailsState extends State<EditMemberDetails> {
  final _formKey = GlobalKey<FormState>();

  // ================= CONTROLLERS =================
  late TextEditingController name;
  late TextEditingController gender;
  late TextEditingController birthday;
  late TextEditingController fatherHusband;
  late TextEditingController aadhar;
  late TextEditingController mobile;
  late TextEditingController email;
  late TextEditingController address;
  late TextEditingController block;
  late TextEditingController district;
  late TextEditingController state;
  late TextEditingController category;
  late TextEditingController inService;
  late TextEditingController occupation;
  late TextEditingController department;
  late TextEditingController dlNo;
  late TextEditingController nomineeName;
  late TextEditingController nomineeRelation;
  late TextEditingController nomineeMobile;
  late TextEditingController bankName;
  late TextEditingController ifsc;
  late TextEditingController account;
  late TextEditingController autoPay;
  late TextEditingController subscriptionId;
  late TextEditingController driverType;
  late TextEditingController description;

  int status = 1;
  int featured = 0;
  int announcement = 0;
  int locked = 0;

  @override
  void initState() {
    super.initState();
    final m = widget.member;

    name = TextEditingController(text: m.name);
    gender = TextEditingController(text: m.gender);
    birthday = TextEditingController(text: m.birthday);
    fatherHusband = TextEditingController(text: m.fatherHusband);
    aadhar = TextEditingController(text: m.aadhar);
    mobile = TextEditingController(text: m.mobile);
    email = TextEditingController(text: m.email);
    address = TextEditingController(text: m.permanentAddress);
    block = TextEditingController(text: m.block);
    district = TextEditingController(text: m.district.toString());
    state = TextEditingController(text: m.state.toString());
    category = TextEditingController(text: m.category.toString());
    inService = TextEditingController(text: m.inService);
    occupation = TextEditingController(text: m.occupation);
    department = TextEditingController(text: m.department);
    dlNo = TextEditingController(text: m.dlNo);
    nomineeName = TextEditingController(text: m.nomineeName);
    nomineeRelation = TextEditingController(text: m.nomineeRelationship);
    nomineeMobile = TextEditingController(text: m.nomineeMobileNo);
    bankName = TextEditingController(text: m.bankName);
    ifsc = TextEditingController(text: m.ifscCode);
    account = TextEditingController(text: m.accountNo);
    autoPay = TextEditingController(text: m.autoPayStatus);
    subscriptionId = TextEditingController(text: m.subscriptionId);
    driverType = TextEditingController(text: m.driverType);
    description = TextEditingController(text: m.description);

    status = m.status;
    featured = m.featured;
    announcement = m.announcement;
    locked = m.locked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Member"),
        actions: [
          TextButton(
            onPressed: _saveMember,
            child: const Text("SAVE",
                style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _section("Personal Details", [
                _field("Name", name),
                _field("Gender", gender),
                _field("Date of Birth", birthday),
                _field("Father / Husband", fatherHusband),
                _field("Aadhaar", aadhar,
                    keyboard: TextInputType.number),
              ]),
              _section("Contact Details", [
                _field("Mobile", mobile,
                    keyboard: TextInputType.phone),
                _field("Email", email,
                    keyboard: TextInputType.emailAddress),
                _field("Permanent Address", address, maxLines: 2),
                _field("Block", block),
                _field("District", district),
                _field("State", state),
              ]),
              _section("Professional Details", [
                _field("Category", category),
                _field("In Service", inService),
                _field("Occupation", occupation),
                _field("Department", department),
                _field("Driver Type", driverType),
                _field("DL Number", dlNo),
              ]),
              _section("Nominee Details", [
                _field("Nominee Name", nomineeName),
                _field("Relationship", nomineeRelation),
                _field("Nominee Mobile", nomineeMobile,
                    keyboard: TextInputType.phone),
              ]),
              _section("Bank Details", [
                _field("Bank Name", bankName),
                _field("IFSC Code", ifsc),
                _field("Account Number", account),
                _field("Auto Pay Status", autoPay),
                _field("Subscription ID", subscriptionId),
              ]),
              _section("System Flags", [
                _switch("Active Status", status, (v) => setState(() => status = v)),
                _switch("Featured", featured, (v) => setState(() => featured = v)),
                _switch("Announcement", announcement, (v) => setState(() => announcement = v)),
                _switch("Locked", locked, (v) => setState(() => locked = v)),
              ]),
              _section("Description", [
                _field("Notes", description, maxLines: 3),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI HELPERS =================
  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _switch(String label, int value, Function(int) onChanged) {
    return SwitchListTile(
      value: value == 1,
      onChanged: (v) => onChanged(v ? 1 : 0),
      title: Text(label),
    );
  }

  // ================= SAVE =================
  void _saveMember() {
    if (!_formKey.currentState!.validate()) return;

    // 👉 HERE you will call UPDATE API later
    // For now just close screen
    Get.back();

    Get.snackbar(
      "Success",
      "Member updated successfully",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
