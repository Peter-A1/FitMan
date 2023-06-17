import 'package:flutter/material.dart';
import 'package:login_authentication_2/UI/Pages/home.dart';
import 'package:login_authentication_2/login_page.dart';
import 'package:login_authentication_2/password_validation.dart';
import 'package:login_authentication_2/questionnaire.dart';
import 'package:login_authentication_2/register.dart';
import 'UI/Pages/favourite_food.dart';
import 'UI/Pages/mealsfortoday.dart';
import 'UI/Splash/splash 01.dart';
import 'UI/Splash/splash00.dart';



void main()
{
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,

      home: SplashPage(),
    );
  }
}
