class DistrictModel {
  final String id;
  final String stateId;
  final String name;
  final String status;
  final String dateCreated;

  DistrictModel({
    required this.id,
    required this.stateId,
    required this.name,
    required this.status,
    required this.dateCreated,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> json) {
    return DistrictModel(
      id: json['id'],
      stateId: json['state_id'],
      name: json['name'],
      status: json['status'],
      dateCreated: json['date_created'],
    );
  }
}
