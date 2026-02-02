import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiHelper {
  final Dio _dio = Dio();

  // Generic GET request
  Future<dynamic> getRequest(String url) async {
    try {
      final response = await _dio.get(url);

      // Check for successful status code
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        return response.data;
      } else {
        print("API returned error: ${response.statusCode}");
        return null; // fallback data
      }
    } on DioException catch (e) {
      print("DioException caught: ${e.response?.statusCode} - ${e.message}");
      // You can show a user-friendly message here, e.g. using Snackbar
      return null; // fallback data
    } catch (e) {
      print("Unexpected error: $e");
      return null; // fallback data
    }
  }
}
