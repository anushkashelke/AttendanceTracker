import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDate {
  final String MonthName;
  const AddDate({
    required this.MonthName,
  });
  Map<String, dynamic> toJson() => {
        "monthname": MonthName,
      };
  AddDate fromsnap(DocumentSnapshot snap) {
    print("ERROR IN SNAP");
    print("SNap Method");
    var snapshot = snap.data() as Map<String, dynamic>;
    return AddDate(
      MonthName: snapshot['MonthName'],
    );
  }
}
