import 'package:flutter/material.dart';
import 'package:login_authentication_2/password_validation.dart';



class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {


  var namecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  bool checkemail = false;
  bool checkname = false;
  bool checkupper = false;
  var formkey = GlobalKey<FormState>();

  onEmailChanged(String email)
  {
    final emailregex = RegExp(r'^[\w-\\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(()
    {
      checkemail = false;
      if(emailregex.hasMatch(email))
      {
        checkemail =true;
      }

    });
  }
  onNameChanged(String name)
  {
    final nameregex = RegExp(r'^[a-zA-Z]{3,}(?: [A-Z][a-zA-Z]*){0,2}$');
    final upperegex = RegExp(r'[A-Z]');
    setState(()
    {
      checkupper = false;
      if(upperegex.hasMatch(name))
        {
          checkupper = true;


          checkname = false;
          if(nameregex.hasMatch(name)) {
            checkname = true;
          }
        }
    });
  }



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
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: const Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 50.0,
                      fontWeight: FontWeight.w900,
                        color: Color.fromRGBO(0, 173, 181, 1),
            ),
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: Text(
                    'Please fill out the following form',
                    style: TextStyle(
                      fontSize: 16.0,
                      height: 1.5,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                  child: TextFormField(
                    controller: namecontroller,
                    keyboardType: TextInputType.name,
                    onChanged: (name) => onNameChanged(name),
                    onFieldSubmitted: (String value) {
                      //print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Name must not be empty';
                      }
                      if(checkupper && checkname == true)
                      {
                        return null;
                      }
                      else
                      {
                        return ' Check Your name Again ';
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 19),
                        labelText: 'Full Name',
                      labelStyle: TextStyle(
                        color: Colors.grey,
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
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Color.fromRGBO(0, 173, 181, 1),
                        ),
                    ),

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
                            color: checkupper
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkupper
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
                      const Text('Start with a upper-case'),
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
                            color: checkname
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkname
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
                      const Text('Valid name'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 5),
                  child: TextFormField(
                    onChanged: (email) => onEmailChanged(email),
                    controller: emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    onFieldSubmitted: (String value) {
                      //print(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' Email must not be empty ';
                      }
                      if(checkemail)
                      {
                        return null;
                      }
                      else
                      {
                        return ' Check Your Email Again ';
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 19),
                      labelText: 'Email Address',
                      labelStyle: TextStyle(
                        color: Colors.grey,
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
                      prefixIcon: const Icon(
                        Icons.email,
                          color: Color.fromRGBO(0, 173, 181, 1)
                      ),
                    ),
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
                            color: checkemail
                                ? Color.fromRGBO(0, 173, 181, 1)
                                : Colors.transparent,
                            border: checkemail
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
                      const Text('Enter a valid email'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  height: 50,
                  width: double.infinity,
                  child: MaterialButton(
                    onPressed: ()
                    {
                      if (formkey.currentState!.validate())
                      {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                PassWordValidation(
                                namecontroller.text,
                                    emailcontroller.text
                            ),
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
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),),
                    color: Color.fromRGBO(0, 173, 181, 1),
                    elevation: 0,
                    minWidth: 0,
                    height: 36,
                    child: const Text(
                      'Next',
                      style:  TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w900
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

