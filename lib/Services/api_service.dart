import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiService{
  String baseURL = "http://api.weatherapi.com/v1";
  String key = "d42f68f43dc64f1e90d175122210803LIVE";
  String getRequestURL = "http://api.weatherapi.com/v1/current.json?key=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no";

  Future<double> getLocalTemperature() async {
    try{
      var url = getRequestURL;
      print("searching url: $url");
      final response = await http.get(url);
      print(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      print("Json: ${map['temp_c']}");
      double totalItems = map['temp_c'];
      print("totalItems: $totalItems");
      if(response.statusCode == 200){
        return totalItems;
      }
      return null;
    } catch (e){
      print("Exception caught: $e");
      return null;
    }
  }



  //http://api.weatherapi.com/v1/current.json?key=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
  //http://api.weatherapi.com/v1/current.json%3Fkey=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
}