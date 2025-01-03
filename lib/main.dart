import 'dart:async';
import 'package:animal_test/routes/route.dart';
import 'package:animal_test/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  // import dotenv
  await dotenv.load(fileName: ".env");
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.camera});
  final CameraDescription camera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animal Test',
      home: HomeScreen(camera: camera),
      routes: AppRoutes.routes,
    );
  }
}
