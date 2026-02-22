class AboutUsModel {
  final String id;
  final String title;
  final String shortDescription;
  final String firstBoxName;
  final String firstValue;
  final String secondBoxName;
  final String secondValue;
  final String image;
  final String status;
  final DateTime dateCreated;
  final DateTime updateDate;

  AboutUsModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.firstBoxName,
    required this.firstValue,
    required this.secondBoxName,
    required this.secondValue,
    required this.image,
    required this.status,
    required this.dateCreated,
    required this.updateDate,
  });

  factory AboutUsModel.fromJson(Map<String, dynamic> json) {
    return AboutUsModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      shortDescription: json['shortdescription'] ?? '',
      firstBoxName: json['firstboxname'] ?? '',
      firstValue: json['firstvalue'] ?? '',
      secondBoxName: json['secondboxname'] ?? '',
      secondValue: json['secondvalue'] ?? '',
      image: json['image'] ?? '',
      status: json['status']?.toString() ?? '',
      dateCreated: DateTime.parse(json['date_created']),
      updateDate: DateTime.parse(json['update_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortdescription': shortDescription,
      'firstboxname': firstBoxName,
      'firstvalue': firstValue,
      'secondboxname': secondBoxName,
      'secondvalue': secondValue,
      'image': image,
      'status': status,
      'date_created': dateCreated.toIso8601String(),
      'update_date': updateDate.toIso8601String(),
    };
  }
}



class ContactMessageModel {
  final String id;
  final String memberid;
  final String name;
  final String email;
  final String subject;
  final String message;
  final String mobileNo;
  final DateTime dateCreated;

  ContactMessageModel({
    required this.id,
    required this.memberid,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.mobileNo,
    required this.dateCreated,
  });

  factory ContactMessageModel.fromJson(Map<String, dynamic> json) {
    return ContactMessageModel(
      id: json['id']?.toString() ?? '',
      memberid: json['memberid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      dateCreated: DateTime.parse(json['date_created']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'memberid': memberid,
      'name': name,
      'email': email,
      'subject': subject,
      'message': message,
      'mobile_no': mobileNo,
      'date_created': dateCreated.toIso8601String(),
    };
  }
}
