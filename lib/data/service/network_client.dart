import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:task_manager/app.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/login_screen.dart';

class NetworkResponse {
  final bool isSuccess;
  final int statusCode;
  final Map<String, dynamic>? data;
  final String? errorMessage;

  NetworkResponse(
      {required this.isSuccess,
      required this.statusCode,
      this.data,
      this.errorMessage});
}

class NetworkClient {
  static final Logger _logger = Logger();

  // get request

  static Future<NetworkResponse> getRequest({required String url}) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {"token": AuthController.token ?? ""};

      _preRequestLog(url, headers); // for printing in console

      Response response = await get(uri, headers: headers);

      _postRequestLog(url, response.statusCode,
          headers: response.headers,
          responseBody: response.body); // for printing in console

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else if(response.statusCode==401){
        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: "Unauthorized user. please try again "
           );



  }
      else {
        final decodedJson = jsonDecode(response.body);
        String errorMessage = decodedJson["data"] ?? "Something went wrong";

        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessage);
      }
    } catch (e) {
      _postRequestLog(url, -1);

      // _logger.e(e.toString());
      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  //post request

  static Future<NetworkResponse> postRequest(
      {required String url, Map<String, dynamic>? body}) async {
    try {
      Uri uri = Uri.parse(url);

      Map<String, String> headers = {
        "Content-type": "Application/json",
        "token": AuthController.token ?? ""
      };

      _preRequestLog(url, headers, body: body);

      Response response =
          await post(uri, headers: headers, body: jsonEncode(body));

      // _logger.i("StatusCode=>${response.statusCode}\n"
      //     "Response Header=> ${response.headers}\n"
      //     "Response Body=> ${response.body}");

      _postRequestLog(url, response.statusCode,
          headers: response.headers, responseBody: response.body);

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);

        return NetworkResponse(
          isSuccess: true,
          statusCode: response.statusCode,
          data: decodedJson,
        );
      } else if(response.statusCode==401){
        return NetworkResponse(
          isSuccess: false,
          statusCode: response.statusCode,
          errorMessage: "Unauthorized user. please try again "
        );



      }else {
        final decodedJson = jsonDecode(response.body);
        String errorMessage = decodedJson['data'] ?? 'Something went wrong';

        return NetworkResponse(
            isSuccess: false,
            statusCode: response.statusCode,
            errorMessage: errorMessage);
      }
    } catch (e) {
      _postRequestLog(url, -1, errorMassage: e.toString());
      // _logger.e(e.toString());

      return NetworkResponse(
          isSuccess: false, statusCode: -1, errorMessage: e.toString());
    }
  }

  static void _preRequestLog(String url, Map<String, dynamic> headers,
      {Map<String, dynamic>? body}) {
    _logger.i("URL=> $url\n"
        "Headers: $headers"
        "Body=>$body");
  }

  static void _postRequestLog(String url, int statusCode,
      {Map<String, dynamic>? headers,
      dynamic responseBody,
      dynamic errorMassage}) {
    if (errorMassage != null) {
      _logger.e("Url : $url"
          "StatusCode : $statusCode\n"
          "Error Message : $errorMassage\n");
    } else {
      _logger.i("Url : $url"
          "StatusCode : $statusCode\n"
          "Response Header : $headers\n"
          "Response Body : $responseBody");
    }
  }

  static Future<void> moveToLoginScreen() async {

    await AuthController.clearUserData();
    
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.navigatorKey.currentContext!,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (predicate) => false);
  }
}
