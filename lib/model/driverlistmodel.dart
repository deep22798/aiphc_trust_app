class Member {
  final String id;
  final String category;
  final String name;
  final String aadhar;
  final String mobile;
  final String email;
  final String gender;
  final String occupation;
  final String department;
  final String state;
  final String district;
  final String block;
  final String permAddress;
  final String roleId;
  final String status;
  final String? subscriptionId;
  final String driverType;
  final String dateCreated;

  Member({
    required this.id,
    required this.category,
    required this.name,
    required this.aadhar,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.occupation,
    required this.department,
    required this.state,
    required this.district,
    required this.block,
    required this.permAddress,
    required this.roleId,
    required this.status,
    required this.subscriptionId,
    required this.driverType,
    required this.dateCreated,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['id'].toString(),
      category: json['category']?.toString() ?? '',
      name: json['name'] ?? '',
      aadhar: json['aadhar'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      occupation: json['occupation'] ?? '',
      department: json['department'] ?? '',
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      block: json['block'] ?? '',
      permAddress: json['perm_address'] ?? '',
      roleId: json['role_id']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      subscriptionId: json['subscription_id']?.toString(),
      driverType: json['driver_type'] ?? '',
      dateCreated: json['date_created'] ?? '',
    );
  }
}
