class AdminModel {
  final String id;
  final String name;
  final String username;
  final String status;
  final String dateCreated;

  AdminModel({
    required this.id,
    required this.name,
    required this.username,
    required this.status,
    required this.dateCreated,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      status: json['status'].toString(),
      dateCreated: json['date_created'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'status': status,
      'date_created': dateCreated,
    };
  }
}
