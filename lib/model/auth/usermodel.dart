class UserModel {
  final String id;
  final String category;
  final String inservice;
  final String name;
  final String aadhar;
  final String fatherHusband;
  final String birthday;
  final String mobile;
  final String email;
  final String dlNo;
  final String gender;
  final String occupation;
  final String department;
  final String state;
  final String district;
  final String block;
  final String permAddress;
  final String nomineeName;
  final String nomineeRelationship;
  final String nomineeMobileNo;
  final String bankName;
  final String ifscCode;
  final String accountNo;
  final String nomineeImage;
  final String userPhoto;
  final String paymentScreenshot;
  final String announcement;
  final String roleId;
  final String featured;
  final String description;
  final String status;
  final String locked;
  final String autopayStatus;
  final String subscriptionId;
  final String driverType;
  final String dateCreated;

  UserModel({
    required this.id,
    required this.category,
    required this.inservice,
    required this.name,
    required this.aadhar,
    required this.fatherHusband,
    required this.birthday,
    required this.mobile,
    required this.email,
    required this.dlNo,
    required this.gender,
    required this.occupation,
    required this.department,
    required this.state,
    required this.district,
    required this.block,
    required this.permAddress,
    required this.nomineeName,
    required this.nomineeRelationship,
    required this.nomineeMobileNo,
    required this.bankName,
    required this.ifscCode,
    required this.accountNo,
    required this.nomineeImage,
    required this.userPhoto,
    required this.paymentScreenshot,
    required this.announcement,
    required this.roleId,
    required this.featured,
    required this.description,
    required this.status,
    required this.locked,
    required this.autopayStatus,
    required this.subscriptionId,
    required this.driverType,
    required this.dateCreated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      inservice: json['inservice'] ?? '',
      name: json['name'] ?? '',
      aadhar: json['aadhar'] ?? '',
      fatherHusband: json['fatherhusband'] ?? '',
      birthday: json['birthday'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      dlNo: json['dlno'] ?? '',
      gender: json['gender'] ?? '',
      occupation: json['occupation'] ?? '',
      department: json['department'] ?? '',
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      block: json['block'] ?? '',
      permAddress: json['perm_address'] ?? '',
      nomineeName: json['nominee_name'] ?? '',
      nomineeRelationship: json['nominee_relationship'] ?? '',
      nomineeMobileNo: json['nominee_mobileno'] ?? '',
      bankName: json['bankname'] ?? '',
      ifscCode: json['ifsccode'] ?? '',
      accountNo: json['accountno'] ?? '',
      nomineeImage: json['nominee_image'] ?? '',
      userPhoto: json['user_photo'] ?? '',
      paymentScreenshot: json['payment_screenshot'] ?? '',
      announcement: json['announcement']?.toString() ?? '',
      roleId: json['role_id']?.toString() ?? '',
      featured: json['featured']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      locked: json['locked']?.toString() ?? '',
      autopayStatus: json['autopay_status']?.toString() ?? '',
      subscriptionId: json['subscription_id']?.toString() ?? '',
      driverType: json['driver_type'] ?? '',
      dateCreated: json['date_created'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'inservice': inservice,
      'name': name,
      'aadhar': aadhar,
      'fatherhusband': fatherHusband,
      'birthday': birthday,
      'mobile': mobile,
      'email': email,
      'dlno': dlNo,
      'gender': gender,
      'occupation': occupation,
      'department': department,
      'state': state,
      'district': district,
      'block': block,
      'perm_address': permAddress,
      'nominee_name': nomineeName,
      'nominee_relationship': nomineeRelationship,
      'nominee_mobileno': nomineeMobileNo,
      'bankname': bankName,
      'ifsccode': ifscCode,
      'accountno': accountNo,
      'nominee_image': nomineeImage,
      'user_photo': userPhoto,
      'payment_screenshot': paymentScreenshot,
      'announcement': announcement,
      'role_id': roleId,
      'featured': featured,
      'description': description,
      'status': status,
      'locked': locked,
      'autopay_status': autopayStatus,
      'subscription_id': subscriptionId,
      'driver_type': driverType,
      'date_created': dateCreated,
    };
  }
}
