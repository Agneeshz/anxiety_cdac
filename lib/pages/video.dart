import 'package:anxiety_cdac/pages/summary.dart';
import 'package:anxiety_cdac/pages/videoplayer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constant/color.dart';
import '../constant/constant.dart';

class VideoPage extends StatelessWidget {
  VideoPage({Key? key}) : super(key: key);
  static String videoId = "enbNUqSZdD8";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Select any video'),
      //   automaticallyImplyLeading: false,
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/video.json',
                width: 300,
                height: 300,
                repeat: true,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Text(
                  "Analysis of concentration and retention",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    textStyle: TextStyle(
                        color: primaryTextColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Text(
                  "General Instruction:\n$bullet Choose any of the available videos. Watch the entire clip and try to comprehend as much as you can.\n$bullet You have the option of skipping the video.\n$bullet Once finished, click the next button to move on to the next screen.",
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
              //list of tiles
              Container(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.play_arrow),
                      title: Text(
                        "Video 1",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          textStyle: TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      subtitle: Text(
                        "Duration: 8:26",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          textStyle: TextStyle(
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayer(
                              videoId: "hcEvB1PCTTg",
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.play_arrow),
                      title: Text(
                        "Video 2",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          textStyle: TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      subtitle: Text(
                        "Duration: 15:42",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          textStyle: TextStyle(
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayer(
                              videoId: "-bbFKhb_zgU",
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.play_arrow),
                      title: Text(
                        "Video 3",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          textStyle: TextStyle(
                              color: primaryTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      subtitle: Text(
                        "Duration: 7:38",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          textStyle: TextStyle(
                            color: secondaryTextColor,
                          ),
                        ),
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPlayer(
                              videoId: "7LRH7DY1QbQ",
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
