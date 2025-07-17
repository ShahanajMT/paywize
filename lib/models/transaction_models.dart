
class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final String type;
  final String status;
  final Map<String, dynamic> rawData; // To store all JSON data

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.status,
    required this.rawData,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'].toString(), // Assuming 'id' can be int or string
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      type: json['type'],
      status: json['status'],
      rawData: json, // Store the entire JSON
    );
  }
}