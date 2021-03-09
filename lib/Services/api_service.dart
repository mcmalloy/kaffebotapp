import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert' as convert;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class ApiService{
  String baseURL = "http://api.weatherapi.com/v1";
  String key = "d42f68f43dc64f1e90d175122210803LIVE";

  Future<BatteryStatus> getBatteryPercent() async {
      String getRequestURL = "http://127.0.0.1:5000/battery";
    try{
      print("searching url: $getRequestURL");
      final response = await http.get(getRequestURL);
      print(response.body);
      //Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      if(response.statusCode == 200){
        BatteryStatus status = BatteryStatus.fromJson(map);
        return status;
      }
      return null;
    } catch (e){
      print("Exception caught: $e");
      return null;
    }
  }
  //Ros services check det ud
  Future<bool> openConnectionToRobot() async {
    String robotURL = "192.168.1.0:9090";

    final response = await http.get(robotURL);
    if(response.statusCode == 200){
      return true;
    } else {
      return false;
    }

  }

  Future<void> setupSocketStream() async {
      var channel = IOWebSocketChannel.connect("");

  }



  //http://api.weatherapi.com/v1/current.json?key=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
  //http://api.weatherapi.com/v1/current.json%3Fkey=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
}