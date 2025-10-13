import 'package:flutter/material.dart';
import 'package:shopup/screens/product_overview.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShopUp',
      theme: ThemeData(
               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: ProductOverview()
    );
  }
}

