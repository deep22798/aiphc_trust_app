class Payment {
  final String id;
  final String memberId;
  final String month;
  final String year;
  final String date;
  final String amount;
  final String orderId;
  final String transactionId;
  final String status;
  final String dateCreated;

  Payment({
    required this.id,
    required this.memberId,
    required this.month,
    required this.year,
    required this.date,
    required this.amount,
    required this.orderId,
    required this.transactionId,
    required this.status,
    required this.dateCreated,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'].toString(),
      memberId: json['member_id'].toString(),
      month: json['month'] ?? '',
      year: json['year'] ?? '',
      date: json['date'] ?? '',
      amount: json['amount'].toString(),
      orderId: json['order_id'] ?? '',
      transactionId: json['transaction_id'] ?? '',
      status: json['status'] ?? '',
      dateCreated: json['date_created'] ?? '',
    );
  }
}
