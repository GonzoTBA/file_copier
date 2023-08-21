import 'package:flutter/material.dart';
import 'package:easy_folder_picker/DirectoryList.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 235, 241, 194)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'File copier'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20)
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
            margin: const EdgeInsets.only(
              top: 40.0, 
              bottom: 10.0,
              left: 20.0,
              right: 20.0),
            child: ElevatedButton(
              style: buttonStyle,
              onPressed: null,
              child: const Text('Choose origin directory'),
            ),
            ),
            Container(
            margin: const EdgeInsets.only(
              top: 20.0, 
              bottom: 40.0,
              left: 20.0,
              right: 20.0),
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: null,
                child: const Text('Choose final directory'),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: const Text(
                'Message area'
              )
            ),
          ],
        ),
      ),
    );
  }
}
