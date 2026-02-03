class StateModel {
  final String id;
  final String name;
  final String status;
  final String dateCreated;

  StateModel({
    required this.id,
    required this.name,
    required this.status,
    required this.dateCreated,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    return StateModel(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      dateCreated: json['date_created'],
    );
  }
}
