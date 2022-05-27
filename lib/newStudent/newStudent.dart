import 'dart:io';
import 'package:attendance/Utils/Image_picker.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Firebase/StorageMethods.dart';
import '../home/home.dart';

class newEntry extends StatefulWidget {
  final XFile image;
  final String ClassName;
  const newEntry({Key? key, required this.image, required this.ClassName})
      : super(key: key);

  @override
  _newEntryState createState() => _newEntryState();
}

class _newEntryState extends State<newEntry> {
  @override
  bool _isLoading = false;
  void AddToFirebase(
    //String className,
    String RollNo,
    String StudentName,
    String StudentId,
    XFile StudentImage,
  ) async {
    setState(() {
      _isLoading = false;
    });
    try {
      print("Entered");
      File file = File(StudentImage.path);
      String result = await Storagetypes().newStudent(
          className: widget.ClassName,
          RollNo: RollNo,
          StudentName: StudentName,
          StudentId: StudentId,
          Imagefile: file);
      if (result == "success") {
        setState(() {
          _isLoading = false;
        });
      } else {
        print("Entered");
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Please Enter All The Fields !',
              style: TextStyle(
                color: Colors.blue[900],
                fontSize: 16,
              ),
            ),
          ),
        );
        //showSnackBar(context,result);
      }
    } catch (e) {
      print("Error");
      print(e.toString());
      print("Error");
    }
  }

  final TextEditingController _UniversityId = TextEditingController();
  final TextEditingController _StudentName = TextEditingController();
  final TextEditingController _StudentRollNo = TextEditingController();
  final TextEditingController _StudentClass = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      //crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextField(
            controller: _StudentName,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              //labelText: 'NAME',
              hintText: 'Enter Name',
              hintStyle: TextStyle(
                color: Colors.teal,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextField(
            controller: _StudentRollNo,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              //labelText: 'WEIGHT',
              hintText: 'Enter Class Roll Number',
              hintStyle: TextStyle(
                color: Colors.teal,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: TextField(
            controller: _UniversityId,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              //labelText: 'NAME',
              hintText: 'Enter University Roll Number',
              hintStyle: TextStyle(
                color: Colors.teal,
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            AddToFirebase(_StudentRollNo.text, _StudentName.text,
                _UniversityId.text, widget.image);
            Home();
          },
          child: Text(
            'Add',
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue[100])),
        ),
      ],
    ));
  }
}
