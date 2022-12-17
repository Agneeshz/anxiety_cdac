import 'package:anxiety_cdac/constant/color.dart';
import 'package:anxiety_cdac/pages/audio.dart';
import 'package:anxiety_cdac/pages/summary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      // appBar: AppBar(
      //   title: const Text('Watch the video'),
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
            height: 30,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.arrow_forward_ios),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(primaryColor),
              //round shape
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            label: Text(
              "Next",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const SummaryPage(),
              //   ),
              // );
              //navigate to summary page and destroy this screen
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SummaryPage()),
                  (route) => false);
            },
          ),
        ],
      ),
    );
  }
}
