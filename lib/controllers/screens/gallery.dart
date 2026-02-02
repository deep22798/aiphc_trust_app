import 'package:aiphc/model/gallerymodel.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class GalleryController extends GetxController {

  // 🔹 Loading flags (SEPARATED)
  final albumLoading = false.obs;
  final imageLoading = false.obs;

  // 🔹 Data
  final RxList<GalleryAlbumModel> gallery = <GalleryAlbumModel>[].obs;
  final RxList<GalleryImageModel> galleryimages = <GalleryImageModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    fetchGallery();
  }

  /// 📸 Fetch Albums
  Future<void> fetchGallery() async {
    try {
      albumLoading.value = true;

      final response = await Dio().get(ServerConstants.galleryAlbums);
      final data = response.data;

      if (data['status'] == true) {
        final List list = data['data'] ?? [];
        gallery.value =
            list.map((e) => GalleryAlbumModel.fromJson(e)).toList();
      }
    } catch (e) {
      // handle error if needed
    } finally {
      albumLoading.value = false;
    }
  }

  /// 🖼️ Fetch Images by Album
  Future<void> fetchGalleryimages(String albumId) async {
    try {
      imageLoading.value = true;

      // ✅ Clear old images first
      galleryimages.clear();

      final response = await Dio().get(
        "${ServerConstants.galleryImages}?album_id=$albumId",
      );

      final data = response.data;

      if (data['status'] == true) {
        final List list = data['data'] ?? [];
        galleryimages.value =
            list.map((e) => GalleryImageModel.fromJson(e)).toList();
      }
    } catch (e) {
      // handle error if needed
    } finally {
      imageLoading.value = false;
    }
  }
}
