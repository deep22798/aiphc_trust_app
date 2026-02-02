
import 'package:aiphc/model/bannermodel.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bannerscontroller extends GetxController{

@override
  void onReady() async{
    // TODO: implement onReady
    super.onReady();
    await fetchBanners();
  }

var bannerloading=false.obs;
final RxList<BannerModel> banners = <BannerModel>[].obs;

var currentCarouselIndex = 0.obs;
Future<void> fetchBanners() async {
  try {
    bannerloading.value = true;

    final response = await Dio().get(
      ServerConstants.banners,
    );

    final data = response.data;
    print("BANNER RESPONSE ::: $data");

    if (data['status'] == true) {

      // ✅ Parse & save banner list
      final List list = data['data'] ?? [];
      banners.value =
          list.map((e) => BannerModel.fromJson(e)).toList();

      // Get.snackbar(
      //   'Success',
      //   data['message'] ?? 'Banners fetched',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      // );
    } else {
      // Get.snackbar(
      //   'Error',
      //   data['message'] ?? 'Failed to fetch banners',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    }
  } on DioException catch (e) {
    // Get.snackbar(
    //   'Error',
    //   e.response?.data['message'] ?? 'Server not responding',
    //   snackPosition: SnackPosition.BOTTOM,
    //   backgroundColor: Colors.red,
    //   colorText: Colors.white,
    // );
  } finally {
    bannerloading.value = false;
  }
}


}