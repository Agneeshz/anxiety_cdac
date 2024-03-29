import 'package:anxiety_cdac/constant/color.dart';
import 'package:anxiety_cdac/pages/exit.dart';
import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stats/stats.dart';

class HeartRate extends StatefulWidget {
  const HeartRate({Key? key}) : super(key: key);

  @override
  _HeartRateState createState() => _HeartRateState();
}

class _HeartRateState extends State<HeartRate> {
  bool iscompleted = false;
  bool isLoading = false;
  List<SensorValue> data = [];
  List<SensorValue> bpmValues = [];
  //  Widget chart = BPMChart(data);

  bool isBPMEnabled = false;
  Widget? dialog;
  String? uuid;

  @override
  void initState() {
    super.initState();
  }

  submit() async {
    List<double> value = [];
    for (var element in bpmValues) {
      value.add(element.value as double);
    }
    final prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString('uuid');

    setState(() {
      isLoading = true;
    });
    // await Firebase.initializeApp();
    print("working");

    final stats = Stats.fromData(value);
    print(stats.median.toString());
    FirebaseFirestore.instance.doc('data/$uuid').update({
      'min-bpm': stats.min.toString(),
      'max-bpm': stats.max.toString(),
      'mean-bpm': stats.average.toString(),
      'avg-bpm': stats.median.toString(),
      'sd-bpm': stats.standardDeviation.toString(),
    });
    // ignore: use_build_context_synchronously
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const ExitPage()),
      (route) => false,
    );
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Heart BPM',
          style: GoogleFonts.poppins(
            fontSize: 18,
            textStyle: GoogleFonts.poppins(
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const LoadingScreen()
          : Column(
              children: [
                isBPMEnabled
                    ? dialog = HeartBPMDialog(
                        context: context,
                        onRawData: (value) {
                          setState(() {
                            if (data.length >= 100) data.removeAt(0);
                            data.add(value);
                          });
                        },
                        onBPM: (value) => setState(() {
                          if (bpmValues.length >= 100) bpmValues.removeAt(0);
                          bpmValues.add(SensorValue(
                              value: value.toDouble(), time: DateTime.now()));
                        }),
                      )
                    : const SizedBox(),
                isBPMEnabled && data.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(border: Border.all()),
                        height: 180,
                        child: BPMChart(data),
                      )
                    : const SizedBox(),
                isBPMEnabled && bpmValues.isNotEmpty
                    ? Container(
                        decoration: BoxDecoration(border: Border.all()),
                        constraints: const BoxConstraints.expand(height: 180),
                        child: BPMChart(bpmValues),
                      )
                    : const SizedBox(),
                Center(
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(primaryColor),
                      //round shape
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.monitor_heart),
                    label: Text(
                      isBPMEnabled ? "Stop measurement" : "Measure BPM",
                      style: GoogleFonts.poppins(),
                    ),
                    onPressed: () => setState(
                      () {
                        if (isBPMEnabled) {
                          isBPMEnabled = false;
                        } else {
                          isBPMEnabled = true;
                          iscompleted = true;
                        }
                      },
                    ),
                  ),
                ),
                iscompleted
                    ? Center(
                        child: ElevatedButton.icon(
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
                          icon: const Icon(Icons.navigate_next_outlined),
                          label: Text(
                            "Submit",
                            style: GoogleFonts.poppins(),
                          ),
                          onPressed: () => setState(
                            () {
                              submit();
                            },
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
    );
  }
}
