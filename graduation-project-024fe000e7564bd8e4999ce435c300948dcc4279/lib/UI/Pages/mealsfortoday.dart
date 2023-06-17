import 'package:flutter/material.dart';
import 'package:login_authentication_2/UI/Pages/navbar.dart';
import 'package:login_authentication_2/model/meal.dart';
import '../shared.dart';


class MealsForToday extends StatefulWidget {
  const MealsForToday({Key? key}) : super(key: key);

  @override
  State<MealsForToday> createState() => _MealsForTodayState();
}

class _MealsForTodayState extends State<MealsForToday> {

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;
    var i;


    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 40, 49, 1),
        elevation: 0,
        title: Center(
          child: Text(
            'Favourite Food',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE9E9E9),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Container(
              height: height -130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Center(
                      child: Text(
                        'Favourite Food',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 20,
                          ),


                          for (i = 0; i < meals.length && i < USERDATA['dietplan'][0]['breakfast'].length; i++)
                            SizedBox(
                              height: 300,
                              child: MealCard(
                                meal: meals[i],
                                 foodName: USERDATA['dietplan'][0]['breakfast'][i]['food_item']['Food_name'],
                              ),

                            ),





                         /* for (int i = 0; i < meals.length; i++)
                            SizedBox(
                              height: 300,
                              child: MealCard(meal: meals[i]),
                            ),*/

                        ],

                      ),


                    ),

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


class MealCard extends StatelessWidget {
  final Meal meal;
  final String foodName;


  const MealCard({required this.meal, required this.foodName});
  @override
  Widget build(BuildContext context) {


    return Container(
      margin: const EdgeInsets.only(right: 20, bottom: 30, left: 20),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: ClipRRect(
                    child: Image.asset(
                      meal.imagepath,
                      width: 150,
                      height: 150,
                      fit: BoxFit.fill,
                    ),
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10),

                  Center(
                    child: Text(foodName,
                      //meal.mealTime,
                      //USERDATA['dietplan'][0]['breakfast'][2]['food_item']['Food_name'].toString(),
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      meal.name,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      '${meal.calorieBurnt} kcal',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
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
}

void printFoodNames() {
  for (int i = 0; i < USERDATA['dietplan'][0]['breakfast'].length; i++) {
    String foodName = USERDATA['dietplan'][0]['breakfast'][i]['food_item']['Food_name'];
    print(foodName);
  }
}