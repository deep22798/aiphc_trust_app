// The Flutter code developed by Kuldeep Singh is protected under copyright law. No individual or entity is permitted to copy, distribute, or use this code in any form without explicit permission from Kuldeep Singh. Unauthorized use, duplication, or modification of this code is strictly prohibited. Any violation of these terms will be subject to legal action, and Kuldeep Singh reserves the right to take appropriate legal measures against any individual or organization found infringing upon these rights. This Flutter code is copyrighted by Kuldeep Singh.


import 'package:cloudcampus/models/auth/studentloginmodel.dart';
import 'package:cloudcampus/views/authentication/Prelogin.dart';
import 'package:cloudcampus/views/authentication/login.dart';
import 'package:cloudcampus/views/authentication/otpscreen.dart';
import 'package:cloudcampus/views/globalscreens/erp/erp.dart';
import 'package:cloudcampus/views/globalscreens/googleclassroom/googleclassroom.dart';
import 'package:cloudcampus/views/globalscreens/media/media.dart';
import 'package:cloudcampus/views/globalscreens/schoolwebsite/website.dart';
import 'package:cloudcampus/views/student/dashboard/dashboard.dart';
import 'package:cloudcampus/views/student/feepayment/feedashboard.dart';
import 'package:cloudcampus/views/student/mentors/mentors.dart';
import 'package:cloudcampus/views/student/onboarding/onboarding.dart';
import 'package:cloudcampus/views/student/splash/splash.dart';
import 'package:cloudcampus/views/teacher/communicationbwteacher/communicationbwteachers.dart';
import 'package:get/get.dart';

class Routes {
  static String splash = '/splash';
  static String onboarding = '/onboarding';
  static String login = '/login';
  static String otpscreen = '/otpscreen';
  static String prelogin = '/prelogin';
  static String dashboard = '/dashboard';
  static String notification = '/dashboard';
  static String mytask = '/dashboard';
  static String gallery = '/dashboard';
  static String mentors = '/mentors';
  static String timetable = '/timetable';
  static String askmymentor = '/askmymentor';
  static String profile = '/profile';
  static String performance = '/performance';
  static String noticeboard = '/noticeboard';
  static String poll = '/poll';
  static String website = '/website';
  static String feepayment = '/feepayment';
  static String media = '/media';
  static String googleclassroom = '/googleclassroom';
  static String erppage = '/erppage';
  static String communicationbwteachers = '/communicationbwteachers';
}

final getPages = [
  GetPage(
    name: Routes.splash,
    page: () {
      return Splash();
    },
  ),
  GetPage(
      page: () {
        return OnboardingScreen();
      },
      name: Routes.onboarding),
  GetPage(
      page: () {
        var userId = Get.arguments;
        var name = Get.arguments;
        var classs = Get.arguments;
        var section = Get.arguments;
        return CommunicationbwTeachers(section: section, classs: classs, userId: userId, name: name);
      },
      name: Routes.communicationbwteachers),
  GetPage(
    name: Routes.login,
    page: () {
      return Login();
    },
  ),
  GetPage(
    name: Routes.otpscreen,
    page: () {
      return OtpScreen();
    },
  ),
  GetPage(
    name: Routes.prelogin,
    page: () {
      return PreLogin();
    },
  ),
  GetPage(
    name: Routes.dashboard,
    page: () {
      var userid = Get.arguments;
      var name = Get.arguments;
      var classs = Get.arguments;
      var section = Get.arguments;
      var image = Get.arguments;
      var userrole = Get.arguments;
      var year = Get.arguments;
      var fathername = Get.arguments;
      var mothername = Get.arguments;
      var gender = Get.arguments;
      var phone = Get.arguments;
      var userstatus = Get.arguments;
      var smsphone = Get.arguments;
      var doa = Get.arguments;
      var dob = Get.arguments;
      var rollno = Get.arguments;
      var joinclass = Get.arguments;
      var ReqStdYrid = Get.arguments;
      var clid = Get.arguments;
      // Get the list of StudentLogin from arguments
      List<StudentLogin> loginDataList = Get.arguments as List<StudentLogin>;
      return Dashboard(
          userid: userid,
          name: name,
          classs: classs,
          section: section,
          image: image,
          userrole: userrole,
          year: year,
          fathername: fathername,
          mothername: mothername,
          gender: gender,
          phone: phone,
          userstatus: userstatus,
          smsphone: smsphone,
          doa: doa,
          dob: dob,
          rollno: rollno,
          joinclass: joinclass,
          ReqStdYrid: ReqStdYrid, clid: clid,);
    },
  ),
  GetPage(
    name: Routes.mentors,
    page: () {
      return Mentor(
        userid: '',
        name: '',
        section: '',
        classname: '',
      );
    },
  ),
  GetPage(
    name: Routes.website,
    page: () {
      return Website();
    },
  ),
  GetPage(
    name: Routes.feepayment,
    page: () {
      var userId = Get.arguments;
      var ReqStdYrid = Get.arguments;
      var phno = Get.arguments;
      var name = Get.arguments;
      var fathername = Get.arguments;
      var classs = Get.arguments;
      var section = Get.arguments;
      var clid = Get.arguments;
      // return FeePayment();
      return Feedashboard(
        userId: userId,
        ReqStdYrid: ReqStdYrid,
        phno: phno,
        name: name,
        fathername: fathername,
        classs: classs,
        section: section, clid: clid,
      );
    },
  ),
  GetPage(
    name: Routes.media,
    page: () {
      return Media();
    },
  ),
  GetPage(
    name: Routes.googleclassroom,
    page: () {
      return GoogleClassroom();
    },
  ),
  GetPage(
    name: Routes.erppage,
    page: () {
      return ERP();
    },
  ),
];


// The Flutter code developed by Kuldeep Singh is protected under copyright law. No individual or entity is permitted to copy, distribute, or use this code in any form without explicit permission from Kuldeep Singh. Unauthorized use, duplication, or modification of this code is strictly prohibited. Any violation of these terms will be subject to legal action, and Kuldeep Singh reserves the right to take appropriate legal measures against any individual or organization found infringing upon these rights. This Flutter code is copyrighted by Kuldeep Singh.
