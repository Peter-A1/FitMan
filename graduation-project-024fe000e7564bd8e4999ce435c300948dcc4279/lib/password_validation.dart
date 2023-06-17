import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'UI/shared.dart';
import 'login_page.dart';


class PassWordValidation extends StatefulWidget {

   PassWordValidation(this.username , this.Email);
  String username;
  String Email;



   @override
  State<PassWordValidation> createState() => _PassWordValidationState();
}

class _PassWordValidationState extends State<PassWordValidation> {

  var pwController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var confirmPassswordController = TextEditingController();
  bool passwordvisible = false;
  bool passwordvisible2 = false;
  bool checkpasswordcharLength = false;
  bool checkpasswordnum = false;
  bool checkpasswordUpper = false;
  bool checkpasswordSmall = false;
  bool checkpasswordSpecialChar = false;


  onPasswordChanged(String password) {
    final numregx = RegExp(r'(?=.*?[0-9])');
    final uppregex = RegExp(r'(?=.*[A-Z])');
    final smallregex = RegExp(r'(?=.*[a-z])');
    final specialregex = RegExp(r'(?=.*?[!_@#-/?+$=&*~])');
    final lengthregex = RegExp(r'.{8,}');

    setState(() {
      checkpasswordnum = false;
      if (numregx.hasMatch(password)) checkpasswordnum = true;

      checkpasswordUpper = false;
      if (uppregex.hasMatch(password)) {
        checkpasswordUpper = true;
      }
      checkpasswordSmall = false;
      if (smallregex.hasMatch(password)) {
        checkpasswordSmall = true;
      }
      checkpasswordSpecialChar = false;
      if (specialregex.hasMatch(password)) {
        checkpasswordSpecialChar = true;
      }
      checkpasswordcharLength = false;
      if (lengthregex.hasMatch(password)) {
        checkpasswordcharLength = true;
      }
    });
  }

  PostDataRegister(
      name,
      email,
      password,) async
  {
    var response = await http.post(Uri.parse("${url}register"),
        body: {
          'email': email,
          'password': password,
          'name': name,
        });
    final body = jsonDecode(response.body);
    //print(response.body);

    if (response.statusCode == 201)
    {

      Fluttertoast.showToast(
        msg: 'You have succefully registered',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromRGBO(34, 40, 49, 1),
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
    else
    {
      Fluttertoast.showToast(
        msg: body['errors']['email'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromRGBO(34, 40, 49, 1),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          size: 30, //change size on your need
          color: Colors.black, //change color on your need
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    'Set a password',
                    style: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Color.fromRGBO(0, 173, 181, 1),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text(
                    'Please follow the criteria below',
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                  child: TextFormField(
                    controller: pwController,
                    keyboardType: TextInputType.visiblePassword,
                    onChanged: (password) => onPasswordChanged(password),
                    validator: (password) {
                      if (password!.isEmpty)
                      {
                        return ' Password must not be empty ';
                      }
                      if(checkpasswordSpecialChar && checkpasswordSmall
                      && checkpasswordcharLength && checkpasswordnum
                      && checkpasswordUpper == true)
                      {
                        return null;
                      }
                      else
                        {
                          return ' Check Your Password Again ';
                        }
                    },
                    obscureText: passwordvisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 19),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color.fromRGBO(0, 173, 181, 1),
                      ),

                      suffixIcon: IconButton(
                        icon: passwordvisible
                            ? const Icon(
                                Icons.visibility_off,
                          color: Color.fromRGBO(34, 40, 49, 1),
                          size: 18,
                              )
                            : const Icon(
                                Icons.visibility,
                                color: Color.fromRGBO(34, 40, 49, 1),
                              ),
                        onPressed: () {
                          setState(() {
                            passwordvisible = !passwordvisible;
                          });
                        },
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
                      ),
                      labelText: 'Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: checkpasswordUpper
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkpasswordUpper
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Contains at least 1 upper-case'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: checkpasswordSmall
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkpasswordSmall
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Contains at least 1 lower-case'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: checkpasswordnum
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkpasswordnum
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Contains at least 1 digit'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: checkpasswordSpecialChar
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkpasswordSpecialChar
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Contains at least 1 Special-character'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: checkpasswordcharLength
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkpasswordcharLength
                                ? Border.all(color: Colors.transparent)
                                : Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(50)),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Contains at least 8 characters'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),

                  child: TextFormField(
                    controller: confirmPassswordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (password) {
                      if (password!.isEmpty)
                      {
                        return ' Password must not be empty ';
                      }
                      if(pwController.text ==
                          confirmPassswordController.text )
                      {
                        return null;
                      }
                      else
                      {
                        return ' Check Your Password Again ';
                      }
                    },
                    obscureText: passwordvisible2,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 19),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Color.fromRGBO(0, 173, 181, 1),
                      ),
                      suffixIcon: IconButton(
                        icon: passwordvisible2
                            ? const Icon(
                          Icons.visibility_off,
                          color: Color.fromRGBO(34, 40, 49, 1),
                          size: 18,
                        )
                            : const Icon(
                          Icons.visibility,
                          color: Color.fromRGBO(34, 40, 49, 1)
                        ),
                        onPressed: () {
                          setState(() {
                            passwordvisible2 = !passwordvisible2;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(0, 173, 181, 1),
                              width: 1.5
                          )
                      ),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    height: 50,
                    width: double.infinity,
                    child: MaterialButton(

                      onPressed: () {
                        if (formKey.currentState!.validate())
                        {
                          //print(globals.pwController);

                          PostDataRegister(
                              widget.username,
                              widget.Email,
                              pwController.text);

                        }
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ));*/

                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),),
                      color: const Color.fromRGBO(0, 173, 181, 1),
                      elevation: 0,
                      minWidth: 0,
                      height: 36,
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w900
                        ),
                      ),
                    ),
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

