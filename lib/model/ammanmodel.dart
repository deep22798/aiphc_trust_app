import 'package:intl/intl.dart';

class SammanModel {
  final String id;
  final String title;
  final String amount;
  final String pageDescription;
  final String status;
  final DateTime dateCreated; // ✅ DateTime
  final String dateUpdated;
  final String image;
  final String date;
  final List<String> images;


  SammanModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.pageDescription,
    required this.status,
    required this.dateCreated,
    required this.dateUpdated,
    required this.image,
    required this.date,
    required this.images,
  });

  factory SammanModel.fromJson(Map<String, dynamic> json) {
    final rawDateCreated = json['date_created'];
    DateTime parsedDateCreated;

    if (rawDateCreated != null && rawDateCreated.toString().isNotEmpty) {
      try {
        parsedDateCreated =
            DateTime.parse(rawDateCreated.toString().replaceFirst(' ', 'T'));
      } catch (_) {
        parsedDateCreated = DateTime.now();
      }
    } else {
      parsedDateCreated = DateTime.now();
    }

    return SammanModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      amount: json['amount'] ?? '',
      pageDescription: json['page_description'] ?? '',
      status: json['status'] ?? '',
      dateCreated: parsedDateCreated,
      dateUpdated: json['date_updated'] ?? '',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
      images: (json['images'] != null && json['images'] != '')
          ? (json['images'] as String).split(',')
          : [],
    );
  }

  // optional: formatted date
  String get formattedDate => DateFormat('dd-MM-yyyy').format(dateCreated);
}
