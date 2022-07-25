import 'package:anxiety_cdac/pages/audio.dart';
import 'package:anxiety_cdac/pages/summary.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayer extends StatefulWidget {
  VideoPlayer({super.key, required this.videoId});
  String videoId;
  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watch the video'),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: YoutubePlayerController(
              initialVideoId: widget.videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
              ),
            ),
            showVideoProgressIndicator: true,
            liveUIColor: Colors.amber,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.navigate_next_rounded),
            label: const Text("Next", style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SummaryPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
