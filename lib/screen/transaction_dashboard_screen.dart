import 'package:flutter/material.dart';
import 'package:paywise/screen/pay_history_screens.dart';
import 'package:paywise/screen/transaction_details_screen.dart';
import 'package:paywise/widget/transaction_list_item.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; 
import '../providers/transaction_provider.dart';


class TransactionDashboardScreen extends StatefulWidget {
  const TransactionDashboardScreen({super.key});

  @override
  State<TransactionDashboardScreen> createState() => _TransactionDashboardScreenState();
}

class _TransactionDashboardScreenState extends State<TransactionDashboardScreen> {
  // Controllers for date pickers
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch transactions when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).fetchAndSetTransactions();
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final provider = Provider.of<TransactionProvider>(context, listen: false);
      if (isStartDate) {
        provider.setDateRange(picked, provider.endDate);
        _startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      } else {
        provider.setDateRange(provider.startDate, picked);
        _endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<TransactionProvider>(context, listen: false).fetchAndSetTransactions();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_off),
            onPressed: () {
              Provider.of<TransactionProvider>(context, listen: false).clearFilters();
              _startDateController.clear();
              _endDateController.clear();
            },
          ),

           IconButton(
            icon: const Icon(Icons.receipt_long), // Choose an appropriate icon
            tooltip: 'View Payout History',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PayoutHistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _startDateController,
                            decoration: const InputDecoration(
                              labelText: 'Start Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _endDateController,
                            decoration: const InputDecoration(
                              labelText: 'End Date',
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Consumer<TransactionProvider>(
                  builder: (context, provider, child) {
                    return DropdownButtonFormField<String>(
                      value: provider.selectedStatus ?? 'All',
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: <String>['All', 'Completed', 'Pending', 'Failed']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        provider.setStatusFilter(newValue);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          const Divider(),

           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Card(
              elevation: 3.0,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PayoutHistoryScreen(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Payout History',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.blue),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.errorMessage != null) {
                  return Center(
                    child: Text(
                      'Error: ${provider.errorMessage}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else if (provider.transactions.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                } else {
                  return ListView.builder(
                    itemCount: provider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = provider.transactions[index];
                      return TransactionListItem(
                        transaction: transaction,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TransactionDetailScreen(transaction: transaction),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}