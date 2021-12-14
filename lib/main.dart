import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var url = Uri.parse('http://192.168.0.31/on-off.php');
var urlPingServer = Uri.parse('http://192.168.0.31/ping.php');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pnas Status',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Pnas Status'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String serverStatus = "Loading...";

  @override
  Widget build(BuildContext context) {
    Future<void> pingServer() async {
      var response = await http.post(urlPingServer);
      if (response.statusCode == 200) {
        var bodyPingServer = response.body;

        if (bodyPingServer == "true") {
          setState(() {
            serverStatus = "ON";
          });
        } else {
          setState(() {
            serverStatus = "OFF";
          });
        }
      } else {
        print('Erreur, ping pas envoyé');
      }
    }

    Timer.periodic(const Duration(seconds: 2), (timer) {
      pingServer();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Serveur Status : $serverStatus',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                _lunchServer();
              },
              child: const Text('Démarer le serveur'),
            ),
          ],
        ),
      ),
    );
  }
}

void _lunchServer() async {
  var response = await http.post(url);
  if (response.statusCode == 200) {
    print('BOOT bien envoyé');
    print('Response body: ${response.body}');
  } else {
    print('Erreur, veuillez me contacter a : leo.philip33.bordeaux@gmail.com');
  }
}
