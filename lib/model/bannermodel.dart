class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String shortDescription;
  final String image;
  final String status;
  final String dateCreated;
  final String updateDate;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.shortDescription,
    required this.image,
    required this.status,
    required this.dateCreated,
    required this.updateDate,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      shortDescription: json['shortdescription'] ?? '',
      image: json['image'] ?? '',
      status: json['status'].toString(),
      dateCreated: json['date_created'] ?? '',
      updateDate: json['update_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'shortdescription': shortDescription,
      'image': image,
      'status': status,
      'date_created': dateCreated,
      'update_date': updateDate,
    };
  }
}
