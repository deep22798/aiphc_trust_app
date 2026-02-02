class SuccessModel {
  final String id;
  final String title;
  final String subtitle;
  final String pageDescription;
  final String status;
  final DateTime dateCreated;
  final String dateUpdated;
  final String image;
  final String date;

  SuccessModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pageDescription,
    required this.status,
    required this.dateCreated,
    required this.dateUpdated,
    required this.image,
    required this.date,
  });

  factory SuccessModel.fromJson(Map<String, dynamic> json) {
    // 🔐 SAFE date parsing
    final rawDateCreated = json['date_created'];

    DateTime parsedDateCreated;
    if (rawDateCreated != null && rawDateCreated.toString().isNotEmpty) {
      parsedDateCreated = DateTime.parse(
        rawDateCreated.toString().replaceFirst(' ', 'T'),
      );
    } else {
      parsedDateCreated = DateTime.now(); // fallback
    }

    return SuccessModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      pageDescription: json['page_description'] ?? '',
      status: json['status']?.toString() ?? '',
      dateCreated: parsedDateCreated, // ✅ FIXED
      dateUpdated: json['date_updated'] ?? '',
      image: json['image'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
