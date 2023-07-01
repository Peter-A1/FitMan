import 'package:flutter/material.dart';

import 'splash00.dart';

class SS extends StatefulWidget {
  const SS({Key? key}) : super(key: key);

  @override
  _SSState createState() => _SSState();
}

class _SSState extends State<SS> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _progressValue = 0.0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          _progressValue = _animationController.value * 100;
        });
      })
      ..forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => SplashPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.35),
            Center(
              child: Image.asset(
                'assets/pdf-logo.png',
                 width: 100.0,
                 height: 100.0,
                fit: BoxFit.cover ,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: const Text(
                'FLEX',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Color.fromRGBO(0, 173, 181, 1),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _animationController.value,
                      backgroundColor: Colors.grey[300],
                      valueColor:
                      const AlwaysStoppedAnimation<Color>(Color.fromRGBO(0, 173, 181, 1)),
                      minHeight: 5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${_progressValue.toStringAsFixed(0)}%',
                    style: const TextStyle(
                      color: Color.fromRGBO(0, 173, 181, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // shadows: [
                      //   Shadow(
                      //     color: Colors.grey,
                      //     blurRadius: 2,
                      //     offset: Offset(1, 1),
                      //   ),
                      // ],
                    ),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}