

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
    //preprocessing of image
    //final camera = cameras[_cameraIndex]; // your camera instance
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation imageRotation = _CameraService.cameraRotation;
        //InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
          //  InputImageRotation.rotation0deg;

    final InputImageFormat inputImageFormat =
        //InputImageFormatValue.fromRawValue(image.format.raw) ??
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
    /* for (Face face in faces) {
      final Rect boundingBox = face.boundingBox;

      final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
      final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):
      final FaceLandmark leftEar = face.landmarks[FaceLandmarkType.leftEar]!;
      if (leftEar != null) {
        final Point<int> leftEarPos = leftEar.position;
      }

      // If classification was enabled with FaceDetectorOptions:
      if (face.smilingProbability != null) {
        final double? smileProb = face.smilingProbability;
      }

      // If face tracking was enabled with FaceDetectorOptions:
      if (face.trackingId != null) {
        final int? id = face.trackingId;
      }
    }  */
    /// proces the image and makes inference
    //List<Face> faces =
    //    await this._faceDetector.processImage(_firebaseVisionImage);
    return faces;
  }
}
