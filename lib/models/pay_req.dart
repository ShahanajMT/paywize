import 'dart:convert';

class PayoutRequest {
  final String beneficiaryName;
  final String accountNumber;
  final String ifsc;
  final double amount;
  final DateTime timestamp;

  PayoutRequest({
    required this.beneficiaryName,
    required this.accountNumber,
    required this.ifsc,
    required this.amount,
    required this.timestamp,
  });

  // Convert a PayoutRequest into a Map.
  Map<String, dynamic> toJson() {
    return {
      'beneficiaryName': beneficiaryName,
      'accountNumber': accountNumber,
      'ifsc': ifsc,
      'amount': amount,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Convert a Map into a PayoutRequest.
  factory PayoutRequest.fromJson(Map<String, dynamic> json) {
    return PayoutRequest(
      beneficiaryName: json['beneficiaryName'],
      accountNumber: json['accountNumber'],
      ifsc: json['ifsc'],
      amount: (json['amount'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // For storing in SharedPreferences, we'll convert to a JSON string
  String toRawJson() => json.encode(toJson());

  factory PayoutRequest.fromRawJson(String str) => PayoutRequest.fromJson(json.decode(str));
}