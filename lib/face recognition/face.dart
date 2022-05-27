import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attendance/Utils/Image_picker.dart';
import 'dart:io';

class FaceRecognition extends StatefulWidget {
  const FaceRecognition({Key? key}) : super(key: key);

  @override
  _FaceRecognitionState createState() => _FaceRecognitionState();
}

class _FaceRecognitionState extends State<FaceRecognition> {
  @override
  var ImageFile;
  bool isImageLoaded = false;
  bool isFaceDetected = false;
  final ImagePicker _picker = ImagePicker();
  late File Image;
  List<Rect> rectangle = [];
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SimpleDialog(
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(25.0),
                child: const Text('Choose From Gallery'),
                onPressed: () async {
                  //async is used where we need to await the file that can be returned
                  Navigator.of(context).pop();
                  // Pick an image
                  final File image = await _picker.pickImage(
                      source: ImageSource.gallery) as File;
                  ImageFile = image;
                  setState(() {
                    Image = image;
                    isImageLoaded = true;
                    isFaceDetected = true;
                  });
                  final InputImage gallery_img = InputImage.fromFile(image);
                  final option = FaceDetectorOptions();
                  final faceDetector = FaceDetector(options: option);
                  //final GalleryImage = FirebaseVisionImage.fromFile(image);
                  final List<Face> faces =
                      await faceDetector.processImage(gallery_img);
                  if (rectangle.length > 0) {
                    rectangle = [];
                  }
                  for (Face face in faces) {
                    rectangle.add(face
                        .boundingBox); //to add a rectangle on face detection
                  }
                  /* final Rect boundingBox = face.boundingBox;

                    final double? rotY = face
                        .headEulerAngleY; // Head is rotated to the right rotY degrees
                    final double? rotZ = face
                        .headEulerAngleZ; // Head is tilted sideways rotZ degrees

                    // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
                    // eyes, cheeks, and nose available):
                    final FaceLandmark leftEar =
                        face.landmarks[FaceLandmarkType.leftEar]!;
                    if (leftEar != null) {
                      final Point<double> leftEarPos =
                          leftEar.position as Point<double>;
                    }

                    // If classification was enabled with FaceDetectorOptions:
                    if (face.smilingProbability != null) {
                      final double? smileProb = face.smilingProbability;
                    }

                    // If face tracking was enabled with FaceDetectorOptions:
                    if (face.trackingId != null) {
                      final int? id = face.trackingId;
                    } */

                  /*setState(() {
              _image = ImageFromGallery;
            }); */
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(25.0),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  // Capture a photo
                  final File cam = await _picker.pickImage(
                      source: ImageSource.camera) as File;
                  InputImage inp_img = InputImage.fromFile(cam);
                  final option = FaceDetectorOptions();
                  final faceDetector = FaceDetector(options: option);
                  final List<Face> faces =
                      await faceDetector.processImage(inp_img);
                  if (rectangle.length > 0) {
                    rectangle = [];
                  }
                  for (Face face in faces) {
                    rectangle.add(face.boundingBox);
                  }
                  setState(() {
                    isFaceDetected = true;
                  });
                },
              ),
            ],
          ),
          isImageLoaded && !isFaceDetected
              ? Center(
                  child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: FileImage(Image), fit: BoxFit.cover)),
                  ),
                )
              : isImageLoaded && isFaceDetected
                  ? Center(
                      child: Container(
                        child: FittedBox(
                          child: SizedBox(
                            width: ImageFile.width.toDouble(),
                            height: ImageFile.height.toDouble(),
                            child: CustomPaint(
                              painter: FacePainter(
                                  rectangle: rectangle, ImageFile: ImageFile),
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      child: Text(
                        'I am here',
                      ),
                    ),
        ],
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  //TO ADD A RECTANGLE TO THE DETECTED FACE
  List<Rect> rectangle = [];
  var ImageFile;
  FacePainter({required this.rectangle, required this.ImageFile});

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    if (ImageFile != null) {
      canvas.drawImage(ImageFile, Offset.zero, Paint());
    }
    for (Rect rect in rectangle) {
      canvas.drawRect(
        rect,
        Paint()
          ..color = Colors.blue
          ..strokeWidth = 6.0
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    throw UnimplementedError();
  }
}
