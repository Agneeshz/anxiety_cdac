import 'package:anxiety_cdac/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/constant.dart';

class ExitPage extends StatelessWidget {
  const ExitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Thank You",
          style: GoogleFonts.poppins(
            fontSize: 18,
            textStyle: GoogleFonts.poppins(
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              "Thank you !\n$bullet Your data has been collected successfully.\n$bullet You can now exit the app by pressing the exit button below.",
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
                icon: const Icon(Icons.favorite),
                label: Text(
                  "Close App",
                  style: GoogleFonts.poppins(),
                ),
                onPressed: () {
                  SystemNavigator.pop();
                }),
          ),
        ],
      ),
    );
  }
}
