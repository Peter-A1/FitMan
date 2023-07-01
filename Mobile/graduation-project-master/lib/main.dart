import 'package:flutter/material.dart';
import 'UI/Splash/splash_start.dart';



void main()
{
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SS(),
    );
  }
}
