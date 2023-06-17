import 'package:flutter/material.dart';
import 'package:login_authentication_2/UI/Pages/navbar.dart';
import 'package:login_authentication_2/model/meal.dart';
import 'shared.dart';

class zooz extends StatefulWidget {
  const zooz({Key? key}) : super(key: key);

  @override
  State<zooz> createState() => _zoozState();
}

class _zoozState extends State<zooz> {
  @override
  Widget build(BuildContext context) {
    var i;
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(34, 40, 49, 1),
        elevation: 0,
        title: Center(
          child: Text(
            'Diet-Plan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFE9E9E9),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text(
                      'BREAKFAST',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          for (i = 0;
                              i < meals.length &&
                                  i < USERDATA['dietplan'][0]['breakfast']
                                          .length;
                              i++)
                            SizedBox(
                              height: 300,
                              child: MealCard(
                                meal: meals[i],
                                foodName: USERDATA['dietplan'][0]['breakfast']
                                    [i]['food_item']['Food_name'],
                                cal: USERDATA['dietplan'][0]['breakfast'][i]
                                        ['food_item'] 
                                    ['food_calories_per_preferred_serving'],
                                category: USERDATA['dietplan'][0]['breakfast']
                                    [i]['food_item']['category'],
                                image: USERDATA['dietplan'][0]['breakfast']
                                [i]['food_item']['image'],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              //color: Colors.blueGrey,
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text(
                      'LUNCH',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          for (i = 0;
                              i < meals.length &&
                                  i < USERDATA['dietplan'][0]['lunch'].length;
                              i++)
                            SizedBox(
                              height: 300,
                              child: MealCard(
                                meal: meals[i],
                                foodName: USERDATA['dietplan'][0]['lunch'][i]
                                    ['food_item']['Food_name'],
                                cal: USERDATA['dietplan'][0]['lunch'][i]
                                        ['food_item']
                                    ['food_calories_per_preferred_serving'],
                                category: USERDATA['dietplan'][0]['lunch'][i]
                                    ['food_item']['category'],
                                image: USERDATA['dietplan'][0]['lunch']
                                [i]['food_item']['image'],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text(
                      'DINNER',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          for (i = 0;
                              i < meals.length &&
                                  i < USERDATA['dietplan'][0]['dinner'].length;
                              i++)
                            SizedBox(
                              height: 300,
                              child: MealCard(
                                meal: meals[i],
                                foodName: USERDATA['dietplan'][0]['dinner'][i]
                                    ['food_item']['Food_name'],
                                cal: USERDATA['dietplan'][0]['dinner'][i]
                                        ['food_item']
                                    ['food_calories_per_preferred_serving'],
                                category: USERDATA['dietplan'][0]['dinner'][i]
                                    ['food_item']['category'],
                                image: USERDATA['dietplan'][0]['dinner']
                                [i]['food_item']['image'],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*Container(
              height: 330,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: 8,
                      left: 32,
                      right: 16,
                    ),
                    child: Text(
                      'SNACK',
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 8,
                          ),
                          for (i = 0; i < meals.length && i < USERDATA['dietplan'][0]['breakfast'].length; i++)
                            SizedBox(
                                height: 300,
                                child: MealCard(
                                  meal: meals[i],
                                  foodName: USERDATA['dietplan'][0]['breakfast'][i]['food_item']['Food_name'],
                                ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}

class MealCard extends StatelessWidget {
  final Meal meal;
  final String foodName;
  final int cal;
  final String category;
  final String image;

  const MealCard({
    super.key,
    required this.meal,
    required this.foodName,
    required this.cal,
    required this.category,
    required this.image,
  });

  @override
  Widget build(BuildContext context)
  {
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 5, left: 15, right: 15),
      child: Material(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: ClipRRect(
                child: Image.network(
                  image,
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 12.0,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    foodName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    category,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "${cal} kcal",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.blueGrey,
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
