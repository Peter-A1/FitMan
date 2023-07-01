import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../shared.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'navbar.dart';

class SearchBar extends StatefulWidget {
  @override
  State<SearchBar> createState() => _SearchBarState();
}
int _selectedButton = 0;
List<dynamic> _searchResults = [];

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchQuery = TextEditingController();

  bool _isSearching = false;
  String _previousSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final newSearchQuery = _searchQuery.text;
    if (newSearchQuery.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }
    // Prevents Rebuilding 3l faddy -- change only when the search query changed
    if (newSearchQuery != _previousSearchQuery) {
      setState(() {
        _isSearching = true;
        _searchResults = [];
      });
      _previousSearchQuery = newSearchQuery;
      getDataFromServer(newSearchQuery);
    }
  }

  void getDataFromServer(String Query) async {
    final response =
        await http.get(Uri.parse('${url}search/${_searchQuery.text}'));

    if (response.statusCode == 200) {
      setState(() {
        _searchResults = jsonDecode(response.body);
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }


  Widget _buildSearchField() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            controller: _searchQuery,
            autofocus: true,
            onChanged: (value) {
              setState(() {
              });
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              hintText: 'Search Here',
              hintStyle: TextStyle(color: Colors.grey[400]),
              suffixIcon: _searchQuery.text.isEmpty ?
              null :
              IconButton(
                icon: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.clear,
                    color: Colors.grey,
                    size: 25,
                  ),
                ),
                color: Colors.grey[400],
                onPressed: () {
                  _searchQuery.clear();
                  setState(() {
                  });
                },
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:Colors.grey.shade300,
                    width: 3
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color:Colors.grey.shade300,
                  width: 3
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ),
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            MaterialButton(
              onPressed: () {
                if (_selectedButton != 0) {
                  setState(() {
                    _selectedButton = 0;
                    _searchQuery.text = '';
                  });
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      color: _selectedButton == 0 ?
                      Colors.white
                          : Colors.white

                  )
              ),
              elevation: 0,
              minWidth: 0,
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              color: _selectedButton == 0?
              Color.fromRGBO(0, 173, 181, 1): Colors.grey.shade300,
              child: Text(
                "Breakfast",
                style: TextStyle(
                  color:
                  _selectedButton == 0 ? Colors.white : Colors.black,
                  fontWeight: _selectedButton == 0 ? FontWeight.w900 : FontWeight.w400,
                  fontSize: 15.0,

                ),
              ),
            ),
            SizedBox(width: 10),
            MaterialButton(
              onPressed: () {
                if (_selectedButton != 1) {
                  setState(() {
                    _selectedButton = 1;
                    _searchQuery.text = '';
                  });
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: _selectedButton == 1 ?
                      Colors.white
                      : Colors.white

                )
              ),
              elevation: 0,
              minWidth: 0,
              height: 36,
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              color: _selectedButton == 1?
                  Color.fromRGBO(0, 173, 181, 1): Colors.grey.shade300,
              child: Text(
                "Lunch",
                style: TextStyle(
                  color:
                      _selectedButton == 1 ? Colors.white : Colors.black,
                  fontWeight: _selectedButton == 1 ? FontWeight.w900 : FontWeight.w400,
                  fontSize: 15.0,

                ),
              ),
            ),
            SizedBox(width: 10),
            MaterialButton(
              onPressed: () {
                if (_selectedButton != 2) {
                  setState(() {
                    _selectedButton = 2;
                    _searchQuery.text = '';
                  });
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                      color: _selectedButton == 2 ?
                      Colors.white
                          : Colors.white

                  )
              ),
              elevation: 0,
              minWidth: 0,
              height: 36,
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 15),
              color: _selectedButton == 2?
              Color.fromRGBO(0, 173, 181, 1): Colors.grey.shade300,
              child: Text(
                "Dinner",
                style: TextStyle(
                  color:
                  _selectedButton == 2 ? Colors.white : Colors.black,
                  fontWeight: _selectedButton == 2 ? FontWeight.w900 : FontWeight.w400,
                  fontSize: 15.0,

                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
      ],
    );
  }


  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Container(
        padding: EdgeInsets.all(50.0),
        child: Text(
          'Not found',
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(

              duration: const Duration(milliseconds: 800),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: widget,
                ),
              ),
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding:
                  EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                  children: List.generate(_searchResults.length, (index) {
                    if (_searchResults.isNotEmpty) {
                      return MealCardSearch(
                        Food_id: _searchResults[index]['Food_id'],
                        image: _searchResults[index]['image'] ?? '',
                        foodName: _searchResults[index]['Food_name'],
                        unit: _searchResults[index]['measuring_unit'],
                        cal: _searchResults[index]
                        ['food_calories_per_preferred_serving']
                            .toDouble(),
                      );
                    } else {
                      return SizedBox.shrink();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 45),
          child: Center(
            child: Text('Search',
              style: TextStyle(fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          size: 30,//change size on your need
          color: Colors.black,//change color on your need
        ),

      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: _buildSearchField(),
            ),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults()
                  : Container(
                      padding: EdgeInsets.all(50),
                      child: Text(
                        'Find your food',
                        style: TextStyle(
                            color: Colors.grey[400],
                          fontSize: 22,
                          fontWeight: FontWeight.w400
                        ),
                      )),
            ),
          ],
        ),
      ),
    );
  }
}

