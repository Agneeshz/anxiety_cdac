import 'package:anxiety_cdac/pages/audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExitPage extends StatelessWidget {
  const ExitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thank You"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton.icon(
            icon: const Icon(Icons.favorite),
            label: const Text("Close App"),
            onPressed: () {
              SystemNavigator.pop();
            }),
      ),
    );
  }
}
