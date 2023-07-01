import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/transitions.dart';
import '../../questionnaire.dart';
import '../Pages/profile_screen.dart';
import '../shared.dart';
import 'splash00.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    // Create the animation sequence
    _animation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
        reverseCurve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void showAlertDialog(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      // show Cupertino-style dialog on iOS
      showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("OOPS"),
            content: Text("Would you like to Exit the application?"),
            actions: [
              CupertinoDialogAction(
                child: Text("Continue",),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Exit'),
                isDestructiveAction: true,
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  exit(0);
                },
              ),
            ],
          );
        },
      );
    } else {
      // show Material-style dialog on Android
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("OOPS"),
            content: Text("Would you like to Exit the application?"),
            actions: [
              TextButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("Exit",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  exit(0);
                },
              ),
            ],
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {

        showAlertDialog(context);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      'assets/Salad.png',
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(0, 173, 181, 1),
                      ),
                    ),
                    Text(
                      ' ${USERDATA['name']}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                          color: Colors.black
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(SlidePageRoute(child: QuestionnaireApp()));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),),
                        color: Color.fromRGBO(0, 173, 181, 1),
                        elevation: 0,
                        minWidth: 0,
                        height: 36,
                        child: Text(
                          'Get Started',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      height: 50,
                      width: double.infinity,

                      child: MaterialButton(
                        onPressed: () {
                          Navigator.of(context).push(SlidePageRoute(child: ProfileScreen()));
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),),
                        color: Color.fromRGBO(0, 173, 181, 1),
                        elevation: 0,
                        minWidth: 0,
                        height: 36,
                        child: Text(
                          'My Profile',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w900
                          ),

                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}