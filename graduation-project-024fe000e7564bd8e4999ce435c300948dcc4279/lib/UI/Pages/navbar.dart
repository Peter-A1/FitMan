import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login_authentication_2/UI/Pages/favourite_food.dart';
import 'package:login_authentication_2/UI/Pages/final_diet.dart';
import 'package:login_authentication_2/UI/Pages/profile_screen.dart';
import 'package:login_authentication_2/UI/Pages/search_bar.dart';
import 'package:login_authentication_2/UI/Splash/splash00.dart';
import 'package:login_authentication_2/questionnaire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    Future<void> logout(BuildContext context) async {
      // Display alert dialog
      bool confirmLogout = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Confirm Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: () {

                Navigator.of(context).pop(true);
              },
            ),
          ],
        ),
      );

      // If user confirmed logout, clear SharedPreferences and navigate to login screen
      if (confirmLogout == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SplashPage()),
              (route) => false,
        );
      }
    }
    return ClipRRect(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(35)),
      child: Drawer(
        width: 225,
        backgroundColor:Colors.white ,
        child: ListView (
          padding: EdgeInsets.only(top: 200,bottom: 100),
          children: [
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,
              ),
              title: const Text('Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              onTap: ()
              {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>  ProfileScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },

            ),
            Divider(
                color: Colors.grey,
            ),
            ListTile(
              leading: const Icon(
                Icons.question_mark_sharp,
                color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,
              ),
              title: const Text('Get Started',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
              onTap: ()
              {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>  QuestionnaireApp(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },

            ),
            Divider(
              color: Colors.grey,
            ),


            ListTile(
                leading: const Icon(
                  Icons.fastfood_sharp,
                  color: Color.fromRGBO(0, 173, 181, 1),
                  size: 30,
                ),
                title: const Text('Today\'s meals ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                )),
                onTap: () {


                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>  FinalDiet(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          var begin = Offset(1.0, 0.0);
                          var end = Offset.zero;
                          var curve = Curves.ease;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                          return SlideTransition(
                            position: animation.drive(tween),
                            child: child,
                          );
                        },
                      ),
                    );

                }
            ),
            Divider(
              color: Colors.grey,

            ),

            ListTile(
              leading: Icon(Icons.search_outlined,
                color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,
              ),
              title: Text('Search',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20
              ),),
              onTap: ()
              {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>  SearchBar(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },

            ),
            Divider(
              color: Colors.grey,
            ),

            ListTile(
              leading: const Icon(
                  Icons.favorite_outline,
                  color: Color.fromRGBO(0, 173, 181, 1),
                  size: 30),
              title: const Text('Favourite Food',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              onTap: ()
              {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>  FavFood(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      var begin = Offset(1.0, 0.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  ),
                );
              },

            ),
            Divider(
              color: Colors.grey,
            ),

            ListTile(
              leading: const Icon(
                Icons.logout_rounded,
                color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,),
              title: const Text('Logout',style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,fontSize: 20
              ),),
              onTap: ()
              {
                logout(context);
              },

            ),
            Divider(
              color: Colors.grey,
            ),

            ListTile(
              leading: const Icon(Icons.exit_to_app_sharp,
                color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,),
              title: const Text('Exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),),
              onTap: () async {
                bool confirmExit = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Confirm Exit"),
                    content: Text("Are you sure you want to exit?"),
                    actions: [
                      TextButton(
                        child: Text("No"),
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                      ),
                      TextButton(
                        child: Text("Yes"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                );
                if (confirmExit == true) {
                  if (Platform.isAndroid || Platform.isIOS) {
                    exit(0);
                  }
                }
              },

            ),
          ],
        ),
      ),
    );
  }
}
