import 'dart:io';

import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:just_audio/just_audio.dart';

// ignore: must_be_immutable
class AudioPlayPage extends StatefulWidget {
  AudioPlayPage({Key? key, required this.path, required this.Dur})
      : super(key: key);
  String path;
  var Dur;

  @override
  State<AudioPlayPage> createState() => _AudioPlayPageState();
}

class _AudioPlayPageState extends State<AudioPlayPage> {
  final CountDownController _controller = CountDownController();

  // ignore: non_constant_identifier_names
  int Audioduration = 0;
  bool completed = false;
  final player = AudioPlayer();

  int convertDuration(Duration D) {
    var dur = D.toString().split(":");
    int hrs = int.parse(dur[0]);
    int min = int.parse(dur[1]);
    int sec = int.parse(dur[2].split(".")[0]);
    print(hrs * 60 * 60 + min * 60 + sec);
    return hrs * 60 * 60 + min * 60 + sec;
  }

  @override
  void initState() {
    setState(() {
      Audioduration = convertDuration(widget.Dur!);
    });
    print(Audioduration);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularCountDownTimer(
          duration: Audioduration,

          // Countdown initial elapsed Duration in Seconds.
          initialDuration: 0,

          // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
          controller: _controller,

          // Width of the Countdown Widget.
          width: MediaQuery.of(context).size.width / 2,

          // Height of the Countdown Widget.
          height: MediaQuery.of(context).size.height / 2,

          // Ring Color for Countdown Widget.
          ringColor: Colors.grey[300]!,

          // Ring Gradient for Countdown Widget.
          ringGradient: null,

          // Filling Color for Countdown Widget.
          fillColor: Colors.purpleAccent[100]!,

          // Filling Gradient for Countdown Widget.
          fillGradient: null,

          // Background Color for Countdown Widget.
          backgroundColor: Colors.purple[500],

          // Background Gradient for Countdown Widget.
          backgroundGradient: null,

          // Border Thickness of the Countdown Ring.
          strokeWidth: 20.0,

          // Begin and end contours with a flat edge and no extension.
          strokeCap: StrokeCap.round,

          // Text Style for Countdown Text.
          textStyle: const TextStyle(
            fontSize: 33.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          // Format for the Countdown Text.
          textFormat: CountdownTextFormat.S,

          // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
          isReverse: true,

          // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
          isReverseAnimation: true,

          // Handles visibility of the Countdown Text.
          isTimerTextShown: true,

          // Handles the timer start.
          autoStart: false,

          // This Callback will execute when the Countdown Starts.
          onStart: () {
            setState(() {
              completed = false;
            });
          },

          // // This Callback will execute when the Countdown Ends.
          onComplete: () {
            setState(() {
              completed = true;
            });
          },

          // // This Callback will execute when the Countdown Changes.
          // onChange: (String timeStamp) {
          //   // Here, do whatever you want
          //   debugPrint('Countdown Changed $timeStamp');
          // },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 30,
          ),
          _button(
              title: "Listen",
              onPressed: () async {
                player.play();
                _controller.start();
              }),
          const SizedBox(
            width: 10,
          ),
          _button(
              title: "Retake",
              onPressed: () {
                player.stop();
                Navigator.pop(context);
              }),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Submit",
            onPressed: () => debugPrint("Submitted .... !"),
          ),
        ],
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.purple),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
