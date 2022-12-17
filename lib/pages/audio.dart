import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stats/stats.dart';

import '../constant/color.dart';
import '../constant/constant.dart';
import '../services/firebase_upload.dart';
import 'heart_rate.dart';

import 'dart:io';
// import 'package:audioplayers/audioplayers.dart';
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
    setState(() {
      this.freqRange.addAll(freqRange);
    });
  }

  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Center(
          child: Text(
            'Speak out the summary',
            style: GoogleFonts.poppins(
              fontSize: 18,
              textStyle: GoogleFonts.poppins(
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ),
        automaticallyImplyLeading: false,
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
                          decoration: BoxDecoration(color: Colors.red.shade300),
                          child: Center(
                            child: Text(
                              'start',
                              style: GoogleFonts.poppins(color: Colors.white),
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
                              style: GoogleFonts.poppins(color: Colors.white),
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
                          child: Center(
                            child: Text(
                              'stop',
                              style: GoogleFonts.poppins(color: Colors.white),
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
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    "General Instruction:\n$bullet Repeat the process as described on the previous page, this time stating the summary.\n$bullet To begin recording, click on the Start button. You can pause and resume recording the audio. \n$bullet Once finished, click the stop button and press the submit button to move on to the next screen.",
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
                const SizedBox(
                  height: 15.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    statusText,
                    style: const TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 30),
                  alignment: AlignmentDirectional.center,
                  child: isComplete
                      ? ElevatedButton.icon(
                          icon: const Icon(Icons.arrow_forward_ios),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                            //round shape
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                          ),
                          label: Text(
                            "Submit",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          onPressed: () {
                            play();
                          },
                        )
                      : Container(),
                ),
                isRecording && !isComplete
                    ? Application(
                        isComplete: isComplete,
                        callback: callback,
                      )
                    : const SizedBox()
              ],
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
        setState(() {
          isRecording = true;
        });
      }
    } else {
      bool s = RecordMp3.instance.pause();
      if (s) {
        statusText = "Recording pause...";
        setState(() {
          isRecording = false;
        });
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
      setState(() {
        isRecording = true;
      });
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
      // ignore: use_build_context_synchronously
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
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Submitted successfully ...!"),
    ));
    final stats = Stats.fromData(freqRange);
    print(stats.median.toString());
    FirebaseFirestore.instance.doc('data/$uuid').update({
      'min-freq': stats.min.toString(),
      'max-freq': stats.max.toString(),
      'median-freq': stats.median.toString(),
      'sd-freq': stats.standardDeviation.toString(),
      'avg-freq': stats.average.toString(),
      'audio-url': urlDownload,
    });

    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HeartRate()),
      (route) => false,
    );
  }

  int i = 0;

  Future<String> getFilePath() async {
    Directory storageDirectory = await getApplicationDocumentsDirectory();
    String sdPath = "${storageDirectory.path}/record";
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return "$sdPath/test_${i++}.mp3";
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
                  if (!widget.isComplete) freqRange.add(frequency!),
                  widget.callback(freqRange),
                },
              ),
              flutterFft.setNote = note!,
              flutterFft.setFrequency = frequency!,
              flutterFft.setOctave = octave!,
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
  void dispose() {
    flutterFft.stopRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isRecording!
              ? Text("Current note: ${note!},${octave!.toString()}",
                  style: GoogleFonts.poppins(fontSize: 25))
              : Text("Not Recording", style: GoogleFonts.poppins(fontSize: 25)),
          isRecording!
              ? Text("Current frequency: ${frequency!.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(fontSize: 25))
              : Text("Not Recording", style: GoogleFonts.poppins(fontSize: 25)),
          isRecording! && freqRange.isNotEmpty
              ? Text(
                  "Frequency range: ${quiver.min(freqRange)!.toStringAsFixed(2)} - ${quiver.max(freqRange)!.toStringAsFixed(2)}",
                  style: GoogleFonts.poppins(fontSize: 15))
              : Text("Not Recording", style: GoogleFonts.poppins(fontSize: 15)),
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
