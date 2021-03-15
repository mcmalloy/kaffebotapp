import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kaffebotapp/Model/battery_status.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ApiService{
  String baseURL = "http://api.weatherapi.com/v1";
  String key = "d42f68f43dc64f1e90d175122210803LIVE";
  Future<BatteryStatus> getBatteryPercent() async {
    var url =
    Uri.http('http://127.0.0.1:5000', '/battery', {'q': '{http}'});
    String getRequestURL = "http://127.0.0.1:5000/battery";
    try{
      print("searching url: $getRequestURL");
      final response = await http.get(url);
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
    var url =
    Uri.http('192.168.1.0:9090', '', {'q': '{http}'});
    final response = await http.get(url);
    if(response.statusCode == 200){
      return true;
    } else {
      return false;
    }

  }

  Future<void> setupSocketStream(String message) async {
      var channel = IOWebSocketChannel.connect("ws://localhost:1234");

      channel.stream.listen((event) {
        print("socket message: $message");
        channel.sink.add(message);
      });
  }

  Future<void> socketIO() async {
    print("initializing connection to socket");
    // Dart client
    IO.Socket socket = IO.io('http://127.0.0.1:8765');
    socket.onConnect((_) {
      print('connect');
      socket.emit('msg', 'test');
    });
    socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }

  Future<void> connectToSocket() async {
    Socket socket = io('http://127.0.0.1:8765',
        OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect()  // disable auto-connection
            .setExtraHeaders({'foo': 'bar'}) // optional
            .build()
    );
    socket.connect();
  }



  //http://api.weatherapi.com/v1/current.json?key=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
  //http://api.weatherapi.com/v1/current.json%3Fkey=d42f68f43dc64f1e90d175122210803&q=Lyngby&aqi=no
}