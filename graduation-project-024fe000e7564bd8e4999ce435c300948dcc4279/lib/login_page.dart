import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_authentication_2/UI/Pages/profile_screen.dart';
import 'package:login_authentication_2/UI/Splash/splash%2001.dart';
import 'package:login_authentication_2/UI/Splash/splash00.dart';
import 'package:login_authentication_2/UI/shared.dart';
import 'package:login_authentication_2/questionnaire.dart';
import 'package:login_authentication_2/register.dart';
import 'package:shared_preferences/shared_preferences.dart';




class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Map<String, dynamic> USERDATA = {};
  @override
  /*void initState() {
    // TODO: implement initState
    super.initState();
    _getUserResponse();
  }

  _getUserResponse() async
  {
    final prefs = await SharedPreferences.getInstance();
    final USERDATAString = prefs.getString('USERDATA');
    if (USERDATAString != null) {
      setState(() {
        USERDATA  = json.decode(USERDATAString);
      });
    }
  }*/

  PostDataLogIn(email, password) async {
    response = await http.post(Uri.parse("${url}login"),
        body: {'email': email, 'password': password});
    final Body = jsonDecode(response.body);

    if (response != null && response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final USERDATAJson = json.encode(Body);
      await prefs.setString('USERDATA', USERDATAJson);

      // check here
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SplashScreen(),
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

      print('Body of response ');
      print(Body);
      print('g\n\n\n\n\n');
      USERDATA = Body;
      print('USERDATA');
      print(USERDATA);
    } else if (Body['errors']['password'] == 'That password is not correct') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong Password')),
      );
    } else if (Body['errors']['email'] == 'That email is not registered') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Wrong Email')),
      );
    }

    //await _getUserResponse();
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          size: 30, //change size on your need
          color: Colors.black, //change color on your need
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 45,),
                Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(
                        fontSize: 50.0,
                        fontWeight: FontWeight.w900,
                        color: Color.fromRGBO(0, 173, 181, 1)),
                  ),
                ),
                SizedBox(
                  height: 70,
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                  child: TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (String value) {
                      print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email address must not be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 19),
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Color.fromRGBO(0, 173, 181, 1),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),

                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(
                          color: Color.fromRGBO(0, 173, 181, 1),
                          width: 1.5
                        )
                      )
                    ),
                  ),

                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                  child: TextFormField(
                    controller: passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: isPasswordShow,
                    onFieldSubmitted: (value) {
                      print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password must not be empty';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 19),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color.fromRGBO(0, 173, 181, 1),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPasswordShow = !isPasswordShow;
                          });
                        },
                        icon: isPasswordShow
                            ? Icon(Icons.visibility_off,
                          color: Color.fromRGBO(34, 40, 49, 1),
                          size: 18,
                        )
                            : Icon(Icons.visibility,
                            color: Color.fromRGBO(34, 40, 49, 1)
                        ),
                      ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),

                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Color.fromRGBO(0, 173, 181, 1),
                                width: 1.5
                            )
                        )
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          PostDataLogIn(
                            emailController.text,
                            passwordController.text,
                          );
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),),
                      color: Color.fromRGBO(0, 173, 181, 1),
                      elevation: 0,
                      minWidth: 0,
                      height: 36,
                      child: Text(
                        'Sign in',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w900
                        ),

                      ),


                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account ?',
                        style: TextStyle(
                          fontSize: 14.0,
                          //height: 1.5,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        height: 20,
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => RegisterScreen(),
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
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        //color: Colors.green.shade500,
                        child: Text(
                          'Register Now',
                          style: TextStyle(
                            color: Color.fromRGBO(0, 173, 181, 1),
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
