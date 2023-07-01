import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  final String title;
  final String value;
  final Color backgroundColor;
  final Color textColor;

  const UserInfo({
    Key? key,
    required this.title,
    required this.value,
    this.backgroundColor = const Color.fromRGBO(0, 173, 181, 1),
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 7),
        Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

// el code el adeem
// Column(
//   crossAxisAlignment: CrossAxisAlignment.start,
//   children: [
//     Text(
//       'Gender',
//       style: TextStyle(
//           color: Colors.black,
//           fontSize: 16,
//           fontWeight: FontWeight.bold),
//     ),
//     SizedBox(height: 7),
//     Container(
//       padding: EdgeInsets.symmetric(
//           vertical: 12, horizontal: 12),
//       decoration: BoxDecoration(
//         color: Color.fromRGBO(0, 173, 181, 1),
//         //border: Border.all(color: Colors.white,),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Center(
//               child: Text(
//                 USERDATA['gender'] ?? "FAILED TO LOAD",
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w700),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ],
// ),
