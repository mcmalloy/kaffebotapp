import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:web_socket_channel/status.dart' as status;

class ApiService {
  String baseURL = "http://api.weatherapi.com/v1";
  String key = "d42f68f43dc64f1e90d175122210803LIVE";

  Future<BatteryStatus> getBatteryPercent() async {
    var url = Uri.http('http://127.0.0.1:5000', '/battery', {'q': '{http}'});
    String getRequestURL = "http://127.0.0.1:5000/battery";
    try {
      print("searching url: $getRequestURL");
      final response = await http.get(url);
      print(response.body);
      //Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        BatteryStatus status = BatteryStatus.fromJson(map);
        return status;
      }
      return null;
    } catch (e) {
      print("Exception caught: $e");
      return null;
    }
  }

  //Ros services check det ud
  Future<bool> openConnectionToRobot() async {
    String robotURL = "192.168.1.0:9090";
    var url = Uri.http('192.168.1.0:9090', '', {'q': '{http}'});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> initializePythonClient(String url) async {
    final channel = IOWebSocketChannel.connect("ws://$url");
    var jsonBody;
    int code = 404;
    channel.sink.add("Requesting connection");
    channel.sink.close();
    await channel.stream.first.then((response) {
      print("Response: $response");
      jsonBody = response;
      Map<String, dynamic> map = jsonDecode(jsonBody);
      code = map['status'];
    });
    channel.sink.close(status.goingAway);
    if (code == 200) {
      return true;
    }
    return false;
    //channel.stream.listen((response) {print("Response: $response ");});
  }
}
