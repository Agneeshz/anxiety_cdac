import 'package:anxiety_cdac/pages/home.dart';
import 'package:anxiety_cdac/pages/video.dart';

import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Ensure plugin services
  await Firebase.initializeApp();
  final cameras = await availableCameras(); //Get list of available cameras

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Detection',
      home: Home(cameras: cameras),
      //home: VideoPage(),
    );
  }
}
