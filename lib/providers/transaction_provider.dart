import 'package:flutter/material.dart';
import 'package:paywise/models/transaction_models.dart';

import '../api/transaction_api.dart';

class TransactionProvider with ChangeNotifier {
  List<Transaction> _transactions = [];
  List<Transaction> _filteredTransactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Filter parameters
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedStatus;

  List<Transaction> get transactions => _filteredTransactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;
  String? get selectedStatus => _selectedStatus;

  TransactionProvider() {
    fetchAndSetTransactions();
  }

  Future<void> fetchAndSetTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _transactions = await TransactionApi().fetchTransactions();
      _applyFilters(); // Apply initial filters (none)
    } catch (e) {
      _errorMessage = 'Failed to load transactions: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    _applyFilters();
  }

  void setStatusFilter(String? status) {
    _selectedStatus = status;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredTransactions = _transactions.where((transaction) {
      bool matchesDate = true;
      if (_startDate != null) {
        matchesDate = transaction.date.isAfter(_startDate!) || transaction.date.isAtSameMomentAs(_startDate!);
      }
      if (_endDate != null && matchesDate) {
        matchesDate = transaction.date.isBefore(_endDate!.add(const Duration(days: 1))) || transaction.date.isAtSameMomentAs(_endDate!);
      }

      bool matchesStatus = true;
      if (_selectedStatus != null && _selectedStatus != 'All') {
        matchesStatus = transaction.status == _selectedStatus;
      }
      return matchesDate && matchesStatus;
    }).toList();
    notifyListeners();
  }

  void clearFilters() {
    _startDate = null;
    _endDate = null;
    _selectedStatus = null;
    _applyFilters();
  }
}