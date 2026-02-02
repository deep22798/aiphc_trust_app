class TeamMemberModel {
  final String id;
  final String title;
  final String position;
  final String stateId;
  final String districtId;
  final String image;
  final String status;
  final DateTime dateCreated;
  final DateTime dateUpdated;

  TeamMemberModel({
    required this.id,
    required this.title,
    required this.position,
    required this.stateId,
    required this.districtId,
    required this.image,
    required this.status,
    required this.dateCreated,
    required this.dateUpdated,
  });

  factory TeamMemberModel.fromJson(Map<String, dynamic> json) {
    return TeamMemberModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      position: json['position'] ?? '',
      stateId: json['state_id']?.toString() ?? '',
      districtId: json['district_id']?.toString() ?? '',
      image: json['image'] ?? '',
      status: json['status']?.toString() ?? '',
      dateCreated: DateTime.parse(json['date_created']),
      dateUpdated: DateTime.parse(json['date_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'position': position,
      'state_id': stateId,
      'district_id': districtId,
      'image': image,
      'status': status,
      'date_created': dateCreated.toIso8601String(),
      'date_updated': dateUpdated.toIso8601String(),
    };
  }
}
