import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiService{
  String baseURL = "http://api.weatherapi.com/v1";
  String key = "d42f68f43dc64f1e90d175122210803LIVE";
  String getRequestURL = "http://api.weatherapi.com/v1/current.json?key=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no";

  Future<String> getLocalTemperature() async {
    var response = await http.get(getRequestURL);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    return response.body;
  }


  //http://api.weatherapi.com/v1/current.json?key=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
  //http://api.weatherapi.com/v1/current.json%3Fkey=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
}