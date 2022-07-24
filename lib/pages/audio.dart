import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/firebase_upload.dart';
import 'heart_rate.dart';

import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
import 'package:anxiety_cdac/pages/playaudio.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiver/iterables.dart' as quiver;
// import 'package:permission_handler/permission_handler.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({Key? key}) : super(key: key);

  @override
  _AudioPageState createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  String statusText = "";
  bool isComplete = false;
  bool isRecording = false;
  List<double> freqRange = [];
  bool isLoading = false;

  @override
  initState() {
    super.initState();
  }

  callback(List<double> freqRange) {
    this.freqRange = freqRange;
  }

  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Speak out the summary')),
        ),
        body: isLoading
            ? const LoadingScreen()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 48.0,
                            decoration:
                                BoxDecoration(color: Colors.red.shade300),
                            child: const Center(
                              child: Text(
                                'start',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () async {
                            startRecord();
                            setState(() {
                              isRecording = true;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 48.0,
                            decoration:
                                BoxDecoration(color: Colors.blue.shade300),
                            child: Center(
                              child: Text(
                                RecordMp3.instance.status == RecordStatus.PAUSE
                                    ? 'resume'
                                    : 'pause',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () {
                            pauseRecord();
                          },
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          child: Container(
                            height: 48.0,
                            decoration:
                                BoxDecoration(color: Colors.green.shade300),
                            child: const Center(
                              child: Text(
                                'stop',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          onTap: () {
                            stopRecord();
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      statusText,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      play();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 30),
                      alignment: AlignmentDirectional.center,
                      width: 100,
                      height: 50,
                      child: isComplete
                          ? const Text(
                              "Submit",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            )
                          : Container(),
                    ),
                  ),
                  isRecording && !isComplete
                      ? Application(
                          isComplete: isComplete,
                          callback: callback(freqRange),
                        )
                      : const SizedBox()
                ],
              ),
      ),
    );
  }

  Future<bool> checkPermission() async {
    // if (!await Permission.microphone.isGranted) {
    //   PermissionStatus status = await Permission.microphone.request();
    //   if (status != PermissionStatus.granted) {
    //     return false;
    //   }
    // }
    return true;
  }

  void startRecord() async {
    bool hasPermission = await checkPermission();
    if (hasPermission) {
      statusText = "Recording...";
      recordFilePath = await getFilePath();
      isComplete = false;
      RecordMp3.instance.start(recordFilePath, (type) {
        statusText = "Record error--->$type";
        setState(() {});
      });
    } else {
      statusText = "No microphone permission";
    }
    setState(() {});
  }

  void pauseRecord() {
    if (RecordMp3.instance.status == RecordStatus.PAUSE) {
      bool s = RecordMp3.instance.resume();
      if (s) {
        statusText = "Recording...";
        setState(() {});
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {});
      }
    }
  }

  void stopRecord() {
    bool s = RecordMp3.instance.stop();
    if (s) {
      statusText = "Record completed";
      setState(() {
        isComplete = true;
      });
    }
  }

  void resumeRecord() {
    bool s = RecordMp3.instance.resume();
    if (s) {
      statusText = "Recording...";
      setState(() {});
    }
  }

  late String recordFilePath;

  void play() async {
    // if (File(recordFilePath).existsSync()) {
    //   // AudioPlayer audioPlayer = AudioPlayer();
    //   // audioPlayer.play(recordFilePath, true);
    //   final duration = await player.setUrl(recordFilePath);
    //   player.play();
    // }
    // var duration = await player.setUrl(recordFilePath);
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => AudioPlayPage(
    //       path: recordFilePath,
    //       Dur: duration,
    //     ),
    //   ),
    // );
    final prefs = await SharedPreferences.getInstance();
    final String? uuid = prefs.getString('uuid');
    var destination = 'Audio/$uuid';

    setState(() {
      isLoading = true;
    });
    await Firebase.initializeApp();
    var task = FirebaseUpload.uploadFile(destination, File(recordFilePath));
    if (task == null) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("ops something went wrong ...!"),
      ));
      return;
    }
    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    setState(() {
      isLoading = false;
    });
    print('Download-Link: $urlDownload');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Submitted successfully ...!"),
    ));
    FirebaseFirestore.instance.doc('data/$uuid').update({
      // 'min-freq': min,
      // 'max-freq': max,
      'audio-url': urlDownload,
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const HeartRate(),
      ),
    );
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = storageDirectory.path + "/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath + "/test_${i++}.mp3";
  }
}

class Application extends StatefulWidget {
  Application({Key? key, required this.isComplete, required this.callback})
      : super(key: key);
  bool isComplete;
  Function callback;
  @override
  ApplicationState createState() => ApplicationState();
}

class ApplicationState extends State<Application> {
  double? frequency;
  String? note;
  int? octave;
  bool? isRecording;
  List<double> freqRange = [];

  FlutterFft flutterFft = FlutterFft();

  _initialize() async {
    print("Starting recorder...");
    // print("Before");
    // bool hasPermission = await flutterFft.checkPermission();
    // print("After: " + hasPermission.toString());

    // Keep asking for mic permission until accepted
    while (!(await flutterFft.checkPermission())) {
      flutterFft.requestPermission();
      // IF DENY QUIT PROGRAM
    }

    // await flutterFft.checkPermissions();
    await flutterFft.startRecorder();
    print("Recorder started...");
    setState(() => isRecording = flutterFft.getIsRecording);

    flutterFft.onRecorderStateChanged.listen(
        (data) => {
              print("Changed state, received: $data"),
              print(freqRange.length),
              setState(
                () => {
                  frequency = data[1] as double,
                  note = data[2] as String,
                  octave = data[5] as int,
                  freqRange.add(frequency!)
                },
              ),
              flutterFft.setNote = note!,
              flutterFft.setFrequency = frequency!,
              flutterFft.setOctave = octave!,
              widget.callback(freqRange),
              print("Octave: ${octave!.toString()}")
            },
        onError: (err) {
          print("Error: $err");
        },
        onDone: () => {print("Isdone")});
  }

  @override
  void initState() {
    isRecording = flutterFft.getIsRecording;
    frequency = flutterFft.getFrequency;
    note = flutterFft.getNote;
    octave = flutterFft.getOctave;
    super.initState();
    _initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isRecording!
              ? Text("Current note: ${note!},${octave!.toString()}",
                  style: const TextStyle(fontSize: 30))
              : const Text("Not Recording", style: TextStyle(fontSize: 35)),
          isRecording!
              ? Text("Current frequency: ${frequency!.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 30))
              : const Text("Not Recording", style: TextStyle(fontSize: 35)),
          isRecording! && freqRange.isNotEmpty
              ? Text(
                  "Frequency range: ${quiver.min(freqRange)!.toStringAsFixed(2)} - ${quiver.max(freqRange)!.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 20))
              : const Text("Not Recording", style: TextStyle(fontSize: 20)),
          // TextButton(
          //   style: ButtonStyle(
          //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const HeartRate(),
          //       ),
          //     );
          //   },
          //   child: const Text('Next Page'),
          // )
        ],
      ),
    );
  }
}
