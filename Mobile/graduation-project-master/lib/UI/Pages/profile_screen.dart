import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../components/profile_info.dart';
import '../shared.dart';
import 'navbar.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var x = now.year;
    var y = now.day;
    var z = now.month;

    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Color.fromRGBO(0, 173, 181, 1),
        iconTheme: IconThemeData(
          size: 30, //change size on your need
          color: Colors.black, //change color on your need
        ),
      ),
      backgroundColor: Colors.white,
      body: //xk ? Center(child: CircularProgressIndicator()):
          Column(
        children: <Widget>[
          Container(
            height: 125,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(40)),
              child: Container(
                color: Color.fromRGBO(0, 173, 181, 1),
                padding: const EdgeInsets.only(
                    top: 10, left: 32, right: 16, bottom: 10),
                child: Column(
                  children: [
                    ListTile(
                      title: Column(
                        children: [
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            'Welcome,' ' ${USERDATA['name']}' ??
                                "FAILED TO LOAD",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '${y}/${z}/${x}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 19,
                              color: Colors.white,
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
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 40, right: 40, bottom: 20),
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      duration: const Duration(milliseconds: 800),
                      childAnimationBuilder: (widget) => SlideAnimation(
                        verticalOffset: -40,
                        child: FadeInAnimation(
                          child: widget,
                        ),
                      ),
                      children: [
                        UserInfo(
                          title: 'Gender',
                          value: USERDATA['gender'] ?? "FAILED TO LOAD",
                        ),
                        UserInfo(
                          title: 'Weight',
                          value: USERDATA['weight'].toString() + ' KG' ??
                              "FAILED TO LOAD",
                        ),
                        UserInfo(
                          title: 'Height',
                          value: USERDATA['height'].toString() + ' CM' ??
                              "FAILED TO LOAD",
                        ),
                        UserInfo(
                          title: 'Age',
                          value: USERDATA['age'].toString() ?? "FAILED TO LOAD",
                        ),
                        UserInfo(
                          title: 'Calories',
                          value:
                              USERDATA['calories'].toInt().toString() + ' KCAL',
                        ),
                        UserInfo(
                          title: 'Goal',
                          value: USERDATA['goal'].toString() == '1'
                              ? 'Lose Weight'
                              : 'Gain Weight',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