class MealCardSearch extends StatefulWidget {
  final String foodName;
  final double cal;

  final String image;
  final int Food_id;
  final String unit;

  const MealCardSearch(
  {
    Key? key,
    required this.foodName,
    required this.cal,

    required this.image,
    required this.Food_id,
    required this.unit,

  }
  ) : super(key: key);

  @override
  _MealCardSearchState createState() => _MealCardSearchState();
}

class _MealCardSearchState extends State<MealCardSearch> {

  _toggleCheck() async {


    int foodId = widget.Food_id;

    List<int> selectedList = [];
    if (_selectedButton == 0) {
      selectedList = USERDATA['breakfast'].cast<int>();
    } else if (_selectedButton == 1) {
      selectedList = USERDATA['lunch'].cast<int>();
    } else if (_selectedButton == 2) {
      selectedList = USERDATA['dinner'].cast<int>();
    }

    if (selectedList.contains(foodId)) {
      Fluttertoast.showToast(
        msg: 'This food item has already add already.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    String endpoint = '${url}${USERDATA['_id']}/pickfood';

    Map<String, List<int>> requestBody = {
      'breakfast': [],
      'lunch': [],
      'dinner': [],
    };

    if (_selectedButton == 0) {
      requestBody['breakfast']?.add(foodId);
    } else if (_selectedButton == 1) {
      requestBody['lunch']?.add(foodId);
    } else if (_selectedButton == 2) {
      requestBody['dinner']?.add(foodId);
    }

    final response = await http.put(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      USERDATA['breakfast'] = body['breakfast'].whereType<int>().toList();
      USERDATA['lunch'] = body['lunch'].whereType<int>().toList();
      USERDATA['dinner'] = body['dinner'].whereType<int>().toList();

      USERDATA = body;
      print(requestBody);


      Fluttertoast.showToast(
        msg: 'Added to list',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: 'Error: Failed to add to list',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    setState(() {});
  }



  @override
  Widget build(BuildContext context) {


    String foodName = widget.foodName;


    if (foodName.isNotEmpty) {
      // Capitalize first letter of first word
      foodName = foodName.substring(0, 1).toUpperCase() + foodName.substring(1);
      List<String> words = foodName.split(" ");
      if (words.length > 1) {
        // Capitalize first letter of second word
        words[1] = words[1].substring(0, 1).toUpperCase() + words[1].substring(1);
      }

      foodName = words.join(" ");
    }

    return Container(

      padding: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                AspectRatio(
                  aspectRatio:2.1,
                  child: ClipRRect(
                    child: Image.network(
                      widget.image,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context,
                          Object exception,
                          StackTrace? stackTrace) {
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              'No image',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 1.0,right: 1.0
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: Text(
                            foodName,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Center(
                          child: Text(
                              "${widget.cal} Kcal",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14
                              )
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              SizedBox(width: 52,),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 11,),
                                child: ElevatedButton(
                                  onPressed: (){
                                   // print(widget.Food_id);
                                    _toggleCheck(
                                    );
                                  } ,
                                  child: Text('Add',),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color.fromRGBO(0, 173, 181, 1),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
