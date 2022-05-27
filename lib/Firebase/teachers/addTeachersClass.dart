import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddClassOfTeacher {
  final String ClassName;
  const AddClassOfTeacher({
    required this.ClassName,
  });
  Map<String, dynamic> toJson() => {
    "classname":ClassName,
  };
  static AddClassOfTeacher fromsnap(DocumentSnapshot snap) {
    print("SNap Method");
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddClassOfTeacher(
        ClassName: snapshot['ClassName'],
    );
  }
}
