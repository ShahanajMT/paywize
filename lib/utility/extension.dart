import 'package:flutter/material.dart';
import 'package:paywise/core/data/data_provider.dart';
import 'package:paywise/screens/main/providers/main_screen_provider.dart';
import 'package:provider/provider.dart';

extension Providers on BuildContext {
  DataProvider get dataProvider => Provider.of<DataProvider>(this, listen: false);
  MainScreenProvider get mainScreenProvider => Provider.of<MainScreenProvider>(this, listen: false);
}