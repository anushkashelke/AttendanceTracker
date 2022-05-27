import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import '../Services/DataBase.dart';
import '../Services/MLKitService.dart';
import '../Services/faceNetService.dart';
class takeImage extends StatefulWidget {
  const takeImage({Key? key}) : super(key: key);

  @override
  _takeImageState createState() => _takeImageState();
}

class _takeImageState extends State<takeImage> {
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();
  bool loadingCamera = false;
  late CameraDescription cameraDescription;

  void initState() {
    super.initState();
    start();
    setState(() {

    });
  }
    void start()async {
      _setLoading(true);
      List<CameraDescription> cameras = await availableCameras();

      /// takes the front camera
      cameraDescription = cameras.firstWhere(
            (CameraDescription camera) =>
        camera.lensDirection == CameraLensDirection.front,
      );

      // start the services
      await _faceNetService.loadModel();
      await _dataBaseService.loadDB();
      _mlKitService.initialize();

      _setLoading(false);
    }
    _setLoading(bool value) {
      setState(() {
        loadingCamera = value;
      });

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child:loadingCamera?
        Center(

        )
          :Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
