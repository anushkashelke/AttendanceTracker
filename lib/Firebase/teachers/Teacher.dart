import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Teacher_details {
  final String TeacherName;
  final String EmailId;
  final String uid;
  const Teacher_details({
    required this.TeacherName,
    required this.EmailId,
    required this.uid,
  });
  Map<String, dynamic> toJson() => {
        "uid": uid,
        "teachername": TeacherName,
        "emailId": EmailId,
      };
  static Teacher_details fromsnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Teacher_details(
        TeacherName: snapshot['TeacherName'],
        EmailId: snapshot['Email'],
        uid: snapshot['TeacherId']);
  }
}
