import 'package:attendance/Students%20Records/StudentProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'AttendanceRecords.dart';

class StudentRecords extends StatefulWidget {
  final String Classname;
  const StudentRecords({Key? key, required this.Classname}) : super(key: key);

  @override
  State<StudentRecords> createState() => _StudentRecordsState();
}

class _StudentRecordsState extends State<StudentRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Students'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Students')
                  .where(
                    'Uid',
                    isGreaterThanOrEqualTo:
                        FirebaseAuth.instance.currentUser!.uid,
                  )
                  .where('Class', isEqualTo: widget.Classname)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  //print("Seeeee");
                  return const Center(
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic)
                      .docs
                      .length, //to obtain total number of relevant ids
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        print("Entered");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentProfile(
                                Uid: (snapshot.data! as dynamic).docs[index]
                                    ['Uid'],
                                Name: (snapshot.data! as dynamic).docs[index]
                                    ['Name'],
                                Class: (snapshot.data! as dynamic).docs[index]
                                    ['Class'],
                                UniId: (snapshot.data! as dynamic).docs[index]
                                    ['UniversityId'],
                                RollNo: (snapshot.data! as dynamic).docs[index]
                                    ['Rollno']),
                          ),
                        );
                      },
                      child: Container(
                        width: 350,
                        child: Card(
                          color: Colors.red[100],
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10,10, 10,10),
                            child: ListTile(
                              title: Text(
                                (snapshot.data! as dynamic).docs[index]['Name'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  color: Colors.purple[900],
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
