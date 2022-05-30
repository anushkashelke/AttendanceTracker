import 'dart:io';
import 'package:attendance/Firebase/ProcessImage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendance/Firebase/Students/Students.dart' as model;
import 'package:attendance/Firebase/teachers/addTeachersClass.dart'
    as modelClass;
import 'package:firebase_database/firebase_database.dart';
import '../Services/faceNetService.dart';
import 'package:attendance/Firebase/teachers/AddDate.dart' as modelDate;

import '../home/home.dart';

class Storagetypes {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // _auth is our private variable
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FaceNetService _faceNetService = FaceNetService();
  //final FaceDetectionThroughTflite _tfliteService = FaceDetectionThroughTflite();
  String Month = '';
  int TotalDays = 0;
  String date = '';
  Future<String> newStudent({
    required String className,
    required String RollNo,
    required String StudentName,
    required String StudentId,
    //required String StudentImageUrl,
    required File Imagefile,
  }) async {
    String res = "Some error occured";
    try {
      String imageUrl = await StoreImage()
          .UploadImageToStorage('Students', StudentId, Imagefile);
      //_firestore.collection('Teachers').doc(_auth.currentUser!.uid).get();
      List imageData = _faceNetService.predictedData;
      String uid = _auth.currentUser!.uid;
      String ClassTeacher = uid + "_" + StudentId;
      if (StudentId.isNotEmpty ||
          className.isNotEmpty ||
          StudentName.isNotEmpty ||
          RollNo.isNotEmpty) {
        model.User_details user = model.User_details(
          StudentName: StudentName,
          RollNo: RollNo,
          ClassName: className,
          StudentId: StudentId,
          StudentImageUrl: imageUrl,
          Imagedata: imageData,
          Uid: ClassTeacher,
          Months: '',
        );
        _firestore.collection('Students').doc(ClassTeacher).set(
              user.toJson(),
            ); //to store data of new student in firestore collection if it doesn't exist
        /*FirebaseFirestore.instance.collection('Students').doc(ClassTeacher).update({
          'Months': FieldValue.arrayUnion([''])
        }); */

        FirebaseFirestore.instance
            .collection('Teachers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "Students": FieldValue.arrayUnion([StudentId])
        });
        res = 'success';
      }
      else{
         res = 'Please fill all the Fields !';
      }
    } catch (err) {
      res = err.toString();
      print(err);
    }
    return res;
  }

  Future<String> AddClassToFirebase({
    required String ClassName,
  }) async {
    var Class = FirebaseFirestore.instance
        .collection('Teachers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String res = 'Some Error Occured';
    try {
      if (ClassName.isNotEmpty) {
        /*modelClass.AddClassOfTeacher Class = modelClass.AddClassOfTeacher(
          ClassName: ClassName,
        ); */
        /*DatabaseReference ref = FirebaseDatabase.instance.ref("Teachers/"+FirebaseAuth.instance.currentUser!.uid);
        await ref.update({
          "ClassName": {"Class1":ClassName
        }}); */
        FirebaseFirestore.instance
            .collection('Teachers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          "ClassName": FieldValue.arrayUnion([ClassName])
        });
        FirebaseFirestore.instance
            .collection('Teachers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({"Total Classes": FieldValue.increment(1)});
      } else {}
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> AddDateToFirebase({
    required String MonthName,
    required String Date,
  }) async {
    var Class = FirebaseFirestore.instance
        .collection('Teachers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    String res = 'Some Error Occured';
    //MonthName = Home().selectedDate.month;
    Month = MonthName;
    date = Date;
    try {
      print("Error");
      if (MonthName.isNotEmpty && Date != '') {
        /* modelDate.AddDate Date = modelDate.AddDate(
          MonthName: MonthName,
        ); */
        print("Error");
        /*DatabaseReference ref = FirebaseDatabase.instance.ref("Teachers/"+FirebaseAuth.instance.currentUser!.uid);
        await ref.update({
          "ClassName": {"Class1":ClassName
        }}); */
        FirebaseFirestore.instance
            .collection('Teachers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          MonthName: FieldValue.arrayUnion([Date])
        });
        FirebaseFirestore.instance
            .collection('Teachers')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .update({
          'Months': FieldValue.arrayUnion([MonthName])
        });
      } else {}
    } catch (err) {
      print("Error");
      print(res.toString());
      res = err.toString();
    }
    return res;
  }

  Future<String> MarkasPresent(
      {required String MonthName,
      required String Date,
      required String Uid}) async {
    String res = 'Some Error Occured';
    try {
      print("Entered");
      print(MonthName);
      FirebaseFirestore.instance.collection('Students').doc(Uid).update({
        MonthName: FieldValue.arrayUnion([Date])
      });
      FirebaseFirestore.instance.collection('Students').doc(Uid).update({
        'Months': FieldValue.arrayUnion([MonthName])
      });
    } catch (err) {
      res = err.toString();
      //print("Error");
      print(res);
    }
    return res;
  }

  Future<int> TotalDaysInMonth(
  {
  required String Month,
  }) async{
    String res='';
    try {
      print("Entered");
      var data = await FirebaseFirestore.instance.collection('Teachers').doc(
          FirebaseAuth.instance.currentUser!.uid).get();
      TotalDays = data.data()![Month].length;
      print("Days");
      print(TotalDays);
    }
    catch(err){
      print("Some error occured !");
      res = err.toString();
    }
    return TotalDays;
  }

}
