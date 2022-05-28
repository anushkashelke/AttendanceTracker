import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'MonthlyAttendance.dart';

class AttendanceRecords extends StatefulWidget {
  final String ClassName;
  const AttendanceRecords({Key? key, required this.ClassName})
      : super(key: key);

  @override
  State<AttendanceRecords> createState() => _AttendanceRecordsState();
}

class _AttendanceRecordsState extends State<AttendanceRecords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Months',
        ),
      ),
      body: Container(
        child: FutureBuilder(
            future: FirebaseFirestore.instance
                .collection('Teachers')
                .doc(FirebaseAuth.instance.currentUser!.uid)
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
                itemCount: (snapshot.data! as dynamic)['Months']
                    .length, //to obtain total number of relevant ids
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Month(
                              MonthName: (snapshot.data! as dynamic)['Months']
                                  [index], ClassName: widget.ClassName,),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      child: Container(
                        height:100,
                        width: 350,
                        child: Card(
                          color: Colors.teal[200],
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: ListTile(
                              title: Text(
                                (snapshot.data! as dynamic)['Months'][index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
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
      ),
    );
  }
}
