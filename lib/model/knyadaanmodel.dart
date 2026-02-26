class KanyadaanMember {
  final String id;
  final String name;
  final String mobile;
  final String email;
  final String kanyadaan;
  final String gender;
  final String district;
  final String state;
  final String block;
  final String userPhoto;

  final String daughterName;
  final String daughterMobile;
  final String bankName;
  final String accountNo;
  final String ifsc;
  String kanyadaanDate;

  KanyadaanMember({
    required this.id,
    required this.name,
    required this.mobile,
    required this.email,
    required this.gender,
    required this.district,
    required this.state,
    required this.block,
    required this.kanyadaan,
    required this.userPhoto,
    required this.daughterName,
    required this.daughterMobile,
    required this.bankName,
    required this.accountNo,
    required this.ifsc,
    required this.kanyadaanDate,
  });

  factory KanyadaanMember.fromJson(Map<String, dynamic> json) {
    return KanyadaanMember(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      mobile: json['mobile'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? '',
      kanyadaan: json['kanyadaan'] ?? '',
      district: json['district'] ?? '',
      state: json['state'] ?? '',
      block: json['block'] ?? '',
      userPhoto: json['user_photo'] ?? '',
      daughterName: json['daughter_name'] ?? '',
      daughterMobile: json['daughter_mobile'] ?? '',
      bankName: json['bank_name'] ?? '',
      accountNo: json['account_no'] ?? '',
      ifsc: json['account_ifsccode'] ?? '',
      kanyadaanDate: json['kanyadaan_date'] ?? '',
    );
  }
}