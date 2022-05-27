

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FaceDetection extends StatefulWidget {
  const FaceDetection({Key? key}) : super(key: key);

  @override
  _FaceDetectionState createState() => _FaceDetectionState();
}

class _FaceDetectionState extends State<FaceDetection> {
  @override
  String selectedItem = "";
  var Image;
  var ImageFile;
  bool isFaceDetected = false;
  bool isImageLoaded = false;
  List<Rect> rectangle = [];

  void initState() {
    super.initState();
    getImageFromGallery();
  }

  getImageFromCamera() async {
    XFile? ClickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      isImageLoaded = true;
      Image = ClickedImage;
    });
  }

  getImageFromGallery() async {
    XFile? GalleryImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      isImageLoaded = true;
      ImageFile = GalleryImage;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Container(
              child: FittedBox(
                child: SizedBox(
                  width: ImageFile.width.toDouble(),
                  height: ImageFile.height.toDouble(),
                  child: CustomPaint(
                    painter:
                        FacePainter(rectangle: rectangle, ImageFile: ImageFile),
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
