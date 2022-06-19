import 'package:flutter/material.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({Key? key}) : super(key: key);

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  int count = 0;
  int lenght = 0;

  void checkKey(len) {
    if (len < lenght) {
      count++;
    }
    lenght = len;
    print(count);
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
                onChanged: (value) => {checkKey(value.length)},
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
          ],
        ),
      ),
    );
  }
}
