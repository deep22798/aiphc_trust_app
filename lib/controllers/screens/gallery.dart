import 'dart:io';

import 'package:aiphc/model/gallerymodel.dart';
import 'package:aiphc/utils/serverconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:image_picker/image_picker.dart';

class GalleryController extends GetxController {

  // 🔹 Loading flags (SEPARATED)
  final albumLoading = false.obs;
  final imageLoading = false.obs;


  final Rx<File?> selectedGalleryImage = Rx<File?>(null);
  final RxBool imageUploading = false.obs;

  // 🔹 Data
  final RxList<GalleryAlbumModel> gallery = <GalleryAlbumModel>[].obs;
  final RxList<GalleryImageModel> galleryimages = <GalleryImageModel>[].obs;


  final titleController = TextEditingController();
  final Rx<File?> coverImage = Rx<File?>(null);
  final RxBool loading = false.obs;

  final picker = ImagePicker();

  Future<void> pickCoverImage() async {
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (image != null) {
      coverImage.value = File(image.path);
    }
  }





  Future<void> pickGalleryImage() async {
    final picker = ImagePicker();
    final XFile? image =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);

    if (image != null) {
      selectedGalleryImage.value = File(image.path);
    }
  }

  Future<void> addGalleryImage(String albumId) async {
    if (selectedGalleryImage.value == null) {
      Get.snackbar("Error", "Please select an image");
      return;
    }

    try {
      imageUploading.value = true;

      final dio = Dio();

      final formData = FormData.fromMap({
        "album_id": albumId,
        "image": await MultipartFile.fromFile(
          selectedGalleryImage.value!.path,
          filename: selectedGalleryImage.value!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        "${ServerConstants.addGalleryImage}",
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );

      imageUploading.value = false;

      if (response.data["status"] == true) {
        selectedGalleryImage.value = null;
        Get.back();
        Get.snackbar("Success", response.data["message"]);
      } else {
        Get.snackbar("Failed", response.data["message"]);
      }
    } catch (e) {
      imageUploading.value = false;
      Get.snackbar("Error", "Image upload failed");
    }
  }


  Future<void> addAlbum() async {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar("Error", "Album title is required");
      return;
    }

    if (coverImage.value == null) {
      Get.snackbar("Error", "Cover image is required");
      return;
    }


    try {
      loading.value = true;

      final dio = Dio();

      final formData = FormData.fromMap({
        "title": titleController.text.trim(),
        "cover_image": await MultipartFile.fromFile(
          coverImage.value!.path,
          filename: coverImage.value!.path.split('/').last,
        ),
      });

      final response = await dio.post(
        "${ServerConstants.addGalleryAlbum}",
        data: formData,
        options: Options(headers: {"Accept": "application/json"}),
      );

      loading.value = false;

      if (response.data["status"] == true) {
        Get.back();
        Get.snackbar(
          "Success",
          response.data["message"],
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar("Failed", response.data["message"]);
      }
    } catch (e) {
      loading.value = false;
      Get.snackbar("Error", "Something went wrong");
    }
  }



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
