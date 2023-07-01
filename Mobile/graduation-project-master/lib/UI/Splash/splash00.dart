import 'package:flutter/material.dart';

import '../../components/transitions.dart';
import '../../login_page.dart';
import '../../register.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome To Your',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900
                ),
              ),
              Text(
                'Personal Diet',
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(0, 173, 181, 1)
                ),
              ),
              Text(
                'Planner',
                style: TextStyle(fontSize: 34,
                    fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(0, 173, 181, 1)
                ),
              ),
              SizedBox(height: 24),
              Image.asset(
                'assets/Salad.png',
                width: 250,
                height: 250,
              ),
              SizedBox(height: 24),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(SlidePageRoute(child: LoginScreen()));                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Color.fromRGBO(0, 173, 181, 1),
                    elevation: 0,
                    minWidth: 0,
                    height: 36,
                    padding: EdgeInsets.symmetric(horizontal: 75, vertical: 15),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(SlidePageRoute(child: RegisterScreen()));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    color: Color.fromRGBO(0, 173, 181, 1),
                    elevation: 0,
                    minWidth: 0,
                    height: 36,
                    padding: EdgeInsets.symmetric(horizontal: 68, vertical: 15),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
