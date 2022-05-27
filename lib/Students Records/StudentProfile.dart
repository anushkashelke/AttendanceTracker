import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'StudentAttendance.dart';

class StudentProfile extends StatefulWidget {
  final String Name;
  final String Class;
  final String UniId;
  final String RollNo;
  final String Uid;
  const StudentProfile(
      {Key? key,
      required this.Uid,
      required this.Name,
      required this.Class,
      required this.UniId,
      required this.RollNo})
      : super(key: key);

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  @override
  //var StudentData = FirebaseFirestore.instance.collection('Students').doc(Uid).get();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'Profile ',
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20,20,10,10),
              child: Text(
                  'Name: '+widget.Name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                    fontSize: 20,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 10,10),
              child: Text(
                //textAlign: TextAlign.center,
                'Class Name : ' + widget.Class,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,20,10,10),
              child: Text(
                'Roll no: ' + widget.RollNo,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,20,10,10),
              child: Text(
                'University Id: ' + widget.UniId,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => StudentAttendance(
                            Name: widget.Name,
                            Uid: widget.Uid,
                          )),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Card(
                  color: Colors.purple[100],
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 25, 0, 25),
                    child: ListTile(
                      title: Text(
                        textAlign: TextAlign.center,
                        'Attendance Records',
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: 'Lato',
                          letterSpacing: 2.0,
                          color: Colors.indigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
