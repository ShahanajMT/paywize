import 'package:flutter/material.dart';
import 'package:paywise/models/pay_req.dart';
import 'package:paywise/services/locat_storage_service.dart';


class PayoutFormScreen extends StatefulWidget {
  const PayoutFormScreen({super.key});

  @override
  State<PayoutFormScreen> createState() => _PayoutFormScreenState();
}

class _PayoutFormScreenState extends State<PayoutFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _beneficiaryNameController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final LocalStorageService _localStorageService = LocalStorageService();

  @override
  void dispose() {
    _beneficiaryNameController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Save the form fields

      final payoutRequest = PayoutRequest(
        beneficiaryName: _beneficiaryNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        ifsc: _ifscController.text.trim().toUpperCase(),
        amount: double.parse(_amountController.text.trim()),
        timestamp: DateTime.now(),
      );

      try {
        await _localStorageService.savePayoutRequest(payoutRequest);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payout request saved successfully!')),
        );
        // Clear form fields
        _beneficiaryNameController.clear();
        _accountNumberController.clear();
        _ifscController.clear();
        _amountController.clear();
        _formKey.currentState?.reset(); // Resets the validation state
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save payout request: ${e.toString()}')),
        );
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Beneficiary Name is required.';
    }
    return null;
  }

  String? _validateAccountNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Account Number is required.';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Account Number must contain only digits.';
    }
    if (value.length < 9 || value.length > 18) { // Typical account number length range
      return 'Account Number must be between 9 and 18 digits.';
    }
    return null;
  }

  String? _validateIFSC(String? value) {
    if (value == null || value.isEmpty) {
      return 'IFSC is required.';
    }
    // IFSC format: 4 letters, 1 zero, 6 digits/letters (e.g., ABCD0123456)
    if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value.toUpperCase())) {
      return 'Invalid IFSC format (e.g., ABCD0123456).';
    }
    return null;
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required.';
    }
    final double? amount = double.tryParse(value);
    if (amount == null) {
      return 'Invalid amount.';
    }
    if (amount <= 10) {
      return 'Amount must be greater than ₹10.';
    }
    if (amount >= 100000) {
      return 'Amount must be less than ₹1,00,000.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Payout Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _beneficiaryNameController,
                decoration: const InputDecoration(
                  labelText: 'Beneficiary Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_balance),
                ),
                keyboardType: TextInputType.number,
                validator: _validateAccountNumber,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ifscController,
                decoration: const InputDecoration(
                  labelText: 'IFSC Code',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.code),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: _validateIFSC,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount (₹)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                keyboardType: TextInputType.number,
                validator: _validateAmount,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Submit Payout Request',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}