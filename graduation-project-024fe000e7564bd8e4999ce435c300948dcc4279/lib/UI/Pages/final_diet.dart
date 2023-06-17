import 'dart:convert';

import 'package:flutter/material.dart';

import '../shared.dart';
import 'navbar.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';


class FinalDiet extends StatefulWidget {
  @override
  State<FinalDiet> createState() => _FinalDietState();
}

class _FinalDietState extends State<FinalDiet> {
  void getDataFromServer() async {
    try {
      setState(() {
        _isLoading = true; // set _isLoading to true before making the API call
      });
      final response =
          await http.get(Uri.parse('${url}${USERDATA['_id']}/DietPlan'));

      if (response.statusCode == 200) {

        final data = json.decode(response.body);
        // process the data as needed
        print(data);
        setState(() {
          USERDATA = data;
          _loadMealData(_selectedMealType);
          _isLoading =
              false; // set _isLoading back to false after the data has been fetched
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('$error');
      setState(() {
        _isLoading = false; // set _isLoading back to false in caseof an error
      });
    }
  }

  String _selectedMealType = 'breakfast';
  bool _isLoading = false;

  List<Map<String, dynamic>> _mealData = [];

  void _loadMealData(String mealType) {
    List<Map<String, dynamic>> mealData = [];

    if (USERDATA != null &&
        USERDATA['dietplan'] != null &&
        USERDATA['dietplan'].isNotEmpty) {
      if (mealType == 'breakfast' &&
          USERDATA['dietplan'][0]['breakfast'] != null) {
        mealData = List<Map<String, dynamic>>.from(
            USERDATA['dietplan'][0]['breakfast']);
      } else if (mealType == 'lunch' &&
          USERDATA['dietplan'][0]['lunch'] != null) {
        mealData =
            List<Map<String, dynamic>>.from(USERDATA['dietplan'][0]['lunch']);
      } else if (mealType == 'dinner' &&
          USERDATA['dietplan'][0]['dinner'] != null) {
        mealData =
            List<Map<String, dynamic>>.from(USERDATA['dietplan'][0]['dinner']);
      }
    }
    setState(() {
      _mealData = mealData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMealData('breakfast'); // load breakfast data initially
  }

  bool _isDataAvailable = false;
  double totalcalories = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 45),
          child: Center(
            child: Text(
              'Diet Plan',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          size: 30, //change size on your need
          color: Colors.black, //change color on your need
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _mealData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No data available",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w400
                        ),),
                      if (!_isDataAvailable)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: MaterialButton(
                            onPressed: () {
                              if (USERDATA['favbreakfast'].length < 3) {
                                Fluttertoast.showToast(
                                  msg: 'Please add more items to your breakfast section.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color.fromRGBO(34, 40, 49, 1),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else if (USERDATA['favlunch'].length < 3) {
                                Fluttertoast.showToast(
                                  msg: 'Please add more items to your lunch section.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color.fromRGBO(34, 40, 49, 1),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else if (USERDATA['favdinner'].length < 3) {
                                Fluttertoast.showToast(
                                  msg: 'Please add more items to your dinner section.',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Color.fromRGBO(34, 40, 49, 1),
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );
                              } else {
                                getDataFromServer();
                                setState(() {
                                  _isDataAvailable = true;
                                });
                              }
                            },
                            child: Text(
                              'Get your plan',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            color: Color.fromRGBO(0, 173, 181, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: Color.fromRGBO(57, 62, 70, 1),
                                  width: 2),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 22, vertical: 15),
                          ),
                        ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        MaterialButton(
                          onPressed: () {
                            _loadMealData('breakfast');
                            setState(() {
                              _selectedMealType = 'breakfast';
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedMealType == 'breakfast'
                                  ? Colors.white
                                  : // Color.fromRGBO(0, 173, 181, 1),
                                  Colors.white,
                              //width: 2,
                            ),
                          ),
                          elevation: 0,
                          minWidth: 0,
                          height: 36,
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          color: _selectedMealType == 'breakfast'
                              ? Color.fromRGBO(0, 173, 181, 1)
                              : //Color.fromRGBO(238, 238, 238, 1) ,
                              Colors.grey.shade300,
                          child: Text(
                            "Breakfast",
                            style: TextStyle(
                                color: _selectedMealType == 'breakfast'
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15.0,
                                fontWeight: _selectedMealType == 'breakfast'
                                    ? FontWeight.w900
                                    : FontWeight.w400),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _loadMealData('lunch');
                            setState(() {
                              _selectedMealType = 'lunch';
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedMealType == 'lunch'
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          ),
                          elevation: 0,
                          minWidth: 0,
                          height: 36,
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 15),
                          color: _selectedMealType == 'lunch'
                              ? Color.fromRGBO(0, 173, 181, 1)
                              : Colors.grey.shade300,
                          child: Text(
                            "Lunch",
                            style: TextStyle(
                                color: _selectedMealType == 'lunch'
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15.0,
                                fontWeight: _selectedMealType == 'lunch'
                                    ? FontWeight.w900
                                    : FontWeight.w400),
                          ),
                        ),
                        MaterialButton(
                          onPressed: () {
                            _loadMealData('dinner');
                            setState(() {
                              _selectedMealType = 'dinner';
                            });
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: _selectedMealType == 'dinner'
                                  ? Colors.white
                                  : Colors.white,
                            ),
                          ),
                          elevation: 0,
                          minWidth: 0,
                          height: 36,
                          padding: EdgeInsets.symmetric(
                              horizontal: 22, vertical: 15),
                          color: _selectedMealType == 'dinner'
                              ? Color.fromRGBO(0, 173, 181, 1)
                              : Colors.grey.shade300,
                          child: Text(
                            "Dinner",
                            style: TextStyle(
                                color: _selectedMealType == 'dinner'
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 15.0,
                                fontWeight: _selectedMealType == 'dinner'
                                    ? FontWeight.w900
                                    : FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                    // i want to print here total calories of this section
                    // Row(
                    //   children: [
                    //     Text('data')
                    //   ],
                    // ),
                    SizedBox(height: 30),

                    Expanded(
                      child: ListView.builder(
                        itemCount: _mealData.length,
                        itemBuilder: (context, index) {
                          String foodName =
                              _mealData[index]['food_item']['Food_name'];
                          List<String> words = foodName.split(
                              ' '); // Split the foodName string into individual words

// Capitalize the first letter of the first word
                          if (words.isNotEmpty && words[0].isNotEmpty) {
                            words[0] = words[0].substring(0, 1).toUpperCase() +
                                words[0].substring(1);
                          }

// Capitalize the first letter of the second word (if it exists)
                          if (words.length > 1 && words[1].isNotEmpty) {
                            words[1] = words[1].substring(0, 1).toUpperCase() +
                                words[1].substring(1);
                          }

                          String capitalizedFoodName = words.join(
                              ' '); // Join the words back to a string // Join the words back to a string

                          return Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(1),
                                  spreadRadius: 0.5,
                                  blurRadius: 5,
                                  // offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: Image.network(
                                    _mealData[index]['food_item']['image']
                                        .toString(),
                                    width: 150,
                                    height: 120,
                                    fit: BoxFit.fill,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return Container(
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Text(
                                            '404 Not Found',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          capitalizedFoodName,
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                            'Amount: ${_mealData[index]['food_item']['preferred_serving'] *
                                                double.parse(_mealData[index]['n'].toString())} '
                                            '${_mealData[index]['food_item']['measuring_unit']}',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),
                                        SizedBox(height: 4),
                                        Text(
                                            'Calories: ${_mealData[index]['food_item']['food_calories_per_preferred_serving']
                                                * _mealData[index]['n']}' +
                                                ' Kcal',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500)),

                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 50, right: 50, top: 20, bottom: 20),
                      child: MaterialButton(
                        onPressed: () {
                          // print(USERDATA['favbreakfast'].length.toString()+ " Breakfast" );
                          // print(USERDATA['favlunch'].length.toString() + ' lunch ' );
                          // print(USERDATA['favdinner'].length.toString() + ' Dinner' );

                          if (USERDATA['favbreakfast'].length < 3) {
                            Fluttertoast.showToast(
                              msg: 'Please add more items to your breakfast section.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (USERDATA['favlunch'].length < 3) {
                            Fluttertoast.showToast(
                              msg: 'Please add more items to your lunch section.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else if (USERDATA['favdinner'].length < 3) {
                            Fluttertoast.showToast(
                              msg: 'Please add more items to your dinner section.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          } else {
                            //print('else part true');
                            getDataFromServer();
                          }
                        },
                        child: Text(
                          'Get your plan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        color: Color.fromRGBO(57, 62, 70, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: Color.fromRGBO(57, 62, 70, 1),
                              width: 2),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 22, vertical: 15),
                      ),
                    ),
                  ],
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
                    SizedBox(height: 16),
                    Text(
                      'Loading...',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(0, 173, 181, 1)),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
