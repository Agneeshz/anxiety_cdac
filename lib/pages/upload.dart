import 'dart:io';

import 'package:anxiety_cdac/constant/color.dart';
import 'package:anxiety_cdac/pages/video.dart';
import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constant.dart';
import '../services/firebase_upload.dart';

// ignore: must_be_immutable
class UploadPage extends StatefulWidget {
  File imageFile;
  UploadPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: primaryColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(
                    widget.imageFile,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Text(
                    "General Instruction:\n$bullet Before proceeding, ensure that your face is clearly visible in the photograph.\n$bullet If the image is blurry, retake it.",
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
                GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    final String? uuid = prefs.getString('uuid');
                    var destination = 'images/$uuid';

                    setState(() {
                      isLoading = true;
                    });
                    await Firebase.initializeApp();
                    var task = FirebaseUpload.uploadFile(
                        destination, widget.imageFile);
                    if (task == null) {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("ops something went wrong ...!"),
                      ));
                      return;
                    }
                    final snapshot = await task.whenComplete(() {});
                    final urlDownload = await snapshot.ref.getDownloadURL();
                    setState(() {
                      isLoading = false;
                    });
                    print('Download-Link: $urlDownload');
                    FirebaseFirestore.instance.doc('data/$uuid').set(
                      {'img-url': urlDownload},
                    );
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Image uploaded successfully !"),
                    ));
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPage(),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Text(
                        "Upload Image",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
