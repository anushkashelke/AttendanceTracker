

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:attendance/Services/cameraService.dart';

class MLKitService {
  static final MLKitService _cameraService = MLKitService._internal();

  factory MLKitService() {
    return _cameraService;
  }

  MLKitService._internal();

  CameraService _CameraService = CameraService();
  late FaceDetector _faceDetector;

  FaceDetector get facedetector => this._faceDetector;

  void initialize() {
    this._faceDetector = GoogleMlKit.vision.faceDetector(
      FaceDetectorOptions(
        performanceMode:
            FaceDetectorMode.accurate, //if face detection is accurate
      ),
    );
  }

  Future<List<Face>> detectFacesFromImage(CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation imageRotation = _CameraService.cameraRotation;
    final InputImageFormat inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;

    final planeData = image.planes.map(
          (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final InputImage inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    final options = FaceDetectorOptions();
    final faceDetector = FaceDetector(options: options);
    final List<Face> faces = await faceDetector.processImage(inputImage);
    /// proces the image and makes inference
    return faces;
  }
}
