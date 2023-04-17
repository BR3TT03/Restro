import 'package:flutter/material.dart';
import 'package:hotel_automation/Home.dart';

//import 'package:hotel_automation/product_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Automation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
      bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
      ),
      home: Menu(),
    );
  }
}
