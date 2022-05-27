import 'package:attendance/Students%20Records/CalculatePercentage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class StudentAttendance extends StatefulWidget {
  final String Name;
  final String Uid;
  const StudentAttendance({Key? key, required this.Name, required this.Uid})
      : super(key: key);

  @override
  State<StudentAttendance> createState() => _StudentAttendanceState();
}

class _StudentAttendanceState extends State<StudentAttendance> {
  @override
  /* Future<String> getMonthDetails(String Month) async{
    var Studentdata = FirebaseFirestore.instance
        .collection('Students')
        .doc(widget.Uid)
        .get();
    int total = Studentdata.data()![Month];
    return '';
  } */

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.Name + ' Attendance',
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Students')
              .doc(widget.Uid)
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
                itemCount: (snapshot.data! as dynamic)['Months'].length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CalcPercentage(
                            month: (snapshot.data! as dynamic)['Months'][index],
                            Uid: widget.Uid,
                            TotalDays: (snapshot.data! as dynamic)['Months']
                                    [index]
                                .length,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 350,
                      child: Card(
                        color: Colors.red[200],
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text(
                            //(snapshot.data! as dynamic)[widget.MonthName][index],
                            (snapshot.data! as dynamic)['Months'][index],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}
