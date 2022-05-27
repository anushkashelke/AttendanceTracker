import 'package:cloud_firestore/cloud_firestore.dart';

//In this class all the details of user are extracted from the firebase stored and returned to the getUserDetails class of auth_method.dart
class User_details {
  final String StudentName; //inputs from the user in the form of string
  final String RollNo; //initialization of variables and their data types
  final String StudentId;
  final String ClassName;
  final String StudentImageUrl;
  final List Imagedata;
  final String Uid;
  const User_details({
    //constructor
    required this.StudentId,
    required this.RollNo,
    required this.ClassName,
    required this.StudentName,
    required this.StudentImageUrl,
    required this.Imagedata,
    required this.Uid,
  });
  Map<String, dynamic> toJson() => {
        //String:dynamic value(since multiple users)
        "Name":
            StudentName, //thus all the inputs are converted into an objects and stored in object file called Json
        "Class": ClassName,
        "Rollno": RollNo,
        "UniversityId": StudentId,
        "StudentImageUrl": StudentImageUrl,
        "ImageData": Imagedata,
        "Uid": Uid,
      }; //functions for user to access firebase  //toJson method to convert user details into an object
  static User_details fromSnap(DocumentSnapshot snap) {
    //DocumentSnapshot= contains data read from the firebase storage
    var snapshot = snap.data() as Map<String, dynamic>;
    //snap.data() - contains all the data of this document snapshot
    //variable snapshot contains data of user under each String
    return User_details(
      StudentName: snapshot['Name'],
      RollNo: snapshot['Rollno'],
      ClassName: snapshot['Class'],
      StudentId: snapshot['UniversityId'],
      StudentImageUrl: snapshot['StudentImageUrl'],
      Imagedata: snapshot['ImageData'],
      Uid: snapshot['Uid'],
    );
  }
}
