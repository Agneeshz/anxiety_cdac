import 'package:anxiety_cdac/pages/audio.dart';
import 'package:anxiety_cdac/pages/home.dart';
import 'package:anxiety_cdac/pages/playaudio.dart';
import 'package:anxiety_cdac/pages/summary.dart';
import 'package:anxiety_cdac/pages/video.dart';
import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Ensure plugin services
  await Firebase.initializeApp();
  final cameras = await availableCameras(); //Get list of available cameras

  runApp(MyApp(cameras: cameras));
}
// void main() => runApp(Application());

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const MyApp({Key? key, required this.cameras}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Face Detection',
      // home: Home(cameras: cameras),
      // home: VideoPage(),
      // home: Init(
      //   cameras: cameras,
      // ),
      home: AudioPage(),
    );
  }
}

class Init extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Init({Key? key, required this.cameras}) : super(key: key);

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {
  start() async {
    final prefs = await SharedPreferences.getInstance();
    var uuid = const Uuid();
    await prefs.setString('uuid', uuid.v1());
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Home(cameras: widget.cameras),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 60),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(
                  "Take a pic",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
