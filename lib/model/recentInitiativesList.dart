class RecentInitiativeModel {
  final String id;
  final String title;
  final String amount;
  final String pageDescription;
  final String status;

  final DateTime dateCreated;
  final DateTime? dateUpdated;

  final String image; // main image
  final List<String> images; // multiple images
  final String date; // yyyy-mm-dd (as string)

  RecentInitiativeModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.pageDescription,
    required this.status,
    required this.dateCreated,
    required this.dateUpdated,
    required this.image,
    required this.images,
    required this.date,
  });

  factory RecentInitiativeModel.fromJson(Map<String, dynamic> json) {
    // ---------- SAFE DATE PARSING ----------
    DateTime parseDate(dynamic value) {
      if (value == null || value.toString().isEmpty) {
        return DateTime.now();
      }
      return DateTime.parse(value.toString().replaceFirst(' ', 'T'));
    }

    // ---------- MULTI IMAGE HANDLING ----------
    List<String> parseImages(dynamic value) {
      if (value == null || value.toString().isEmpty) {
        return [];
      }
      return value.toString().split(',').map((e) => e.trim()).toList();
    }

    return RecentInitiativeModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      pageDescription: json['page_description'] ?? '',
      status: json['status']?.toString() ?? '',

      dateCreated: parseDate(json['date_created']),
      dateUpdated: json['date_updated'] != null
          ? parseDate(json['date_updated'])
          : null,

      image: json['image'] ?? '',
      images: parseImages(json['images']),
      date: json['date'] ?? '',
    );
  }
}
