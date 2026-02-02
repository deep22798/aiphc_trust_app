class ContactusModelMprofile {
  final String id;
  final String name;
  final String email;
  final String mobileNo;
  final String mobileNo2;
  final String trustRegNo;
  final String panNo;
  final String darpanId;
  final String address;
  final String logo;
  final String photo;
  final String facebookLink;
  final String twitterLink;
  final String instagramLink;
  final String linkedinLink;
  final String youtubeLink;
  final DateTime dateUpdated;

  ContactusModelMprofile({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNo,
    required this.mobileNo2,
    required this.trustRegNo,
    required this.panNo,
    required this.darpanId,
    required this.address,
    required this.logo,
    required this.photo,
    required this.facebookLink,
    required this.twitterLink,
    required this.instagramLink,
    required this.linkedinLink,
    required this.youtubeLink,
    required this.dateUpdated,
  });

  factory ContactusModelMprofile.fromJson(Map<String, dynamic> json) {
    return ContactusModelMprofile(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      mobileNo2: json['mobile_no_2'] ?? '',
      trustRegNo: json['trust_reg_no'] ?? '',
      panNo: json['pan_no'] ?? '',
      darpanId: json['darpan_id'] ?? '',
      address: json['address'] ?? '',
      logo: json['logo'] ?? '',
      photo: json['photo'] ?? '',
      facebookLink: json['facebook_link'] ?? '',
      twitterLink: json['twitter_link'] ?? '',
      instagramLink: json['instagram_link'] ?? '',
      linkedinLink: json['linkedin_link'] ?? '',
      youtubeLink: json['youtube_link'] ?? '',
      dateUpdated: DateTime.parse(json['date_updated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile_no': mobileNo,
      'mobile_no_2': mobileNo2,
      'trust_reg_no': trustRegNo,
      'pan_no': panNo,
      'darpan_id': darpanId,
      'address': address,
      'logo': logo,
      'photo': photo,
      'facebook_link': facebookLink,
      'twitter_link': twitterLink,
      'instagram_link': instagramLink,
      'linkedin_link': linkedinLink,
      'youtube_link': youtubeLink,
      'date_updated': dateUpdated.toIso8601String(),
    };
  }
}
