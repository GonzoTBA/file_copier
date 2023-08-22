import 'package:flutter/material.dart';
import 'dart:io';
import 'permissions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';

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


  Future moveFiles(BuildContext context) async {
    // Configure Progress indicator
    ProgressDialog pr = ProgressDialog(
      context,
      type: ProgressDialogType.normal,
      isDismissible: false, // Cambia a true/false según tus necesidades
    );

    pr.style(
      message: 'Processing...', // Mensaje que se muestra en el indicador
      progressWidget: const CircularProgressIndicator(),
    );

  
    // Abort operation if no directories selected
    if (sourceDirectory == null && destinationDirectory == null) {
      const errorNoDirsSelected = SnackBar(
        content: Text('Please select both source and destination directories'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
        );
      ScaffoldMessenger.of(context).showSnackBar(errorNoDirsSelected);

      return;
    }
    // If directories properly selected, proceed.
    Directory sourceDir = Directory(sourceDirectory!);
    Directory destinationDir = Directory(destinationDirectory!);
    // Source file list
    List<FileSystemEntity> sourceFiles = sourceDir.listSync();
    // Destination file list
    List<FileSystemEntity> destinationFiles = destinationDir.listSync();
    List<String> destinationFileNames = destinationFiles.map((fileEntity) => basename(fileEntity.path)).toList();
    
    // Show progress indicator
    await pr.show();

    int counter = 0;
    for (var sourceFile in sourceFiles) {
      counter += 1;
      if (sourceFile is File) {
        String sourceFileName = basename(sourceFile.path);
        if (destinationFileNames.contains(sourceFileName)) {
          // If source file exists in destination, delete.
          await sourceFile.delete();
        } else {
          // If it doesn't, move it to destination
          await sourceFile.rename(join(destinationDir!.path, sourceFileName));
        }
      }
      double actualProgress = (counter / sourceFiles.length) * 100;
      pr.update(
        progress: actualProgress,
        message: 'Working...');
    }
    
    pr.hide();
  
    return;
}


  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20)
    );
    final ProgressDialog pr = ProgressDialog(context);
    // pr =  ProgressDialog(
    //   context,type: ProgressDialogType.download, 
    //   isDismissible: false, 
    //   showLogs: true);
    pr.style(
      message: 'Downloading file...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: const CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progress: 0.0,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
        color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
        color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
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
              const SizedBox(height: 40,),
              ElevatedButton(
                onPressed: () async {
                  await moveFiles(context);
                }, 
                child: const Text(
                  'Go'
                )),
                const SizedBox(height: 20,),
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
