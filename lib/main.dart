import 'package:flutter/material.dart';
import 'dart:io';
import 'permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

void requestPermissions() async {
  print('Requesting permission');
  await requestStoragePermission();
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
  String? sourceDirectory;
  String? destinationDirectory;

  Future<void> _pickSourceDirectory() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    setState(() {
      sourceDirectory = result;
    });
  }

  Future<void> _pickDestinationDirectory() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    setState(() {
      destinationDirectory = result;
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
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
              child: ElevatedButton(
                style: buttonStyle,
                onPressed: () async {
                  _pickSourceDirectory();
                },
                child: const Text('Choose origin directory'),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Source directory: ${sourceDirectory ?? "Not selected"}',
              ),
              const SizedBox(height: 40,),
              Container(
                child: ElevatedButton(
                  style: buttonStyle,
                  onPressed: () async {
                    _pickDestinationDirectory();
                  },
                  child: const Text('Choose final directory'),
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                'Destination directory: ${destinationDirectory ?? "Not selected"}'
              ),
              SizedBox(height: 40,),
              Container(
                child: const Text(
                  'Message area'
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
