// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:anxiety_cdac/widgets/loading.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:anxiety_cdac/pages/upload.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final List<CameraDescription> cameras;
  const Home({
    Key? key,
    required this.cameras,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = false;
  @override
  void initState() {
    initializeCamera(selectedCamera); //Initially selectedCamera = 0
    super.initState();
  }

  late CameraController _controller; //To control the camera
  late Future<void>
      _initializeControllerFuture; //Future to wait until camera initializes
  int selectedCamera = 1;
  File? capturedImages;

  initializeCamera(int cameraIndex) async {
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.cameras[cameraIndex],
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  Future<bool> detect(xFile) async {
    setState(() {
      isLoading = true;
    });
    final image = FirebaseVisionImage.fromFile(File(xFile.path));
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(image);

    setState(() {
      isLoading = false;
    });
    if (faces.isEmpty || faces.length > 1) {
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            backgroundColor: Colors.black,
            body: Column(
              children: [
                FutureBuilder<void>(
                  future: _initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(_controller);
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //   onPressed: () {
                      //     if (widget.cameras.length > 1) {
                      //       setState(() {
                      //         selectedCamera = selectedCamera == 0 ? 1 : 0;
                      //         initializeCamera(selectedCamera);
                      //       });
                      //     } else {
                      //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      //         content: Text('No secondary camera found'),
                      //         duration: Duration(seconds: 2),
                      //       ));
                      //     }
                      //   },
                      //   icon: const Icon(Icons.switch_camera_rounded,
                      //       color: Colors.white),
                      // ),
                      GestureDetector(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await _initializeControllerFuture;
                          var xFile = await _controller.takePicture();
                          setState(() {
                            print(xFile.path);
                            capturedImages = (File(xFile.path));
                          });
                          if (await detect(xFile)) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UploadPage(
                                  imageFile: capturedImages!,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text(
                                  "no or multiple faces detected, please try again ....!"),
                            ));
                          }
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            ),
          );
  }
}
