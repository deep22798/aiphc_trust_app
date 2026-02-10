import 'dart:io';
import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/controllers/globalcontroller.dart';
import 'package:aiphc/controllers/phonepaycontroller.dart';
import 'package:aiphc/controllers/screens/memberscontroller.dart';
import 'package:aiphc/model/department.dart';
import 'package:aiphc/model/districtmodel.dart';
import 'package:aiphc/model/driverlistmodel.dart';
import 'package:aiphc/model/states.dart';
import 'package:aiphc/utils/Appconstants.dart';
import 'package:aiphc/view/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TransportRegistrationScreen extends StatefulWidget {
  TransportRegistrationScreen({super.key});

  @override
  State<TransportRegistrationScreen> createState() => _TransportRegistrationScreenState();
}

class _TransportRegistrationScreenState extends State<TransportRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final Globalcontroller globalcontroller = Get.find();

  final AuthController authController = Get.find();
  final MembersController membersController = Get.find();
  final PhonePeController phonePeAuthController = Get.find();



  // Controllers
  final TextEditingController nameC = TextEditingController();

  final TextEditingController aadhaarC = TextEditingController();

  final TextEditingController fatherC = TextEditingController();

  final TextEditingController dobC = TextEditingController();

  final TextEditingController ageC = TextEditingController();

  final TextEditingController mobileC = TextEditingController();

  final TextEditingController emailC = TextEditingController();

  final TextEditingController passwordC = TextEditingController();

  final TextEditingController dlC = TextEditingController();

  final TextEditingController occupationC = TextEditingController();

  final TextEditingController tehsilC = TextEditingController();

  final TextEditingController addressC = TextEditingController();

  final TextEditingController nomineeNameC = TextEditingController();

  final TextEditingController nomineeRelationC = TextEditingController();

  final TextEditingController nomineeMobileC = TextEditingController();

  final TextEditingController bankC = TextEditingController();

  final TextEditingController ifscC = TextEditingController();

  final TextEditingController accountC = TextEditingController();

  final RxInt progress = 10.obs;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    membersController.fetchDrivers();

    nameC.clear();
    aadhaarC.clear();
    fatherC.clear();
    dobC.clear();
    ageC.clear();
    mobileC.clear();
    emailC.clear();
    passwordC.clear();
    dlC.clear();
    occupationC.clear();
    tehsilC.clear();
    addressC.clear();
    nomineeNameC.clear();
    nomineeRelationC.clear();
    nomineeMobileC.clear();
    bankC.clear();
    ifscC.clear();
    accountC.clear();

    // AuthController values
    authController.selectedCategory.value = "";
    authController.selectedServiceStatus.value = "";
    authController.selectedGender.value = "";
    authController.selecteddrivetype.value = "";
    authController.iagree.value = false;
    authController.selectedImage.value = null;
    authController.paymentScreenshot.value = null;

    // GlobalController values
    globalcontroller.selectedState.value = null;
    globalcontroller.selectedDistrict.value = null;
    globalcontroller.selectedDepartment.value = null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Get.isDarkMode;

    return Scaffold(
      appBar: CustomeAppBar(title: "Register for Transport"),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// HEADER
                Center(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      // TODO: Navigate to Driver Registration
                    },
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                            Colors.green.shade900,
                            Colors.green.shade700,
                            Colors.black,
                          ]
                              : [
                            Colors.green,
                            Colors.lightGreenAccent,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.35),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          /// ICON
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            child: const Icon(
                              Icons.directions_car_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),

                          const SizedBox(width: 16),

                          /// TEXT
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "परिवहन के लिए पंजीकरण",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Register as Transport",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ARROW
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white70,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


                // const SizedBox(height: 12),
                //
                // /// PROGRESS
                // Obx(() => LinearProgressIndicator(
                //   value: progress.value / 100,
                //   minHeight: 6,
                // )),

                const SizedBox(height: 20),

                _section("Basic Details"),
                _dropdown(
                  label: "Category (श्रेणी) *",
                  items: const [
                    "परिवहन (Transport)",
                  ],
                  selectedValue: authController.selectedCategory,
                ),




                // _dropdown(
                //   label: "Service Status (सेवा स्थिति) *",
                //   items: const [
                //     "In Service / सेवा में",
                //     "Retired / सेवानिवृत्त",
                //   ],
                //   selectedValue:  authController.selectedServiceStatus,
                // ),



                _text(nameC, "Full Name *"),
                _aadhaar(),

                _filePicker("Upload Your Photo *"),

                _row([
                  _text(fatherC, "Father / Husband Name *"),
                  _dobField("Date of Birth"),
                ]),

                _readOnly(ageC, "Age (Auto Calculated)"),

                _text(passwordC, "Password *", obscure: true),
                _textmobile(mobileC, "Mobile Number *",
                    type: TextInputType.phone),
                // _text(emailC, "Email *",
                //     type: TextInputType.emailAddress),

                _dropdownSimple(
                  "Gender *",
                  ["पुरुष (Male)", "महिला (Female)", "Other"],
                  authController.selectedGender,
                ),

                _text(dlC, "Driving License No. *"),
                _dropdownSimplefordrivertype(
                  "Driver Type *",
                  ["TR(Transport)", "NT - Non Transport"],
                  authController.selecteddrivetype,
                ),
                Obx(() => InkWell(
                  onTap: () => showMemberMultiSelect(),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: "Select Members",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      membersController.selectedMembers.isEmpty
                          ? "Tap to select members"
                          : membersController.selectedMembers
                          .map((e) => e.name)
                          .join(', '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )),
                //
                // Obx(() {
                //   if (membersController.isLoading.value) {
                //     return const CircularProgressIndicator();
                //   }
                //
                //   return DropdownButtonFormField<Member>(
                //     value: membersController.selectedMember.value,
                //     hint: const Text("Select Member"),
                //     items: membersController.drivers.map((member) {
                //       return DropdownMenuItem<Member>(
                //         value: member,
                //         child: Text(member.name),
                //       );
                //     }).toList(),
                //     onChanged: (value) {
                //       if (value != null) {
                //         membersController.selectMember(value);
                //       }
                //     },
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       contentPadding: const EdgeInsets.symmetric(
                //         horizontal: 12,
                //         vertical: 14,
                //       ),
                //     ),
                //   );
                // }),
                SizedBox(height: 10,),
                // _section("Department & Address"),
                //
                // Obx(() =>
                //     DropdownButtonFormField<DepartmentModel>(
                //       isExpanded: true,
                //       // ✅ MOST IMPORTANT
                //       decoration: const InputDecoration(
                //         labelText: "Department *",
                //       ),
                //       value: globalcontroller.selectedDepartment.value,
                //       items: departmentList
                //           .map(
                //             (e) =>
                //             DropdownMenuItem<DepartmentModel>(
                //               value: e,
                //               child: Text(
                //                 e.name,
                //                 maxLines: 1,
                //                 overflow: TextOverflow
                //                     .ellipsis, // ✅ prevent overflow
                //               ),
                //             ),
                //       )
                //           .toList(),
                //       onChanged: (v) {
                //         globalcontroller.selectedDepartment.value = v;
                //         progress.value = 50;
                //       },
                //       validator: (v) => v == null ? "Required" : null,
                //     )),

                SizedBox(height: 10,),
                Obx(() =>
                    DropdownButtonFormField<StateModel>(
                      decoration:
                      const InputDecoration(labelText: "State *"),
                      items: globalcontroller.states
                          .map((s) =>
                          DropdownMenuItem(
                            value: s,
                            child: Text(s.name),
                          ))
                          .toList(),
                      onChanged: (s) {
                        globalcontroller.selectedState.value = s;

                        // 🔴 IMPORTANT RESET
                        globalcontroller.selectedDistrict.value = null;
                        globalcontroller.districts.clear();

                        globalcontroller.fetchDistrictsByState(s!.id);
                      },

                      validator: (v) => v == null ? "Required" : null,
                    )),

                SizedBox(height: 10,),
                Obx(() => globalcontroller.selectedState.value == null
                    ? const SizedBox()
                    : DropdownButtonFormField<DistrictModel>(
                  value: globalcontroller.selectedDistrict.value,
                  decoration: const InputDecoration(labelText: "District *"),
                  items: globalcontroller.districts
                      .map(
                        (d) => DropdownMenuItem(
                      value: d,
                      child: Text(d.name),
                    ),
                  )
                      .toList(),
                  onChanged: (d) {
                    globalcontroller.selectedDistrict.value = d;
                  },
                  validator: (v) => v == null ? "Required" : null,
                )),


                SizedBox(height: 10,),
                _text(tehsilC, "Tehsil *"),
                _multi(addressC, "Permanent Address *"),

                _section("Nominee Details"),

                _text(nomineeNameC, "Nominee Name *"),
                _text(nomineeRelationC, "Relationship *"),
                _textmobile(nomineeMobileC, "Nominee Mobile *",
                    type: TextInputType.phone),

                // _section("Bank Details"),
                //
                // _text(bankC, "Bank Name *"),
                // _text(ifscC, "IFSC Code *"),
                // _text(accountC, "Account Number *",
                //     type: TextInputType.number),

                const SizedBox(height: 10),


                Obx(() =>
                    CheckboxListTile(
                      value: authController.iagree.value,
                      onChanged: (_) {
                        if (authController.iagree.value == false) {
                          authController.iagree.value = true;
                        } else {
                          authController.iagree.value = false;
                        }
                      },
                      title: const Text(
                          "मैनें ऑल इण्डिया पुलिस वित्तीय सहायता ट्रस्ट के नियमों व शर्तों को बेवसाइट पर ध्यान पूर्वक पढ़ा है और मैं सभी नियमों व शर्तों से सहमत हूँ। यदि में AIPVST द्वारा बनाए गये नियमों के तहत नियमित रूप से योगदान नहीं करता हूँ तो मेरे द्वारा नामांकित व्यक्ति किसी भी वित्तीय सहायता के लिये पात्र नहीं होगें। \n(I have carefully read the terms and conditions of the All India Police Vittiya Sahayata Trust on the website, and I agree to all the terms and conditions. If I do not contribute regularly as per the rules set by AIPVST, the nominee designated by me will not be eligible for any financial assistance.)"),
                    ),
                ),

                const SizedBox(height: 20),

                // SizedBox(
                //   width: double.infinity,
                //   height: 50,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       if (_formKey.currentState!.validate()) {
                //         // CALL API HERE
                //
                //         final inputFormat = DateFormat('dd-MM-yyyy');
                //         final outputFormat = DateFormat('yyyy-MM-dd');
                //
                //         DateTime dob = inputFormat.parse(dobC.text);
                //         String formattedDob = outputFormat.format(dob);
                //
                //         print("eflkneflnek :$formattedDob");
                //         print("eflkneflnek :${dobC.text}");
                //         _showPaymentPopup();
                //         // authController.registerDrivers(
                //         //     category: '3',
                //         //     inservice: authController.selectedServiceStatus.value.toString(),
                //         //     name: nameC.text,
                //         //     aadhar: aadhaarC.text,
                //         //     fatherHusband: fatherC.text,
                //         //     birthday: dobC.text,
                //         //     password: passwordC.text,
                //         //     mobile: mobileC.text,
                //         //     email: emailC?.text??"",
                //         //     dlNo: dlC.text,
                //         //     gender: authController.selectedGender.value,
                //         //     occupation: '',
                //         //     departmentId: globalcontroller.selectedDepartment.value?.name ?? "",
                //         //     stateId: globalcontroller.selectedState.value!.id.toString(),
                //         //     districtId: globalcontroller.selectedDistrict.value!.id.toString(),
                //         //     block: '',
                //         //     permAddress: addressC.text,
                //         //     nomineeName: nomineeNameC.text,
                //         //     nomineeRelation: nomineeRelationC.text,
                //         //     nomineeMobile: nomineeMobileC.text,
                //         //     bankName: '',
                //         //     ifscCode: '',
                //         //     accountNo: '', driver_type: authController.selecteddrivetype.value.toString()=="TR(Transport)"?"TR":"NT");
                //       }
                //     },
                //
                //     child: const Text(
                //       "Pay Now For Register",
                //       style: TextStyle(
                //           fontSize: 16, fontWeight: FontWeight.w700),
                //     ),
                //   ),
                // ),

                SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          final inputFormat = DateFormat('dd-MM-yyyy');
                          final outputFormat = DateFormat('yyyy-MM-dd');

                          DateTime dob = inputFormat.parse(dobC.text);
                          String formattedDob = outputFormat.format(dob);

                          _showPaymentPopup();
                        }
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: Get.isDarkMode
                                ? [
                              Colors.green.shade900,
                              Colors.green.shade600,
                            ]
                                : [
                              Colors.green,
                              Colors.lightGreenAccent,
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.45),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Pay Now & Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
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
  }


  void showMemberMultiSelect() {
    Get.bottomSheet(
      Container(
        height: 450,
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          children: [
            const Text(
              "Select Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: Obx(() => ListView(
                children: membersController.drivers.map((member) {
                  final isSelected = membersController.selectedMembers
                      .any((m) => m.id == member.id);

                  return CheckboxListTile(
                    title: Text(member.name),
                    value: isSelected,
                    onChanged: (_) {
                      membersController.toggleMember(member);
                    },
                  );
                }).toList(),
              )),
            ),

            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text("Done"),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentPopup() {
    Get.bottomSheet(
      SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Container(
            height: Get.height * 0.75,
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(26),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),

                /// DRAG HANDLE
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

                const SizedBox(height: 16),

                Text(
                  "Complete Payment",
                  style: Get.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                /// TABS
                TabBar(
                  indicatorColor: Get.theme.primaryColor,
                  labelColor: Get.theme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  tabs: const [
                    Tab(text: "QR Code"),
                    Tab(text: "Pay Now"),
                  ],
                ),

                const SizedBox(height: 10),

                /// TAB VIEWS
                Obx(()=> authController.isLoading.value==true?Center(child: Container(child: CircularProgressIndicator())): Expanded(
                  child: TabBarView(
                    children: [
                      _qrPaymentTab(),
                      _upiPaymentTab(),
                    ],
                  ),
                ),),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _qrPaymentTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// QR IMAGE
          Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Get.theme.primaryColor),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                "${Appconstants.qr}", // 🔥 YOUR QR
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            "Scan QR & Pay",
            style: Get.textTheme.bodyLarge
                ?.copyWith(fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 20),

          /// UPLOAD SCREENSHOT
          _filePickerqr("Upload Payment Screenshot *"),

          const Spacer(),

          /// CONFIRM BUTTON
          Obx(()=>authController.isLoading.value==true?CircularProgressIndicator():SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () async{

                // CALL REGISTER API HERE
                await authController.registerForceMan(
                    category: '1',
                    inservice: authController.selectedServiceStatus.value.toString(),
                    name: nameC.text,
                    aadhar: aadhaarC.text,
                    fatherHusband: fatherC.text,
                    birthday: dobC.text,
                    password: passwordC.text,
                    mobile: mobileC.text,
                    email: emailC?.text??"",
                    dlNo: '',
                    gender: authController.selectedGender.value,
                    occupation: '',
                    departmentId: globalcontroller.selectedDepartment.value!.name.toString(),
                    stateId: globalcontroller.selectedState.value!.id.toString(),
                    districtId: globalcontroller.selectedDistrict.value!.id.toString(),
                    block: '',
                    permAddress: addressC.text,
                    nomineeName: nomineeNameC.text,
                    nomineeRelation: nomineeRelationC.text,
                    nomineeMobile: nomineeMobileC.text,
                    bankName: '',
                    ifscCode: '',
                    accountNo: '', type: 'qr', amount: 0, orderId: '', transactionId: '', status: ''

                );
              },
              child: const Text(
                "Confirm & Register",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }

  Widget _upiPaymentTab() {
    final RxInt selectedAmount = 100.obs;
    final TextEditingController amountController =
    TextEditingController(text: '100');

    /// 🔥 Added 100 here
    final List<int> suggestedAmounts = [100, 500, 1000, 2000, 5000];

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Amount title
            Text(
              "Enter Amount",
              style: Get.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            /// Amount input (read-only)
            TextField(
              controller: amountController,
              enabled: false,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: "₹ ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Suggested amounts
            Text(
              "Quick Select",
              style: Get.textTheme.titleSmall,
            ),
            const SizedBox(height: 10),

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

            const Spacer(),

            /// Proceed button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: Obx(
                    () => ElevatedButton(
                  onPressed: () async{
                    final payAmount = selectedAmount.value;
                    print("Proceed to pay ₹$payAmount");
                    // startUpiPayment(payAmount);
                    await phonePeAuthController.startTransaction(payAmount);

                    if(phonePeAuthController.paymentsuccess.value.toString()=="1"){

                      await authController.registerDrivers(
                          category: '4',
                          inservice: authController.selectedServiceStatus?.value.toString()??"",
                          name: nameC.text,
                          aadhar: aadhaarC.text,
                          fatherHusband: fatherC.text,
                          birthday: dobC.text,
                          password: passwordC.text,
                          mobile: mobileC.text,
                          email: emailC?.text??"",
                          dlNo: dlC.text,
                          gender: authController.selectedGender.value,
                          occupation: '',
                          departmentId: globalcontroller.selectedDepartment.value?.name ?? "",
                          stateId: globalcontroller.selectedState.value?.id.toString()??"",
                          districtId: globalcontroller.selectedDistrict.value?.id.toString()??"",
                          block: '',
                          permAddress: addressC.text,
                          nomineeName: nomineeNameC.text,
                          nomineeRelation: nomineeRelationC.text,
                          nomineeMobile: nomineeMobileC.text,
                          bankName: '',
                          ifscCode: '',
                          accountNo: '', driver_type: authController.selecteddrivetype.value.toString()=="TR(Transport)"?"TR":"NT",
                          type: 'pay', amount: payAmount, orderId: phonePeAuthController.orderid.toString(), transactionId: phonePeAuthController.orderid.value.toString(), status: phonePeAuthController.paymentstatus.value.toString()
                      );
                    }
                    else{

                    }

                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    "Proceed to Pay ₹${selectedAmount.value} ",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _upiTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Get.theme.primaryColor.withOpacity(0.4),
          ),
          color: Get.theme.cardColor,
        ),
        child: Row(
          children: [
            Icon(icon, color: Get.theme.primaryColor),
            const SizedBox(width: 16),
            Text(
              title,
              style: Get.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  // void _openUpi(String app) {
  Widget _dropdown({
    required String label,
    required List<String> items,
    required RxString selectedValue,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Obx(() => DropdownButtonFormField<String>(
        value: selectedValue.value.isEmpty
            ? null
            : selectedValue.value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(
            e,
            overflow: TextOverflow.ellipsis,
          ),
        ))
            .toList(),
        onChanged: (v) {
          selectedValue.value = v!;
        },
        validator: (v) => v == null ? "Required" : null,
      )),
    );
  }

  Widget _section(String t) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(t,
            style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Get.theme.primaryColor)),
      );
  Widget _textmobile(TextEditingController c,
      String l, {
        bool obscure = false,
        TextInputType type = TextInputType.text,
      })
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        keyboardType: type,maxLength:10,
        cursorColor: Get.theme.primaryColor,
        decoration: InputDecoration(
          labelText: l,

          /// NORMAL BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Get.isDarkMode
                  ? Colors.grey.shade700
                  : Colors.grey.shade400,
              width: 1.2,
            ),
          ),

          /// FOCUS BORDER (GLOW FEEL)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Get.theme.primaryColor,
              width: 2,
            ),
          ),

          /// ERROR BORDER
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),

          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _text(TextEditingController c,
      String l, {
        bool obscure = false,
        TextInputType type = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        keyboardType: type,
        cursorColor: Get.theme.primaryColor,
        decoration: InputDecoration(
          labelText: l,

          /// NORMAL BORDER
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Get.isDarkMode
                  ? Colors.grey.shade700
                  : Colors.grey.shade400,
              width: 1.2,
            ),
          ),

          /// FOCUS BORDER (GLOW FEEL)
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Get.theme.primaryColor,
              width: 2,
            ),
          ),

          /// ERROR BORDER
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),

          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _readOnly(TextEditingController c, String l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        readOnly: true,
        decoration: InputDecoration(labelText: l),
      ),
    );
  }

  Widget _aadhaar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: aadhaarC,
        keyboardType: TextInputType.number,
        maxLength: 12,
        decoration: const InputDecoration(
            labelText: "Aadhaar Card No. *", counterText: ""),
        validator: (v) =>
        v!.length != 12 ? "Invalid Aadhaar" : null,
      ),
    );
  }

  Widget _dobField(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: dobC,
        readOnly: true,
        decoration: const InputDecoration(
          labelText: "Date of Birth (dd-MM-yyyy) *",
          suffixIcon: Icon(Icons.calendar_today),
        ),
        validator: (v) => v!.isEmpty ? "Required" : null,
        onTap: () async {
          FocusScope.of(Get.context!).unfocus();

          DateTime? picked = await showDatePicker(
            context: Get.context!,
            initialDate: DateTime(2000),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
            builder: (context, child) {
              return Theme(
                data: Get.isDarkMode
                    ? ThemeData.dark().copyWith(
                  colorScheme:
                  const ColorScheme.dark(primary: Colors.green),
                )
                    : ThemeData.light().copyWith(
                  colorScheme:
                  const ColorScheme.light(primary: Colors.green),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            final formattedDate =
                "${picked.day.toString().padLeft(2, '0')}-"
                "${picked.month.toString().padLeft(2, '0')}-"
                "${picked.year}";

            dobC.text = formattedDate;

            // Optional: auto age calc
            final today = DateTime.now();
            int age = today.year - picked.year;
            if (today.month < picked.month ||
                (today.month == picked.month &&
                    today.day < picked.day)) {
              age--;
            }
            ageC.text = age.toString();
          }
        },
      ),
    );
  }

  Widget _multi(TextEditingController c, String l) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: c,
        maxLines: 4,
        decoration: InputDecoration(labelText: l),
        validator: (v) => v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _row(List<Widget> w) =>
      Row(
        children: w
            .map((e) =>
            Expanded(
              child: Padding(
                  padding:
                  const EdgeInsets.only(right: 8),
                  child: e),
            ))
            .toList(),
      );

  Widget _dropdownSimple(
      String label,
      List<String> items,
      RxString selectedValue,
      )
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Obx(() => DropdownButtonFormField<String>(
        value:
        selectedValue.value.isEmpty ? null : selectedValue.value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
            .toList(),
        onChanged: (v) {
          selectedValue.value = v!;
        },
        validator: (v) => v == null ? "Required" : null,
      )),
    );
  }

  Widget _dropdownSimplefordrivertype(
      String label,
      List<String> items,
      RxString selectedValue,
      )
  {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Obx(() => DropdownButtonFormField<String>(
        value:
        selectedValue.value.isEmpty ? null : selectedValue.value,
        isExpanded: true,
        decoration: InputDecoration(labelText: label),
        items: items
            .map(
              (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
            .toList(),
        onChanged: (v) {
          selectedValue.value = v!;
        },
        validator: (v) => v == null ? "Required" : null,
      )),
    );
  }

  Widget _filePicker(String label) {
    return Obx(() =>
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: InkWell(
            onTap: _showImagePickerSheet,
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border:
                Border.all(color: Get.theme.primaryColor),
              ),
              child: authController.selectedImage.value == null
                  ? Center(child: Text(label))
                  : Image.file(
                authController.selectedImage.value!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }

  Widget _filePickerqr(String label) {
    return Obx(() =>
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: InkWell(
            onTap: _showImagePickerSheetqr,
            child: Container(

              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border:
                Border.all(color: Get.theme.primaryColor),
              ),
              child: authController.paymentScreenshot.value == null
                  ? Center(child: Text(label))
                  : Image.file(
                authController.paymentScreenshot.value!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }

  void _showImagePickerSheet() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// DRAG HANDLE
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// TITLE
              Text(
                "Upload Photo",
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// CAMERA
              _pickerTile(
                icon: Icons.camera_alt,
                title: "Camera",
                onTap: authController.pickFromCamera,
              ),

              const SizedBox(height: 10),

              /// GALLERY
              _pickerTile(
                icon: Icons.photo_library,
                title: "Gallery",
                onTap: authController.pickFromGallery,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void _showImagePickerSheetqr() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(26),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// DRAG HANDLE
              Container(
                width: 60,
                height: 5,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Get.isDarkMode
                      ? Colors.grey.shade700
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// TITLE
              Text(
                "Upload Photo",
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// CAMERA
              _pickerTile(
                icon: Icons.camera_alt,
                title: "Camera",
                onTap: authController.pickFromCameraqr,
              ),

              const SizedBox(height: 10),

              /// GALLERY
              _pickerTile(
                icon: Icons.photo_library,
                title: "Gallery",
                onTap: authController.pickFromGalleryqr,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  Widget _pickerTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Get.theme.primaryColor.withOpacity(0.4),
          ),
          color: Get.theme.cardColor,
        ),
        child: Row(
          children: [
            Icon(icon, color: Get.theme.primaryColor),
            const SizedBox(width: 16),
            Text(
              title,
              style: Get.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
