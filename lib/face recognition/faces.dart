import 'dart:io';
import 'dart:async';
//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

import '../Services/faceNetService.dart';

class DetailScreen extends StatefulWidget {
  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String selectedItem = '';
  late FileImage pickedImage;
  var imageFile;
  var tempStore;
  var result = '';
  FaceNetService _faceNetService = FaceNetService();
  bool isImageLoaded = false;
  bool isFaceDetected = false;

  List<Rect> rect = <Rect>[];

  getImageFromGallery() async {
    tempStore = await ImagePicker()
        .pickImage(source: ImageSource.camera);
    imageFile = await tempStore?.readAsBytes();
    imageFile = await decodeImageFromList(imageFile);

    setState(() {
      pickedImage = FileImage(File(tempStore!.path));
      isImageLoaded = true;
      isFaceDetected = false;
      imageFile = imageFile;
    });

    //detectFace();
  }
  Face? detectedFace;
  Future detectFace() async {
    result = '';
    final InputImage gallery_img = InputImage.fromFilePath(tempStore!.path);
    final option = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: option);
    final List<Face> faces = await faceDetector.processImage(gallery_img);
    detectedFace = faces[0];
    _faceNetService.setCurrentPrediction(imageFile, detectedFace!,false);
    if (rect.length > 0) {
      rect = <Rect>[];
    }
    for (Face face in faces) {
      rect.add(face.boundingBox);
    }

    setState(() {
      isFaceDetected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //selectedItem = ModalRoute.of(context)?.settings.arguments.toString()!;
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
        actions: [
          TextButton(
            onPressed: getImageFromGallery,
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
            //color: Colors.blue,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 100),
          isImageLoaded && !isFaceDetected
              ? Center(
                  child: Container(
                    //color: Colors.blue,
                    height: 250.0,
                    width: 250.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(File(tempStore!.path)),
                            fit: BoxFit.cover)),
                  ),
                )
              : isImageLoaded && isFaceDetected
                  ? Center(
                      child: Container(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: imageFile.width.toDouble(),
                            height: imageFile.height.toDouble(),
                            child: CustomPaint(
                              painter:
                                  FacePainter(rect: rect, imageFile: imageFile),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(result),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          detectFace();
          //detectMLFeature(selectedItem);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  List<Rect> rect;
  var imageFile;

  FacePainter({required this.rect, @required this.imageFile});

  @override
  void paint(Canvas canvas, Size size) {
    if (imageFile != null) {
      canvas.drawImage(imageFile, Offset.zero, Paint());
    }
    for (Rect rectange in rect) {
      canvas.drawRect(
        rectange,
        Paint()
          ..color = Colors.teal
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}
