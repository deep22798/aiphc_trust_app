class ProcessRulesmodel {
  final String id;
  final String description;
  final String status;
  final DateTime dateCreated;
  final DateTime updateDate;

  ProcessRulesmodel({
    required this.id,
    required this.description,
    required this.status,
    required this.dateCreated,
    required this.updateDate,
  });

  /// Convert JSON → Dart Object
  factory ProcessRulesmodel.fromJson(Map<String, dynamic> json) {
    return ProcessRulesmodel(
      id: json['id']?.toString() ?? '',
      description: json['description'] ?? '',
      status: json['status']?.toString() ?? '',
      dateCreated: DateTime.parse(json['date_created']),
      updateDate: DateTime.parse(json['update_date']),
    );
  }

  /// Convert Dart Object → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status,
      'date_created': dateCreated.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
    };
  }
}
