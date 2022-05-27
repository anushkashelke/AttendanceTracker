import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {  //ImageScource = Specifies the source from where our image should come from
  final ImagePicker _imagePicker = ImagePicker(); //ImagePicker= Helps to pick an image from gallery or click from camera
  XFile? _file = await _imagePicker.pickImage(source: source); //wraps the bytes of selected file
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}