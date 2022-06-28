import 'dart:async';

import 'package:anxiety_cdac/constant/endpoints.dart';
import 'package:anxiety_cdac/services/http_provider.dart';
import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  int count = 0;
  int lenght = 0;
  int seconds = 0;
  bool flag = false;
  String summary = '';

  Timer? countdownTimer;

  void submit() async {
    HttpProvider httpProvider = HttpProvider();
    httpProvider
        .post(spellCheck, {"summary": summary}).then((value) => print(value));

    httpProvider.post(typeSpeed, {"summary": summary, "time": seconds}).then(
        (value) => print(value));
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void setCountDown() {
    setState(() {
      seconds += 1;
    });
  }

  void checkKey(value) {
    setState(() {
      summary = value;
    });
    var len = value.length;
    if (len < lenght) {
      count++;
    }
    lenght = len;
    if (!flag && value[len - 1] != " ") {
      startTimer();
      flag = true;
    }
    if (value.length == 0 && flag) {
      flag = false;
      stopTimer();
    } else if (value[len - 1] == " " && flag) {
      flag = false;
      stopTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            const Center(
              child: Text(
                "Enter the summary of the previous video",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(18),
              child: TextFormField(
                onChanged: (value) => {checkKey(value)},
                maxLines: null,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    label: Text("Summary")),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (() {
                submit();
              }),
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
                    "Upload Image",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
