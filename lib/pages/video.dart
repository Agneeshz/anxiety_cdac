import 'package:anxiety_cdac/pages/summary.dart';
import 'package:anxiety_cdac/pages/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends StatelessWidget {
  VideoPage({Key? key}) : super(key: key);
  static String videoId = "enbNUqSZdD8";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select any video'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_filled_rounded),
                label: const Text("Video 1",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(videoId: 'hcEvB1PCTTg'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_filled_rounded),
                label: const Text("Video 2",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(videoId: '-bbFKhb_zgU'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.play_circle_filled_rounded),
                label: const Text("Video 3",
                    style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayer(videoId: '7LRH7DY1QbQ'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
