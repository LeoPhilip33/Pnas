import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

var url = Uri.parse('http://82.64.38.173/on-off.php');
var urlPingServer = Uri.parse('http://82.64.38.173/ping.php');

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
  String serverOnOff = "Start";
  String serverImgStatus = "assets/images/serverStart.png";
  String logStatus = "";

  @override
  Widget build(BuildContext context) {
    Future<void> pingServer() async {
      setState(() {
        logStatus = "Details : Status check";
      });
      var response = await http.post(urlPingServer);
      if (response.statusCode == 200) {
        var bodyPingServer = response.body;
        if (bodyPingServer == "true") {
          setState(() {
            serverStatus = "ON";
            serverOnOff = "Stop";
            serverImgStatus = "assets/images/serverStop.png";
            logStatus = "Details :  turned on";
          });
        } else {
          setState(() {
            serverStatus = "OFF";
            serverOnOff = "Start";
            serverImgStatus = "assets/images/serverStart.png";
            logStatus = "Details : turned off";
          });
        }
      } else {
        setState(() {
          logStatus = "Details : Unable to contact the remote server";
        });
      }
    }

    void lunchServer() async {
      setState(() {
        logStatus = "Details : Information send to the server";
      });

      var response = await http.post(url);
      if (response.statusCode == 200) {
        setState(() {
          logStatus = "Details : server loading";
        });
      } else {
        setState(() {
          logStatus = "Details : ERROR ! Try again in a moment";
        });
      }
    }

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
                  margin: const EdgeInsets.only(bottom: 40.0),
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                          text: 'Server Status : ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        TextSpan(
                          text: serverStatus,
                          style: const TextStyle(
                            color: Color(0xFF74D9FF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
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
                            child: Image.asset("assets/images/ping.png"),
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
                          GestureDetector(
                            onTap: () {
                              lunchServer();
                            },
                            child: Image.asset(serverImgStatus),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              '$serverOnOff Server',
                              style: const TextStyle(
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
                Container(
                  margin: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    logStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              child: RichText(
                text: const TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Made by ',
                        style: TextStyle(color: Colors.white)),
                    TextSpan(
                      text: 'Léo Corporation',
                      style: TextStyle(
                        color: Color(0xFF74D9FF),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
