import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:paywise/models/transaction_models.dart';


class TransactionApi {

  static const String _mockApiUrl = 'https://api.mocki.io/v1/YOUR_MOCK_API_KEY'; // Replace with a real mock API or your backend

  // Example of mock JSON data if no API is available
  static const String _mockTransactionsJson = '''
  [
    {
      "id": "1",
      "amount": 1500.75,
      "date": "2024-07-15T10:30:00Z",
      "type": "Credit",
      "status": "Completed",
      "description": "Freelance payment"
    },
    {
      "id": "2",
      "amount": 250.00,
      "date": "2024-07-14T14:00:00Z",
      "type": "Debit",
      "status": "Pending",
      "vendor": "Online Store"
    },
    {
      "id": "3",
      "amount": 50.00,
      "date": "2024-07-13T18:45:00Z",
      "type": "Debit",
      "status": "Completed",
      "category": "Food"
    },
    {
      "id": "4",
      "amount": 10000.00,
      "date": "2024-07-12T09:00:00Z",
      "type": "Credit",
      "status": "Failed",
      "source": "Bank Transfer"
    },
    {
      "id": "5",
      "amount": 75.50,
      "date": "2024-07-11T11:20:00Z",
      "type": "Debit",
      "status": "Completed",
      "note": "Subscription"
    }
  ]
  ''';

  Future<List<Transaction>> fetchTransactions() async {
    try {
      // Simulate network delay for mock data
      await Future.delayed(const Duration(seconds: 1));

      // If using a real API:
      // final response = await http.get(Uri.parse(_mockApiUrl));
      // if (response.statusCode == 200) {
      //   List<dynamic> jsonList = json.decode(response.body);
      //   return jsonList.map((json) => Transaction.fromJson(json)).toList();
      // } else {
      //   throw Exception('Failed to load transactions: ${response.statusCode}');
      // }

      // Using mock JSON data
      List<dynamic> jsonList = json.decode(_mockTransactionsJson);
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching transactions: $e');
      rethrow;
    }
  }
}