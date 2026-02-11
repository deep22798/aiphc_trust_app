import 'package:aiphc/model/paymentmodel.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../utils/serverconstants.dart';

class PaymentsController extends GetxController {
  final Dio dio = Dio();

  var payments = <Payment>[].obs;
  var isLoading = false.obs;

  Future<void> fetchPayments({String? memberId}) async {
    try {
      isLoading.value = true;

      final response = await dio.get(
        "${ServerConstants.getPayments}",
        queryParameters:
        memberId != null ? {"member_id": memberId} : null,
      );

      if (response.statusCode == 200 &&
          response.data['status'] == true) {
        final List list = response.data['data'];
        payments.value =
            list.map((e) => Payment.fromJson(e)).toList();
      } else {
        payments.clear();
      }
    } catch (e) {
      payments.clear();
      print("Payment API Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
