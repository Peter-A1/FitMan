import 'dart:convert';
import 'package:flexa/components/transitions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'UI/Splash/splash 01.dart';
import 'UI/shared.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override

  bool _isLoading = false;

  PostDataLogIn(email, password) async {
    setState(() {
      _isLoading = true;
    });
    response = await http.post(Uri.parse("${url}login"),
        body: {'email': email, 'password': password});
    final Body = jsonDecode(response.body);

    if (response != null && response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final USERDATAJson = json.encode(Body);
      await prefs.setString('USERDATA', USERDATAJson);

      // check here
      Navigator.of(context).push(SlidePageRoute(child: SplashScreen()));

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
    setState(() {
      _isLoading = false;
    });


    //await _getUserResponse();
  }

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPasswordShow = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
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
                    SizedBox(
                      height: 45,
                    ),
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                                    width: 1.5))),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5),
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
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: Color.fromRGBO(34, 40, 49, 1),
                                      size: 18,
                                    )
                                  : Icon(Icons.visibility,
                                      color: Color.fromRGBO(34, 40, 49, 1)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(0, 173, 181, 1),
                                    width: 1.5))),
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
                            borderRadius: BorderRadius.circular(15),
                          ),
                          color: Color.fromRGBO(0, 173, 181, 1),
                          elevation: 0,
                          minWidth: 0,
                          height: 36,
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
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
                              Navigator.of(context).push(SlidePageRoute(child: RegisterScreen()));
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            //color: Colors.green.shade500,
                            child: Text(
                              'Register Now',
                              style: TextStyle(
                                  color: Color.fromRGBO(0, 173, 181, 1),
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w700),
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
        ),
        if (_isLoading)
          Container(
            color: Colors.white.withOpacity(0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(0, 173, 181, 1)),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.75),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
