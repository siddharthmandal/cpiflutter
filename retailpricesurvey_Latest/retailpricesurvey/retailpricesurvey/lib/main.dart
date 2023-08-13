import 'package:flutter/material.dart';
import 'pages/splash_page.dart';

void main() {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Retail Price Survey',
      theme: ThemeData(
         primaryColor: Colors.cyan[600],
        primarySwatch: Colors.red,
        brightness: Brightness.light,
      ),
      home: SplashPage(),
    );
  }
}

