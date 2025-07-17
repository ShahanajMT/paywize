import 'package:flutter/material.dart';
import 'package:paywise/screen/transaction_dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'providers/transaction_provider.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        title: 'Fintech Dashboard',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const TransactionDashboardScreen(),
      ),
    );
  }
}