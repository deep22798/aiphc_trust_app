import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AutopayController extends GetxController {
  final Dio dio = Dio();
  RxBool loading = false.obs;
  RxString error = "".obs;
  RxString autopayStatus = "INACTIVE".obs;

  //
  // Future<void> enableAutopay(int userId) async {
  //   loading.value = true;
  //   error.value = "";
  //
  //   try {
  //     final res = await dio.post(
  //       "${ServerConstants.baseUrl}api/subscription/setup",
  //       data: {"user_id": userId},
  //       options: Options(validateStatus: (_) => true),
  //     );
  //
  //     print("AUTOPAY RESPONSE => ${res.data}");
  //
  //     if (res.statusCode != 200 || res.data == null) {
  //       error.value = "Server error";
  //       return;
  //     }
  //
  //     final redirectUrl = res.data['redirectUrl'];
  //
  //     if (redirectUrl == null || redirectUrl.toString().isEmpty) {
  //       error.value = "Redirect URL not received from PhonePe";
  //       print("djcndjkbvkb :${error.value}");
  //       return;
  //     }
  //
  //     await launchUrl(
  //       Uri.parse(redirectUrl),
  //       mode: LaunchMode.externalApplication,
  //     );
  //
  //   } catch (e) {
  //     error.value = e.toString();
  //
  //     print("djcndjkbvkb :${error.value}");
  //   } finally {
  //     loading.value = false;
  //   }
  // }

  Future<void> enableAutopay(int userId) async {
    loading.value = true;
    error.value = "";

    try {
      final res = await dio.post(
        "${ServerConstants.baseUrl}api/subscription/setup",
        data: {"user_id": userId},
        options: Options(validateStatus: (_) => true),
      );

      print("AUTOPAY RESPONSE => ${res.data}");

      if (res.statusCode != 200 || res.data == null) {
        error.value = "Server error";
        return;
      }

      final redirectUrl = res.data['redirectUrl'];

      if (redirectUrl == null || redirectUrl.toString().isEmpty) {
        error.value = "Redirect URL not received from PhonePe";
        return;
      }

      final uri = Uri.parse(redirectUrl);

      if (!await canLaunchUrl(uri)) {
        error.value = "No app found to open AutoPay link";
        return;
      }

      await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
      );

    } catch (e) {
      error.value = e.toString();
      print("AUTOPAY ERROR => $e");
    } finally {
      loading.value = false;
    }
  }



  Future<void> loadStatus(int userId) async {
    final res = await dio.get(
      "${ServerConstants.baseUrl}api/autopay-status/$userId",
    );
    autopayStatus.value = res.data['autopay'] ?? 'INACTIVE';
  }

  Future<List> history(int userId) async {
    final res = await dio.get(
      "${ServerConstants.baseUrl}api/payment-history/$userId",
    );
    return res.data ?? [];
  }
}
