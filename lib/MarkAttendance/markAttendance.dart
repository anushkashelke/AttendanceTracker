import 'dart:math' as math;
import 'package:attendance/newStudent/newStudent.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'dart:io';
import '../Services/MLKitService.dart';
import '../Services/cameraService.dart';
import '../Services/faceNetService.dart';
import 'package:attendance/face recognition/facePainter.dart';
import '../face recognition/auth_button.dart';
import '../face recognition/cameraHeader.dart';
import '../home/home.dart';

class markAttendance extends StatefulWidget {
  final CameraDescription cameraDescription;
  const markAttendance({Key? key,required this.cameraDescription}) : super(key: key);

  @override
  State<markAttendance> createState() => _markAttendanceState();
}

class _markAttendanceState extends State<markAttendance> {
  @override
  CameraService _cameraService = CameraService();
  MLKitService _mlKitService = MLKitService();
  FaceNetService _faceNetService = FaceNetService();
  late Future FutureController; //taking future pictures in the camera
  bool isCameraInitialized = false;
  bool isFaceDetected = false;
  bool isImageTaken = false;
  bool isSaved = false;
  bool isCaptureVisible = false;
  late String imagePath;
  late Size imageSize;
  Face? detectedFace;
  late XFile imgXfile;
  void initState() {
    super.initState();
    //detectedFace = null as Face;
    _begin();
  }

  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraService.dispose();
    super.dispose();
  }

  void _begin() async {
    //initialize the camera at the beginning
    FutureController = _cameraService.startService(widget.cameraDescription);
    await FutureController; //controls the camera
    setState(() {
      isCameraInitialized = true;
    });
    putFrameOnFaces();
  }
  int count = 0;
  void putFrameOnFaces() {
    imageSize = _cameraService.getImageSize();
    _cameraService.cameraController.startImageStream((image) async {
      if (_cameraService.cameraController != null) {
        if (isSaved) {
          //if a image was already clicked but user wants to create another img , so previous shouldn't be considered
          isSaved = false;
          _faceNetService.setCurrentPrediction(image, detectedFace!, true);
        }
        if (isFaceDetected) return;
          try {
            List<Face> faces = await _mlKitService.detectFacesFromImage(image);
            print(faces.length);
            if (faces != null) {
              if (faces.length > 0) {
                isFaceDetected = true;
                setState((){
                  detectedFace = faces[0];
                  //_faceNetService.setCurrentPrediction(image, detectedFace!,true);
                  //whenClicked();
                  return;
                });

              }else {
                //for initial condition where no face was detected
                setState(() {
                  Face? detectedFace;
                });
                isFaceDetected = false;
                _begin();
              }
            }
          } catch (e) {
            isFaceDetected = false;
          }
      }
    });
  }

  Future<bool> whenClicked() async {
    if (isFaceDetected == false) {
      //await _cameraService.cameraController
         // .stopImageStream();
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(
                'No Face Detected !',
              ),
            );
          });
      return false;
    } else {
      print("When Clicked");
      print("When Clicked");
      isSaved = true;
      await Future.delayed(
          Duration(milliseconds: 500)); //will start executing after 500 ms
      await _cameraService.cameraController
          .stopImageStream(); //stops the image streaming
      await Future.delayed(Duration(milliseconds: 200));
      imgXfile = await _cameraService.takePicture();
      setState(() {
        isCaptureVisible = true; //when the image is captured
        isImageTaken = true;
        imagePath = imgXfile.path;
      });
      //reloadCamera();
      return true;
    }
  }

  onDiscardOfCapturedImage() {
    Navigator.of(context).pop();
    reloadCamera();
  }

  reloadCamera() {
    setState(() {
      isCaptureVisible = false;
      isImageTaken = false;
      isCameraInitialized = false;
      isFaceDetected = false;
    });
    _begin();
  }

  Widget build(BuildContext context) {
    final double mirror = math.pi;
    final width = MediaQuery.of(context)
        .size
        .width; //to adjust according to size of phone (also if rotated)
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        //creates stack layout widget
        children: [
          FutureBuilder<void>(
              future: FutureController,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (isImageTaken){
                    //if image is clicked display the image
                    //Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>ShowImage(image: imgXfile)),);
                    return Scaffold(
                      appBar: AppBar(
                        title: Text('New Student'),
                      ),
                      body: Column(
                        children: [
                          /*Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: width,
                              height: 500,
                              child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationY(mirror),
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  //image:FileImage(File(imagePath))
                                ),
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(File(imgXfile!.path)),
                                ),
                              ),
                            ),
                          ), */
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              color: Colors.teal,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  'Marked you as Present! '+ FaceNetService().predName+'',
                                ),
                              ),
                         ),
                          ),
                          /*TextButton(onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> newEntry(image:imgXfile),),);
                          }, child: Text('Proceed'),),
                          TextButton(onPressed: onDiscardOfCapturedImage, child: Text('Click Another Image'),), */
                        ],
                      ),
                    );
                  } else {
                    return Transform.scale(
                      scale: 1.0,
                      child: AspectRatio(
                        aspectRatio: MediaQuery.of(context).size.aspectRatio,
                        child: OverflowBox(
                          alignment: Alignment.center,
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Container(
                              width: width,
                              height: width *
                                  _cameraService
                                      .cameraController.value.aspectRatio,
                              child: Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  CameraPreview(
                                      _cameraService.cameraController),
                                  detectedFace!=null?
                                  CustomPaint(
                                    painter: FacePainter(
                                      face: detectedFace!,
                                      imageSize: imageSize,
                                    ),
                                  )
                                      :
                                  Container(
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );

                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: !isCaptureVisible
          ? AuthActionButton(
        FutureController,
        onPressed: whenClicked,
        isLogin: true,
        reload: reloadCamera,
      )
          : Container(),
    );
  }
}