import 'package:flutter/material.dart';
import 'package:login_authentication_2/UI/Pages/profile_screen.dart';
import 'package:login_authentication_2/UI/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'UI/Splash/splash00.dart';
import 'package:http/http.dart' as http;


class QuestionnaireApp extends StatefulWidget {
  const QuestionnaireApp({Key? key}) : super(key: key);

  @override
  _QuestionnaireAppState createState() => _QuestionnaireAppState();
}

class _QuestionnaireAppState extends State<QuestionnaireApp> {

  void overwriteMapInSharedPreferences(String key, Map<String,
      dynamic> newMap) async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic>? oldMap = prefs.getString(key) != null ?
    Map<String, dynamic>.from(json.decode(prefs.getString(key)!)) : null;
    if (oldMap != null)
    {
      oldMap.addAll(newMap);
      prefs.setString(key, json.encode(oldMap));
    }

  }
  bool _isLoading = false;

  PutDataForUser(
      gender,
      activity_level,
      weight,
      goal,
      height,
      age
      )async
  {
    try {
      // Set the '_isLoading' variable to true to indicate that the data is being fetched
      setState(() {
        _isLoading = true;
      });

      var response = await http.put(Uri.parse("${url}${USERDATA['_id']}/getstarted"),
        body: {
          'gender': gender,
          'age':age,
          'activity_level' : activity_level,
          'weight':weight,
          'height':height,
          'goal':goal,
        });
    final Body = jsonDecode(response.body);
    if(response.statusCode == 200)
      {
        print(Body);
        overwriteMapInSharedPreferences('USERDATA', Body);


        USERDATA = Body;
        print('my shared prefs');
        print(USERDATA);

        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>  ProfileScreen(),
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
    } catch (error) {
      // Handle the error if the data cannot be fetched
      print(error);
    } finally {
      // Set the '_isLoading' variable to false after the data is fetched (or after an error occurs)
      setState(() {
        _isLoading = false;
      });
    }
  }

  final _formKey = GlobalKey<FormState>();
  int _currentQuestionIndex = 0;

  List<String> _mcqAnswers = ['', '', ''];
  List<TextEditingController> _textFormControllers =
  [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  List<Map<String, Object>> _mcqQuestions =
  [
    {
      'question': 'What is your gender?',
      'answers': [
        {'text': 'Male', 'value': 'Male'},
        {'text': 'Female', 'value': 'Female'},
      ],
    },
    {
      'question': 'What is Your activity Level?',
      'answers': [
        {'text': 'Sedentary (Little to no exercise)', 'value': '1.2'},
        {'text': 'Light exercise(1-3 days per week)', 'value': '1.3'},
        {'text': 'Moderate exercise(3-5 days per week)', 'value': '1.5'},
        {'text': 'Heavy exercise(6-7 days per week)', 'value': '1.7'},
        {
          'text': 'Very Heavy exercise(twice per day extra heavy workouts)',
          'value': '1.9'
        },
      ],
    },
    {
      'question': 'What is Your Goal',
      'answers': [
        {'text': 'Lose Weight', 'value': '1'},
        {'text': 'Gain Weight', 'value': '2'},
      ],
    },
  ];

  List<Widget> _buildMCQQuestions() {

    return [
      Container(
        padding: EdgeInsets.only(top: 10,bottom: 35,left: 20,right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Questionaire',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color:Color.fromRGBO(0, 173, 181, 1),
            ),),
            SizedBox(height: 60,),
            Center(
              child: Text(
                _mcqQuestions[_currentQuestionIndex]['question'].toString(),
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      ...(_mcqQuestions[_currentQuestionIndex]['answers']
              as List<Map<String, Object>>)
          .map((answer) {
        return Container(
          padding: EdgeInsets.only(bottom: 2,left: 30,right: 30),
          child: RadioListTile(
            title: Text(answer['text'].toString()),
            value: answer['value'],
            //tileColor: Color.fromRGBO(0, 173, 181, 1),
            activeColor: Color.fromRGBO(0, 173, 181, 1),
            groupValue: _mcqAnswers[_currentQuestionIndex],
            onChanged: (value) {
              setState(() {
                _mcqAnswers[_currentQuestionIndex] = value.toString();
              });
            },
          ),
        );
      }).toList(),
      SizedBox(height: 40),


      Container(
        margin: EdgeInsets.symmetric(horizontal: 50),
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromRGBO(0, 173, 181, 1),

        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentQuestionIndex > 0)
              IconButton(
                onPressed: () {

                  setState(() {
                    _currentQuestionIndex--;
                  });
                },
                icon: Icon(Icons.arrow_back,
                color: Colors.white,
                size: 30
                  ,),


              ),
            SizedBox(width: 73,),
            if (_currentQuestionIndex == 0)
              const SizedBox(width: 5),
            if (_currentQuestionIndex == 0)
              Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
            Spacer(),
            IconButton(
              onPressed: () {
                if (_mcqAnswers[_currentQuestionIndex].isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('select an answer')),
                  );
                } else {
                  setState(() {
                    _currentQuestionIndex++;
                  });
                }
              },
              icon: Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 30,
                  ),

                ],

              ),
            ),

          ],
        ),
      ),
    ];
  }

  List<Widget> _buildTextFormQuestions() {

    String secondQuestionAnswer = _textFormControllers[1].text;
    String thirdQuestionAnswer = _textFormControllers[2].text;
    String firstQuestionAnswer = _textFormControllers[0].text;

    return [
      Padding(
        padding: EdgeInsets.only(top: 10,bottom: 35,left: 20,right: 20),
        child: Center(
          child: Text('Questionaire',
            style: TextStyle(
              fontSize: 45,
              fontWeight: FontWeight.bold,
              color:Color.fromRGBO(0, 173, 181, 1),
            ),),
        ),
      ),

      Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text('What is your age?',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),),
      ),
      SizedBox(height: 2,),
      Center(
        child: Container(
        padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 30),
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 20),
              labelText: 'Age',
              labelStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(0, 173, 181, 1),
                  width: 1.5
                ),
              ),
              prefixIcon: const Icon(
                Icons.emoji_people,
                  color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,
              ),
            ),
            controller: _textFormControllers[0],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              }
              return null;
            },
            onChanged: (value){
              setState(() {
                USERDATA['age'] = value;
              });
            },
          ),
        ),
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(left: 30,),
        child: Text('What is your weight?',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),),
      ),
      SizedBox(height: 2,),
      Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 30),
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 20),
              labelText: 'Weight',
              labelStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 173, 181, 1),
                    width: 1.5
                ),
              ),
              prefixIcon: const Icon(
                Icons.monitor_weight_outlined,
                color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,
              ),
            ),
            controller: _textFormControllers[1],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your weight';
              }
              return null;
            },
            onChanged: (value){
              setState(() {
                USERDATA['weight'] = value;
              });
            },
          ),
        ),
      ),
      SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.only(left: 30,),
        child: Text('What is your height?',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),),
      ),
      SizedBox(height: 2,),
      Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10 ,horizontal: 30),
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 20 , horizontal: 20),
              labelText: 'Height',
              labelStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: const BorderSide(
                    color: Color.fromRGBO(0, 173, 181, 1),
                    width: 1.5
                ),
              ),
              prefixIcon: const Icon(
                Icons.height,
                color: Color.fromRGBO(0, 173, 181, 1),
                size: 30,
              ),
            ),
            controller: _textFormControllers[2],
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your height';
              }
              return null;
            },
            onChanged: (value){
              setState(() {
                USERDATA['height'] = value;
              });
            },
          ),
        ),
      ),
      SizedBox(height: 60),
      Container(
        margin: EdgeInsets.symmetric(horizontal: 50),
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromRGBO(0, 173, 181, 1),

        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _currentQuestionIndex--;
                });
              },
              icon: Icon(Icons.arrow_back,
              color: Colors.white,
              size: 30,),
            ),
            MaterialButton(
              onPressed: ()   async {
                if (_formKey.currentState!.validate()) {
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   SnackBar(content: Text('All questions answered!')),
                  //
                  // );
                  PutDataForUser(
                      _mcqAnswers[0],
                      _mcqAnswers[1],
                      secondQuestionAnswer,
                      _mcqAnswers[2],
                      thirdQuestionAnswer,
                      firstQuestionAnswer
                  );

                }
              },
              child: Text('Submit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 18
              ),),
            ),
            IgnorePointer(
              ignoring: _currentQuestionIndex == _mcqQuestions.length - 1,
              child: IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.arrow_forward,
                  size: 30,
                  color: _currentQuestionIndex == _mcqQuestions.length - 1
                      ? Colors.grey
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _buildQuestions() {
    if (_currentQuestionIndex < _mcqQuestions.length) {
      return _buildMCQQuestions();
    } else {
      return _buildTextFormQuestions();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: _buildQuestions(),
                ),
              ),
            ),
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
      )



    );
  }
}

