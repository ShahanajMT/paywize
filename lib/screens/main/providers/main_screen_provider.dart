import 'package:flutter/material.dart';
import 'package:paywise/screens/dashboard/dashboard_screeen.dart';
import 'package:paywise/screens/transaction/transaction_screen.dart';

class MainScreenProvider extends ChangeNotifier {
  Widget selectedScreen = DashboardScreeen();

  navigateToScreen(String screenName) {
    switch (screenName) {
      case 'Dashboard':
        selectedScreen = DashboardScreeen();
        break; // Break statement needed here
      case 'Transaction':
        selectedScreen = TransactionScreen();
        break;
      default:
        selectedScreen = DashboardScreeen();
    }
    notifyListeners();
  }
}
