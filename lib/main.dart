import 'package:anxiety_cdac/constant/color.dart';
import 'package:anxiety_cdac/pages/audio.dart';
import 'package:anxiety_cdac/pages/heart_rate.dart';
import 'package:anxiety_cdac/pages/home.dart';
import 'package:anxiety_cdac/pages/playaudio.dart';
import 'package:anxiety_cdac/pages/summary.dart';
import 'package:anxiety_cdac/pages/video.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'constant/constant.dart';

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
    return MaterialApp(
      title: 'Face Detection',
      // home: Home(cameras: cameras),
      home: VideoPage(),
      // home: Init(
      //   cameras: cameras,
      // ),
      // home: AudioPage(),
      // home: HeartRate(),
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
      // appBar: AppBar(
      //   title: const Text('Anxiety Detection CDAC'),
      //   backgroundColor: primaryColor,
      // ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/selfie.json',
                width: 400,
                height: 400,
                repeat: true,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  "Facial Analysis",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    textStyle: TextStyle(
                        color: primaryTextColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  "Take a selfie of yourself. Keep the following points in mind as you proceed:\n$bullet Keep your face visible in the photograph.\n$bullet Make sure there is no other subject present in the picture.\n$bullet Once verified, proceed to the next screen by clicking upload.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    textStyle: TextStyle(
                      color: secondaryTextColor,
                      height: 1.5,
                    ),
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(primaryColor),
                  //round shape
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                ),
                label: Text("Open camera",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Home(cameras: widget.cameras),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
