import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../shared.dart';
import 'navbar.dart';
import 'package:http/http.dart' as http;


class FavFood extends StatefulWidget {
  @override
  State<FavFood> createState() => _FavFoodState();
}

class _FavFoodState extends State<FavFood> {

  Future<void> removeFood(String mealType, int foodId) async {
    try {
      final response = await http.put(
        Uri.parse('${url}${USERDATA['_id']}/removefood'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          '$mealType': foodId,
        }),
      );


      final Body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print('Food removed successfully');
        print(response.body);
        USERDATA = Body;
        print('my shared prefs');
        print(USERDATA);
      } else {
        print('Failed to remove food: ${response.statusCode}');
      }
    } catch (e) {
      print('Error removing food: $e');
      throw Exception('Failed to remove food');
    }
  }

  String _selectedMealType = 'breakfast';
  List<Map<String, dynamic>> _mealData = [];

  void _loadMealData(String mealType) {
    List<Map<String, dynamic>> mealData = [];
    if (mealType == 'breakfast') {
      mealData = List<Map<String, dynamic>>.from(USERDATA['favbreakfast']);
    } else if (mealType == 'lunch') {
      mealData = List<Map<String, dynamic>>.from(USERDATA['favlunch']);
    } else if (mealType == 'dinner') {
      mealData = List<Map<String, dynamic>>.from(USERDATA['favdinner']);
    }
    setState(() {
      _mealData = mealData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMealData('breakfast');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 40),
          child: Center(
            child: Text(
              'Favourites',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          size: 30, //change size on your need
          color: Colors.black, //change color on your need
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  setState(() {
                    _selectedMealType = 'breakfast';
                  });
                  print(_selectedMealType.toString());
                  _loadMealData('breakfast');

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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  setState(() {
                    _selectedMealType = 'lunch';
                  });
                  print(_selectedMealType.toString());
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
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
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
                  setState(() {
                    _selectedMealType = 'dinner';
                  });
                  print(_selectedMealType.toString());
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
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
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
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
              itemCount: _mealData.length,
              itemBuilder: (context, index) {
                String foodName = _mealData[index]['Food_name'];
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

                return Dismissible(
                  key: Key(_mealData[index]['Food_id'].toString()),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (DismissDirection direction) async {
                    final bool shouldDelete = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        if (Platform.isIOS) {
                          return CupertinoAlertDialog(
                            title: Text('Confirm'),
                            content: Text('Are you sure you want to delete it?'),
                            actions: <Widget>[
                              CupertinoDialogAction(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              CupertinoDialogAction(
                                onPressed: () {
                                  removeFood(_selectedMealType.toString(),
                                      _mealData[index]['Food_id']);
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Delete'),
                                isDestructiveAction: true,
                              ),
                            ],
                          );
                        } else {
                          return AlertDialog(
                            title: Text('Confirm'),
                            content: Text('Are you sure you want to delete it?'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  removeFood(_selectedMealType.toString(),
                                      _mealData[index]['Food_id']);
                                  Navigator.of(context).pop(true);
                                },
                                child: Text('Delete',style: TextStyle(
                                  color: Colors.red,
                                ),),
                              ),
                            ],
                          );
                        }
                      },
                    );
                    return shouldDelete;
                  },
                  onDismissed: (direction) {
                    setState(() {
                      _mealData.removeAt(index);
                    });
                  },

                  background: Padding(
                    padding: const EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),

                      ),


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(16),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              )),
                        ],
                      ),
                    ),
                  ),


                  // controlling the card
                  child: Container(
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
                            _mealData[index]['image'].toString(),
                            width: 150,
                            height: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    'Amount: ${_mealData[index]['preferred_serving'].toString() + ' ' + _mealData[index]['measuring_unit'].toString()}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15)),
                                SizedBox(height: 4),
                                Text(
                                    'Calories: ${_mealData[index]['food_calories_per_preferred_serving']}' +
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
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
