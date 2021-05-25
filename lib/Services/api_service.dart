import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:kaffebotapp/Model/odometry.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:io';

class ApiService {
  String baseURL = "http://api.weatherapi.com/v1";
  String key = "d42f68f43dc64f1e90d175122210803LIVE";

  double removeDecimals(double number) {
    String s = number.toString();
    String ss = s.substring(0, 4);

    double parsedNumber = double.parse(ss);
    return parsedNumber;
  }

  Future<BatteryStatus> getBatteryPercent() async {
    var url = Uri.http('192.168.0.86:5000', '/battery', {'q': '{http}'});
    try {
      final response = await http.get(url);
      print("status: ${response.statusCode}");
      print("http response: ${response.body}");
      //Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        BatteryStatus status = BatteryStatus.fromJson(map);
        status.batteryVoltage = removeDecimals(status.batteryVoltage);
        status.batteryCurrent = removeDecimals(status.batteryCurrent);
        status.batteryPercent =
            (status.batteryCharge / status.batteryCapacity) * 100;
        print("BatteryPercent: ${status.batteryPercent}");
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
    channel.sink.add("1.0");
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

  Future<BatteryStatus> fetchBatteryData() async {
    String ipAddress = InternetAddress.anyIPv4.rawAddress.toString();
    print("OUR IP ADDRESS: $ipAddress");
    var url = Uri.parse('http://127.0.0.1:5000/battery');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> map = jsonDecode(response.body);
      print("battery body: ${response.body}");
      BatteryStatus status = BatteryStatus.fromJson(map);
      status.batteryPercent =
          status.batteryCharge / status.batteryCapacity * 100;
      return status;
    } else {
      return null;
    }
  }

  Future<Odometry> postMovement(String command) async {
    var url = Uri.parse('http://127.0.0.1:5000/move?command=$command');
    try {
      final response = await http.post(url);
      //Map<String, dynamic> map = jsonDecode(response.body);
      Map<String, dynamic> map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("odom response: ${response.body}");
        Odometry currentVelocity = Odometry.fromJson(map);
        return currentVelocity;
      }
      return null;
    } catch (e) {
      print("Exception caught: $e");
      return null;
    }
  }

  Future<double> fetchMovement() async {
    var url = Uri.parse('http://127.0.0.1:5000/simulatemovement');
    try {
      final response = await http.get(url);
      Map<String, dynamic> map = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print("Success");
        Odometry currentVelocity = Odometry.fromJson(map);
        return currentVelocity.linearVelocity;
      }
      return null;
    } catch (e) {
      print("Exception caught: $e");
      return null;
    }
  }
}
