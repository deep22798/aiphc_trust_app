class DonationModel {
  final String id;
  final String orderId;
  final String name;
  final String mobileNo;
  final String message;
  final String amount;
  final String status;
  final String? transactionId;
  final String dateCreated;

  DonationModel({
    required this.id,
    required this.orderId,
    required this.name,
    required this.mobileNo,
    required this.message,
    required this.amount,
    required this.status,
    this.transactionId,
    required this.dateCreated,
  });

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    return DonationModel(
      id: json['id'] ?? '',
      orderId: json['order_id'] ?? '',
      name: json['name'] ?? '',
      mobileNo: json['mobile_no'] ?? '',
      message: json['message'] ?? '',
      amount: json['amount'] ?? '0',
      status: json['status'] ?? '',
      transactionId: json['transaction_id'],
      dateCreated: json['date_created'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'name': name,
      'mobile_no': mobileNo,
      'message': message,
      'amount': amount,
      'status': status,
      'transaction_id': transactionId,
      'date_created': dateCreated,
    };
  }
}
