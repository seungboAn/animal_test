import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:animal_test/screens/home_screen.dart';
import 'package:animal_test/screens/camera_screen.dart';
import 'package:animal_test/screens/display_screen.dart';
import 'package:animal_test/screens/analyze_screen.dart';

class AppRoutes {
  static const String home = '/home';
  static const String camera = '/camera';
  static const String display = '/display';
  static const String analyze = '/analyze';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) {
          final camera =
              ModalRoute.of(context)!.settings.arguments as CameraDescription;
          return HomeScreen(camera: camera);
        },
        camera: (context) {
          final camera =
              ModalRoute.of(context)!.settings.arguments as CameraDescription;
          return CameraScreen(camera: camera);
        },
        display: (context) {
          final imagePath =
              ModalRoute.of(context)!.settings.arguments as String;
          return DisplayPictureScreen(imagePath: imagePath);
        },
        // analyze: (context) => AnalyzeScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    return null;
  }
}
