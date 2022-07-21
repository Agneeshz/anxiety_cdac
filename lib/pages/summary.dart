import 'dart:async';
import 'dart:convert';
import 'package:anxiety_cdac/constant/endpoints.dart';
import 'package:anxiety_cdac/pages/audio.dart';
import 'package:anxiety_cdac/services/http_provider.dart';
import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool isLoading = false;
  int count = 0;
  int lenght = 0;
  int seconds = 0;
  bool flag = false;
  String summary = '';

  Timer? countdownTimer;

  void submit() async {
    final prefs = await SharedPreferences.getInstance();
    final String? uuid = prefs.getString('uuid');
    HttpProvider httpProvider = HttpProvider();
    try {
      isLoading = true;
      await httpProvider.post(spellCheck, {"summary": summary}).then((value) {
        print(value);
        FirebaseFirestore.instance.collection('data').add(jsonDecode(value));
      });

      await httpProvider
          .post(typeSpeed, {"summary": summary, "time": seconds}).then((value) {
        print(value);
        FirebaseFirestore.instance.collection('data').add(jsonDecode(value));
      });
      isLoading = false;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AudioPage(),
        ),
      );
    } catch (e) {
      isLoading = false;
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Oops please try again ....!"),
        ),
      );
    }
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
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
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
                          "Submit",
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
