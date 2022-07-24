import 'package:anxiety_cdac/pages/exit.dart';
import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:heart_bpm/chart.dart';
import 'package:heart_bpm/heart_bpm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/iterables.dart' as quiver;

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
    final prefs = await SharedPreferences.getInstance();
    uuid = prefs.getString('uuid');

    setState(() {
      isLoading = true;
    });
    await Firebase.initializeApp();

    FirebaseFirestore.instance.doc('data/$uuid').update({
      'min-bpm': quiver.min(bpmValues)!,
      'max-bpm': quiver.max(bpmValues)!,
      'bmp': bpmValues,
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExitPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heart BPM'),
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
                          // chart = BPMChart(data);
                        },
                        onBPM: (value) => setState(() {
                          if (bpmValues.length >= 100) bpmValues.removeAt(0);
                          bpmValues.add(SensorValue(
                              value: value.toDouble(), time: DateTime.now()));
                        }),
                        // sampleDelay: 1000 ~/ 20,
                        // child: Container(
                        //   height: 50,
                        //   width: 100,
                        //   child: BPMChart(data),
                        // ),
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
                    icon: const Icon(Icons.favorite_rounded),
                    label: Text(
                        isBPMEnabled ? "Submit measurement" : "Measure BPM"),
                    onPressed: () => setState(() {
                      if (isBPMEnabled) {
                        isBPMEnabled = false;
                        if (iscompleted) {
                          submit();
                        }
                        // dialog.
                      } else {
                        isBPMEnabled = true;
                        setState(() {
                          iscompleted = true;
                        });
                      }
                    }),
                  ),
                ),
                // TextButton(
                //   style: ButtonStyle(
                //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                //   ),
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => const MyApp(
                //           cameras: [],
                //         ),
                //       ),
                //     );
                //   },
                //   child: const Text('Back to Home Page'),
                // )
              ],
            ),
    );
  }
}
