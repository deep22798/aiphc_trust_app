import 'package:aiphc/controllers/auth/login.dart';
import 'package:aiphc/utils/Appconstants.dart';
import 'package:aiphc/utils/routes/serverassets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:open_filex/open_filex.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {

  final GlobalKey _cardKey = GlobalKey();
  final AuthController controller = Get.put(AuthController());
  void openDownloadedImage() {
    if (downloadedImagePath == null) {
      Get.snackbar("Error", "No image downloaded yet");
      return;
    }

    OpenFilex.open(downloadedImagePath!);
  }
  void openIdCardSheet(BuildContext context,String image,name,id,dob,mobile) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
              ),
              child: Column(
                children: [
                  /// drag handle
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "ID Card Preview)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  /// PREVIEW
                  Expanded(
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(14),
                          ),

                          child: RepaintBoundary(
                            key: _cardKey,
                            child: idcard(image,name,id,dob,mobile),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.image,color: Colors.white,),
                          label: const Text("Download PNG",style: TextStyle(color: Colors.white),),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            await Future.delayed(const Duration(milliseconds: 100));
                            final file = await exportPng(id);

                            if (file != null) {
                              downloadedImagePath = file.path;
                              Get.snackbar(
                                "Success",
                                "Downloaded",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 5),
                                mainButton: TextButton(
                                  onPressed: () {
                                    if (downloadedImagePath != null) {
                                      // OpenFilex.open(downloadedImagePath!);
                                      openDownloadedImage();
                                    }
                                  },
                                  child: const Text(
                                    "OPEN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              Get.snackbar("Error", "PNG failed");
                            }
                          },
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.picture_as_pdf),
                          label: const Text("Download PDF"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () async {
                            await Future.delayed(const Duration(milliseconds: 100));
                            final file = await exportPdf(id);

                            if (file != null) {
                              downloadedImagePath = file.path;
                              Get.snackbar(
                                "Success",
                                "Downloaded",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                                duration: const Duration(seconds: 5),
                                mainButton: TextButton(
                                  onPressed: () {
                                    if (downloadedImagePath != null) {
                                      // OpenFilex.open(downloadedImagePath!);
                                      openDownloadedImage();
                                    }
                                  },
                                  child: const Text(
                                    "OPEN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              Get.snackbar("Error", "PNG failed");
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }
  String? downloadedImagePath;
  // Future<File?> exportPng(String id) async {
  //   try {
  //     // ✅ wait for next frame
  //     await WidgetsBinding.instance.endOfFrame;
  //
  //     final boundary =
  //     _cardKey.currentContext!.findRenderObject()
  //     as RenderRepaintBoundary;
  //
  //     final image = await boundary.toImage(pixelRatio: 3.0);
  //
  //     final byteData =
  //     await image.toByteData(format: ui.ImageByteFormat.png);
  //
  //     final pngBytes = byteData!.buffer.asUint8List();
  //
  //     final directory = await getApplicationDocumentsDirectory();
  //     final filePath = "${directory.path}/AIPVST_$id.png";
  //
  //     final file = File(filePath);
  //     await file.writeAsBytes(pngBytes);
  //
  //     debugPrint("PNG saved at $filePath");
  //     return file;
  //   } catch (e) {
  //     debugPrint("PNG Export Error: $e");
  //     return null;
  //   }
  // }
  Future<File?> exportPng(String id) async {
    try {

      await WidgetsBinding.instance.endOfFrame;

      final boundary =
      _cardKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);

      final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      final pngBytes = byteData!.buffer.asUint8List();

      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = "${directory.path}/AIPVST_$id.png";
      final file = File(filePath);

      await file.writeAsBytes(pngBytes);

      return file;
    } catch (e) {
      debugPrint("Download PNG Error: $e");
      return null;
    }
  }

  Future<File?> exportPdf(String id) async {
    try {
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
      _cardKey.currentContext!.findRenderObject()
      as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3.0);

      final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      final pngBytes = byteData!.buffer.asUint8List();

      // 📄 Create PDF
      final pdf = pw.Document();

      final pdfImage = pw.MemoryImage(pngBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Center(
              child: pw.Image(
                pdfImage,
                fit: pw.BoxFit.contain,
              ),
            );
          },
        ),
      );

      Directory? directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = "${directory.path}/AIPVST_$id.pdf";
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());

      return file;
    } catch (e) {
      debugPrint("Download PDF Error: $e");
      return null;
    }
  }

  Widget idcard(String image,name,id,dob,mobile) {

    String buildQrData({
      required String name,
      required String id,
      required String dob,
      required String mobile,
    }) {
      return '''
AIPVST MEMBER CARD
-------------------
Name   : $name
ID     : AIPVST$id
DOB    : $dob
Mobile : $mobile
''';
    }






    return AspectRatio(
      aspectRatio: 297 / 210,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [

            /// BACK SIDE
            Expanded(
              child: Container(
                // padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade800, width: 1.5),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          ClipPath(
                            clipper: TopDiagonalClipper(),
                            child: Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(

                                  color:  Color(0xFFFFD700),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10)
                                  )
                              ),
                            ),
                          ),
                          ClipPath(
                            clipper: TopLeftDiagonalClipper(),
                            child: Container(
                              height: 50,

                              width: double.infinity,
                              decoration: BoxDecoration(

                                color: Color(0xFF026F06),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10)
                                )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("PAN No.\nAALTA4598E",style: TextStyle(color: Colors.black,fontSize: 8,fontWeight: FontWeight.bold),),Spacer(),
                              Image.asset("${Appconstants.applogo}",width: MediaQuery.sizeOf(context).width/9),Spacer(),
                              Text("Reg No.\nUP-71/2025",style: TextStyle(color: Colors.black,fontSize: 8,fontWeight: FontWeight.bold),)
                            ],
                          ),
                          Text("ऑल इंडिया पुलिस वित्तीय सहायता ट्रस्ट (रजिO.)",style: TextStyle(fontSize: 9,color: Colors.green,fontWeight: FontWeight.bold),),
                          Text("ALL INDIA POLICE VITTIYA SAHAYATA TRUST [REGI.]" ,style: TextStyle(fontSize: 7,color: Colors.green,fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),

                          const SizedBox(height: 10),
                          Center(
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.green),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: QrImageView(
                                  data: buildQrData(
                                    name: name,
                                    id: id,
                                    dob: formatDob(dob),
                                    mobile: mobile,
                                  ),
                                  size: 60,
                                  backgroundColor: Colors.white,
                                  errorCorrectionLevel: QrErrorCorrectLevel.Q,
                                ),
                              ),
                            ),

                          const SizedBox(height: 10),

                          const Text(
                            "Office Address:\n"
                                "B-7, Satya Nagar, Main Road\n"
                                "Techman City, Mathura-281006\n"
                                "Mob: 9068570082, 9068570083",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// FRONT SIDE
            Expanded(
              child: Container(
                // padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green.shade800, width: 1.5),
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(12),
                  ),
                ),
                child: Stack(
                  children: [
                    Stack(
                      children: [
                        ClipPath(
                          clipper: LeftCenterDiagonalClipper(),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            color:Color(0xFFD8EFB4),
                          ),
                        ),
                        ClipPath(
                          clipper: RightDiagonalClipper(),
                          child: Container(
                            height: 110,

                            width: double.infinity,
                            color: Color(0xFFE89A08),
                          ),
                        ),
                        ClipPath(
                          clipper: RightDiagonalClipper(),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            color:Color(0xFF026F06),
                          ),
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("PAN No.\nAALTA4598E",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),),Spacer(),
                              Image.asset("${Appconstants.applogo}",width: MediaQuery.sizeOf(context).width/9),Spacer(),
                              Text("Reg No.\nUP-71/2025",style: TextStyle(color: Colors.white,fontSize: 8,fontWeight: FontWeight.bold),)
                            ],
                          ),
                          Text("ऑल इंडिया पुलिस वित्तीय सहायता ट्रस्ट (रजिO.)",style: TextStyle(fontSize: 9,color: Colors.yellow,fontWeight: FontWeight.bold),),
                          Text("ALL INDIA POLICE VITTIYA SAHAYATA TRUST [REGI.]" ,style: TextStyle(fontSize: 7,color: Colors.yellow,fontWeight: FontWeight.bold),),
                          SizedBox(height: 5,),
                          DecoratedBox(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green.shade900,strokeAlign: 3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "${ServerAssets.users}${image}",
                                height: 80,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 5,),
                          Center(child: Text(name.toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),)),
                         controller.usermodel.value?.is_district_member.toString()!="1"?SizedBox(): Center(child: Text("(District Member)".toString(),style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 12),)),

                          SizedBox(height: 5,),
                          Row(children: [
                            Text("id :           ",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),),
                            Expanded(child: Text("AIPVST"+id,style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),)),
                          ],),
                          Row(children: [
                            Text(
                              "DOB :      ${formatDob("1999-07-22")}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],),
                          Row(children: [
                            Text("Mobile:   ",style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),),
                            Expanded(child: Text(mobile,style: TextStyle(color: Colors.black,fontSize: 11,fontWeight: FontWeight.bold),)),
                          ],),


                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Align(
                          alignment: Alignment.bottomRight,
                          child: Image.asset("assets/authsign.png",height: 20,)),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 65,
            child: Text(
              "$title :",
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  String formatDob(String dob) {
    DateTime date = DateTime.parse(dob);
    return DateFormat('dd-MM-yyyy').format(date);
  }
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
              MaterialButton(onPressed: (){

                openIdCardSheet(context,user.userPhoto.toString(),user.name,user.id,user.birthday,user.mobile);

              },child: Text("Id Card",style: TextStyle(color: Colors.white),),color: Colors.green.shade900,),
              // const SizedBox(height: 80),

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

  Future<void> _downloadPNG() async {
    try {
      final boundary = _cardKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("Boundary is null");
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final file = File("${directory.path}/id_card_a4.png");

      await file.writeAsBytes(pngBytes);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("PNG saved successfully"),
          backgroundColor: Colors.green.shade700,
        ),
      );
    } catch (e) {
      debugPrint("PNG Error: $e");
    }
  }

  Future<void> _downloadPDF() async {
    try {
      final boundary = _cardKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        debugPrint("Boundary is null");
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3);
      final ByteData? byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          build: (_) => pw.Center(
            child: pw.Image(
              pw.MemoryImage(pngBytes),
              fit: pw.BoxFit.contain,
            ),
          ),
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename: "id_card_a4.pdf",
      );
    } catch (e) {
      debugPrint("PDF Error: $e");
    }
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
class RightDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();


    path.moveTo(0, 0);                 // top-left
    path.lineTo(size.width, 0);        // top-right
    path.lineTo(size.width, size.height / 1.3); // center-right
    path.lineTo(0, size.height);       // bottom-left
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
class LeftCenterDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);                       // top-left
    path.lineTo(size.width, 0);              // top-right
    path.lineTo(size.width, size.height);    // bottom-right
    path.lineTo(0, size.height / 2);       // LEFT center (diagonal cut)
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double cut = 30; // diagonal depth (adjust as needed)

    path.moveTo(cut, 0);                 // ⬅️ top-left diagonal start
    path.lineTo(size.width - cut, 20);    // ➡️ top-right diagonal start
    path.lineTo(size.width, 0);        // top-right diagonal end
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cut);                 // top-left diagonal end
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class TopLeftDiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    double cut = 30; // diagonal depth (adjust)

    path.moveTo(0, size.height / 2);            // start after diagonal
    path.lineTo(size.width, 0);     // top-right
    path.lineTo(size.width, size.height); // bottom-right
    path.lineTo(0, size.height);    // bottom-left
    path.lineTo(0, cut);            // left side up
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


