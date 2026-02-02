class MemberModel {
  final int id;
  final int category;
  final String inService;
  final String name;
  final String aadhar;
  final String fatherHusband;
  final String birthday;
  final String password;
  final String mobile;
  final String email;
  final String dlNo;
  final String gender;
  final String occupation;
  final String department;
  final int state;
  final int district;
  final String block;
  final String permanentAddress;
  final String nomineeName;
  final String nomineeRelationship;
  final String nomineeMobileNo;
  final String bankName;
  final String ifscCode;
  final String accountNo;
  final String nomineeImage;
  final String userPhoto;
  final String paymentScreenshot;
  final int announcement;
  final int roleId;
  final int featured;
  final String description;
  final int status;
  final int locked;
  final String autoPayStatus;
  final String subscriptionId;
  final String driverType;
  final String dateCreated;
  final String state_id;
  final String category_name;
  final String state_name;
  final String district_id;
  final String district_name;
  final String block_id;
  final String block_name;


  const MemberModel({
    required this.id,
    required this.category,
    required this.inService,
    required this.name,
    required this.aadhar,
    required this.fatherHusband,
    required this.birthday,
    required this.password,
    required this.mobile,
    required this.email,
    required this.dlNo,
    required this.gender,
    required this.occupation,
    required this.department,
    required this.state,
    required this.district,
    required this.block,
    required this.permanentAddress,
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
    required this.autoPayStatus,
    required this.subscriptionId,
    required this.driverType,
    required this.dateCreated,
    required this.state_id,
    required this.state_name,
    required this.district_id,
    required this.district_name,
    required this.category_name,
    required this.block_id,
    required this.block_name,
  });

  /// 🔹 SAFE CONVERTERS
  static String _s(dynamic v) =>
      v == null || v.toString().trim().isEmpty ? '' : v.toString();

  static int _i(dynamic v) =>
      v == null ? 0 : int.tryParse(v.toString()) ?? 0;

  /// 🔹 FROM JSON (NULL SAFE)
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: _i(json['id']),
      category: _i(json['category']),
      inService: _s(json['inservice']),
      name: _s(json['name']),
      aadhar: _s(json['aadhar']),
      fatherHusband: _s(json['fatherhusband']),
      birthday: _s(json['birthday']),
      password: _s(json['password']),
      mobile: _s(json['mobile']),
      email: _s(json['email']),
      dlNo: _s(json['dlno']),
      gender: _s(json['gender']),
      occupation: _s(json['occupation']),
      department: _s(json['department']),
      state: _i(json['state']),
      district: _i(json['district']),
      block: _s(json['block']),
      permanentAddress: _s(json['perm_address']),
      nomineeName: _s(json['nominee_name']),
      nomineeRelationship: _s(json['nominee_relationship']),
      nomineeMobileNo: _s(json['nominee_mobileno']),
      bankName: _s(json['bankname']),
      ifscCode: _s(json['ifsccode']),
      accountNo: _s(json['accountno']),
      nomineeImage: _s(json['nominee_image']),
      userPhoto: _s(json['user_photo']),
      paymentScreenshot: _s(json['payment_screenshot']),
      announcement: _i(json['announcement']),
      roleId: _i(json['role_id']),
      featured: _i(json['featured']),
      description: _s(json['description']),
      status: _i(json['status']),
      locked: _i(json['locked']),
      autoPayStatus: _s(json['autopay_status']),
      subscriptionId: _s(json['subscription_id']),
      driverType: _s(json['driver_type']),
      dateCreated: _s(json['date_created']),
      state_id: _s(json['state_id']),
      state_name: _s(json['state_name']),
      district_id: _s(json['district_id']),
      district_name: _s(json['district_name']),
      block_id: _s(json['block_id']),
      block_name: _s(json['block_name']),
      category_name: _s(json['category_name']),
      // block_name: _s(json['block_name']),
    );
  }

  /// 🔹 TO JSON (SAFE)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'inservice': inService,
      'name': name,
      'aadhar': aadhar,
      'fatherhusband': fatherHusband,
      'birthday': birthday,
      'password': password,
      'mobile': mobile,
      'email': email,
      'dlno': dlNo,
      'gender': gender,
      'occupation': occupation,
      'department': department,
      'state': state,
      'district': district,
      'block': block,
      'perm_address': permanentAddress,
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
      'autopay_status': autoPayStatus,
      'subscription_id': subscriptionId,
      'driver_type': driverType,
      'date_created': dateCreated,
      'state_id': state_id,
      'state_name': state_name,
      'district_id': district_id,
      'district_name': district_name,
      'block_id': block_id,
      'block_name': block_name,
      'category_name': category_name,
    };
  }
}
