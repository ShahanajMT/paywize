import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paywise/models/pay_req.dart';


class PayoutHistoryItem extends StatelessWidget {
  final PayoutRequest request;

  const PayoutHistoryItem({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Beneficiary: ${request.beneficiaryName}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text('Account No.: ${request.accountNumber}'),
            Text('IFSC: ${request.ifsc}'),
            Text('Amount: ₹${request.amount.toStringAsFixed(2)}'),
            Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(request.timestamp)}'),
          ],
        ),
      ),
    );
  }
}