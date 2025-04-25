import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/data/models/user_model.dart';

import '../screens/login_screen.dart';

class AuthController {

  static String? token;
  static UserModel? userModel;

  static const String _tokenKey = "token";
  static const String _userDataKey = "user-data";


  // save users information

  static Future<void>saveUserInformation(String accessToken, UserModel user) async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_tokenKey, accessToken);
    sharedPreferences.setString(_userDataKey, jsonEncode(user.toJson()));


    token = accessToken;
    userModel = user;
  }

  // get information

static Future<void>getUserInformation()async{

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? accessToken =  sharedPreferences.getString(_tokenKey);
  String? saveUserModelString= sharedPreferences.getString(_userDataKey);

  if(saveUserModelString != null ){

    UserModel saveUserModel= UserModel.fromJson(jsonDecode(saveUserModelString));

    userModel= saveUserModel;

  }



  token = accessToken;

}
  static Future<bool>checkedIfUseLoggedIn() async{


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userAccessToken = sharedPreferences.getString(_tokenKey);
    if(userAccessToken != null){

      await getUserInformation();
      return true;
    }
    return false;


  }

  static Future<void>clearUserData() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    token=null;
    userModel=null;
  }



}