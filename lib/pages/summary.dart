import 'dart:async';
import 'dart:convert';
import 'package:anxiety_cdac/constant/endpoints.dart';
import 'package:anxiety_cdac/pages/audio.dart';
import 'package:anxiety_cdac/services/http_provider.dart';
import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/color.dart';
import '../constant/constant.dart';

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
      setState(() {
        isLoading = true;
      });
      await httpProvider.post(spellCheck, {"summary": summary}).then((value) {
        print(value);
        FirebaseFirestore.instance.doc('data/$uuid').update(jsonDecode(value));
      });

      await httpProvider
          .post(typeSpeed, {"summary": summary, "time": seconds}).then((value) {
        print(value);
        FirebaseFirestore.instance.doc('data/$uuid').update(jsonDecode(value));
      });
      setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AudioPage(),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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
            // appBar: AppBar(
            //   title: const Text('Enter the summary of the video'),
            //   automaticallyImplyLeading: false,
            // ),
            body: SafeArea(
              child: ListView(
                children: [
                  Lottie.asset(
                    'assets/lottie/pen.json',
                    height: 200,
                    width: 200,
                    repeat: true,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Pen down your words",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        textStyle: TextStyle(
                            color: primaryTextColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      "General Instruction:\n$bullet Make a list of everything you discovered in the previous video.\n$bullet Summarize your words. Once finished, click the submit button to move on.",
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
                  Container(
                    padding: const EdgeInsets.all(18),
                    child: TextFormField(
                      onChanged: (value) => {checkKey(value)},
                      maxLines: null,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        textStyle: TextStyle(
                          color: primaryTextColor,
                        ),
                      ),
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: primaryColor,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4.0),
                            ),
                          ),
                          label: Text("Type here",
                              style: GoogleFonts.poppins(
                                  color: primaryTextColor,
                                  fontWeight: FontWeight.w400))),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(120, 0, 120, 0),
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.arrow_forward_ios),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                        //round shape
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
                        submit();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          );
  }
}
