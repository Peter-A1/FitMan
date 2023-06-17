
//Map <String, dynamic>? userData ;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


Map<String, dynamic> USERDATA = {};

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
var url = "http://172.19.170.183:5000/";


var  name = String;
var  email = String;
var  pass = String;
var user_id = "";
var user_name = "";
var user_email = "";
var token = "";
var response;


// import 'package:shared_preferences/shared_preferences.dart';
//
// class CacheHelper{
//   static late SharedPreferences? sharedPreferences;
//
//   static init() async
//   {
//     sharedPreferences= await SharedPreferences.getInstance();
//   }
//
//   static Future<bool> Putbool({
//     required String key,
//     required bool value
//   }) async
//   {
//     return await sharedPreferences!.setBool(key, value);
//   }
//
//   static dynamic getData(
//       {
//         required String key,
//       })
//   {
//     return sharedPreferences!.get(key);
//   }
//   static  SaveData({
//     required String key,
//     required dynamic value
//   }) async
//   {
//
//
//     /*if(value is bool) return await sharedPreferences!.setBool(key, value);
//     if(value is double) return await sharedPreferences!.setDouble(key, value);
//     //if(value is Map) return await sharedPreferences!.setString(key, value.toString());
//     if(value is int) return await sharedPreferences!.setInt(key, value);
//     if(value is String) return await sharedPreferences!.setString(key, value);
//     //return await sharedPreferences!.setString(key, value);*/
//   }
//
//   static Future<bool> removeData(
//       {
//         required String key,
//       }) async
//   {
//     return await sharedPreferences!.remove(key);
//     }
// }