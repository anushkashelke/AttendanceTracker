import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:tflite_flutter/tflite_flutter.dart' as tflite;
import 'package:image/image.dart' as imglib;

import '../Firebase/StorageMethods.dart';
import '../home/home.dart';

class FaceNetService {
  // singleton boilerplate

  static final FaceNetService _faceNetService = FaceNetService._internal();

  factory FaceNetService() {
    return _faceNetService;
  }
  // singleton boilerplate
  FaceNetService._internal();

  tflite.Interpreter? _interpreter;
  double threshold = 1.0;

  List _predictedData = [];
  List get predictedData => this._predictedData;
  String predUid = '';
  String predName = '';

  Future loadModel() async {
    try {
      //_dataBaseService.cleanDB();
      print("Entered in this class loadModel");
      final gpuDelegateV2 = tflite.GpuDelegateV2(
          options: tflite.GpuDelegateOptionsV2(
        isPrecisionLossAllowed: false,
        inferencePriority1: tflite.TfLiteGpuInferencePriority.minLatency,
        inferencePriority2: tflite.TfLiteGpuInferencePriority.auto,
        inferencePriority3: tflite.TfLiteGpuInferencePriority.auto,
        inferencePreference: tflite.TfLiteGpuInferenceUsage.fastSingleAnswer,
      ));

      var interpreterOptions = tflite.InterpreterOptions()
        ..addDelegate(gpuDelegateV2);
      this._interpreter = await tflite.Interpreter.fromAsset(
          'mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Failed to load model.');
      print(e);
    }
  }

  setCurrentPrediction(CameraImage cameraImage, Face face, bool topredict) {
    loadModel();
    print("Entered in this class set current");

    /// crops the face from the image and transforms it to an array of data
    List input = preProcess(cameraImage, face);
    //print(input);
    /// then reshapes input and ouput to model format
    //var resize = Bitmap.createScaledBitmap(*input image*, 180, 180, true)
    input = input.reshape([1, 112, 112, 3]);
    List output = List.filled(1 * 192, null, growable: false)
        .reshape([1, 192]); //List.generate(1, (index) => List.filled(192, 0));
    print("output");

    /// runs and transforms the data
    this._interpreter!.run(input, output);
    print(_interpreter);
    output = output.reshape([192]);
    print(output);
    this._predictedData = List.from(output);
    if (topredict) {
      predict();
    }
  }

  /// takes the predicted data previously saved and do inference
  Future<String> predict() {
    /// search closer user prediction if exists
    return _searchResult(this._predictedData);
  }

  /// _preProess: crops the image to be more easy
  /// to detect and transforms it to model input.
  /// [cameraImage]: current image
  /// [face]: face detected
  List preProcess(CameraImage image, Face faceDetected) {
    // crops the face 💇
    print("Entered in this class pre process");
    imglib.Image croppedImage = _cropFace(image, faceDetected);
    imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);
    // transforms the cropped face to array data
    Float32List imageAsList = imageToByteListFloat32(
      img,
    );
    return imageAsList;
  }

  /// crops the face from the image 💇
  /// [cameraImage]: current image
  /// [face]: face detected
  _cropFace(CameraImage image, Face faceDetected) {
    imglib.Image convertedImage = _convertCameraImage(image);
    double x = faceDetected.boundingBox.left - 10.0;
    double y = faceDetected.boundingBox.top - 10.0;
    double w = faceDetected.boundingBox.width + 10.0;
    double h = faceDetected.boundingBox.height + 10.0;
    return imglib.copyCrop(
        convertedImage, x.round(), y.round(), w.round(), h.round());
  }

  /// converts ___CameraImage___ type to ___Image___ type
  /// [image]: image to be converted
  imglib.Image _convertCameraImage(CameraImage image) {
    print("Entered in this class convert");
    int width = image.width;
    int height = image.height;
    var img = imglib.Image(width, height);
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride! * (x / 2).floor() +
            uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = imglib.copyRotate(img, -90);
    return img1;
  }

  Float32List imageToByteListFloat32(imglib.Image image) {
    /// input size = 112
    var convertedBytes = Float32List(1 * 112 * 112 * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;

    for (var i = 0; i < 112; i++) {
      for (var j = 0; j < 112; j++) {
        var pixel = image.getPixel(j, i);

        /// mean: 128
        /// std: 128
        buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
        buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
      }
    }
    return convertedBytes.buffer.asFloat32List();
  }

  double minDist = 999;
  Future<String> _searchResult(List predictedData) async {
    double currDist = 0.0;
    var StudentUid = await FirebaseFirestore.instance
        .collection('Students')
        .where(
          'Uid',
          isGreaterThanOrEqualTo: FirebaseAuth.instance.currentUser!.uid,
        )
        .get();
    print(StudentUid.docs.length);
    for (int i = 0; i < StudentUid.docs.length; i++) {
      String id = i.toString();
      var UserSnap = await FirebaseFirestore.instance
          .collection('Students')
          .doc(StudentUid.docs[i].data()!['Uid'])
          .get();
      currDist =
          _euclideanDistance(UserSnap.data()!['ImageData'], predictedData);
      if (currDist <= minDist) {
        minDist = currDist;
        predUid = UserSnap.data()!['Uid'];
        predName = UserSnap.data()!['Name'];
      }
    }
    if (predUid != '') {
      print("Add fire");
      Home().markpresent(predUid);
    }
    print(predName);
    return predUid;
  }

  /// Adds the power of the difference between each point
  /// then computes the sqrt of the result
  double _euclideanDistance(List e1, List e2) {
    if (e1 == null || e2 == null) throw Exception("Null argument");

    double sum = 0.0;
    for (int i = 0; i < e1.length; i++) {
      sum += pow((e1[i] - e2[i]), 2);
    }
    return sqrt(sum);
  }

  void setPredictedData(value) {
    this._predictedData = value;
  }
}
