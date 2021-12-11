import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                _launchURL();
                debugPrint("Data send");
              },
              child: const Text('Démarer le serveur'),
            ),
          ],
        ),
      ),
    );
  }
}

var url = Uri.parse('http://192.168.0.31/');

void _launchURL() async {
  var response = await http.post(url);
  if (response.statusCode == 200) {
    print('Requete bien envoyé');
  } else {
    print('Erreur, veuillez me contacter a : leo.philip33.bordeaux@gmail.com');
  }
  print('Response body: ${response.body}');
}
