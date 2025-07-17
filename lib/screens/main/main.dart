import 'package:flutter/material.dart';
import 'package:paywise/screens/main/componets/sidemenu.dart';
import 'package:paywise/screens/main/providers/main_screen_provider.dart';
import 'package:paywise/utility/extension.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Building MainScreen");
    context.dataProvider;
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SideMenu(),
            ),
            Consumer<MainScreenProvider>(
              builder: (context, provider, child) {
                 print("Selected screen: ${provider.selectedScreen.runtimeType}");
                return Expanded(
                  flex: 5,
                  child: provider.selectedScreen,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}