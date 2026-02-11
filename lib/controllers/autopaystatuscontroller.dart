import 'package:dio/dio.dart';
import 'package:get/get.dart';

class AutopayStatusController extends GetxController {
  final Dio dio = Dio();

  RxBool loading = true.obs;
  RxString autopayStatus = 'INACTIVE'.obs;
  RxString lastPaidDate = ''.obs;
  RxDouble lastAmount = 0.0.obs;

  RxList paymentHistory = [].obs;

  final int memberId;

  AutopayStatusController(this.memberId);

  @override
  void onInit() {
    super.onInit();
    fetchAutopayStatus();
    fetchPaymentHistory();
  }

  Future<void> fetchAutopayStatus() async {
    try {
      final res = await dio.get(
        "https://yourdomain.com/api/autopay-status/$memberId",
      );

      autopayStatus.value = res.data['autopay'];

      if (res.data['autopay'] == 'ACTIVE') {
        lastPaidDate.value = res.data['last_paid_on'];
        lastAmount.value = double.parse(
            res.data['amount'].toString());
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchPaymentHistory() async {
    final res = await dio.get(
      "https://yourdomain.com/api/payment-history/$memberId",
    );

    paymentHistory.value = res.data['data'];
  }
}
