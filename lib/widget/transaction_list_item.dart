import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paywise/models/transaction_models.dart';


class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 2.0,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Icon(
          transaction.type == 'Credit' ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.type == 'Credit' ? Colors.green : Colors.red,
        ),
        title: Text(
          '${transaction.type} - ${transaction.status}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4.0),
            Text('Amount: \$${transaction.amount.toStringAsFixed(2)}'),
            Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(transaction.date)}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}