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
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF1E1E1E)),
      home: const MyHomePage(title: ''),
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
      print("ping send");
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

    // Timer.periodic(const Duration(seconds: 2), (timer) {
    //   pingServer();
    // });

    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Center(
              child: Text(
                'PNAS Status',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 35,
                    color: Color(0xFF74D9FF)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    'Serveur Status : $serverStatus',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF74D9FF)),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              pingServer();
                            },
                            child: Image.asset('assets/images/ping.png'),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Refresh status',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF74D9FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Image.asset('assets/images/onOff.png'),
                          TextButton(
                            onPressed: () {
                              _lunchServer();
                            },
                            child: const Text(
                              'ON/OFF Server',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF74D9FF),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: const Text(
                'Made by Léo Corporation',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Color(0xFF74D9FF)),
              ),
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
