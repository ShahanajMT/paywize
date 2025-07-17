import 'package:flutter/material.dart';
import 'package:paywise/models/pay_req.dart';
import 'package:paywise/services/locat_storage_service.dart';
import 'package:paywise/widget/pay_history_item.dart';


class PayoutHistoryScreen extends StatefulWidget {
  const PayoutHistoryScreen({super.key});

  @override
  State<PayoutHistoryScreen> createState() => _PayoutHistoryScreenState();
}

class _PayoutHistoryScreenState extends State<PayoutHistoryScreen> {
  late Future<List<PayoutRequest>> _payoutRequestsFuture;
  final LocalStorageService _localStorageService = LocalStorageService();

  @override
  void initState() {
    super.initState();
    _loadPayoutRequests();
  }

  void _loadPayoutRequests() {
    setState(() {
      _payoutRequestsFuture = _localStorageService.getPayoutRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payout History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPayoutRequests, // Refresh the list
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              // Option to clear all history
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text('Confirm Clear History'),
                    content: const Text('Are you sure you want to delete all payout history? This action cannot be undone.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        child: const Text('Clear All', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  );
                },
              );
              if (confirm == true) {
                await _localStorageService.clearAllPayoutRequests();
                _loadPayoutRequests(); // Reload to show empty list
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Payout history cleared.')),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<PayoutRequest>>(
        future: _payoutRequestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No payout requests in history.'));
          } else {
            // Display payout requests in reverse chronological order
            final sortedRequests = List<PayoutRequest>.from(snapshot.data!)
              ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
            return ListView.builder(
              itemCount: sortedRequests.length,
              itemBuilder: (context, index) {
                return PayoutHistoryItem(request: sortedRequests[index]);
              },
            );
          }
        },
      ),
    );
  }
}