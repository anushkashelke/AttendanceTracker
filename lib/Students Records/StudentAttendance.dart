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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'Attendance of ' + widget.Name,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
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
                if((snapshot.data! as dynamic)['Months'].length>1) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic)['Months'].length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CalcPercentage(
                                      month: (snapshot
                                          .data! as dynamic)['Months']
                                      [index],
                                      Uid: widget.Uid,
                                      TotalDays: (snapshot
                                          .data! as dynamic)['Months']
                                      [index]
                                          .length,
                                      Name: widget.Name,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Card(
                                color: Colors.teal[200],
                                margin: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Padding(
                                  padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                  child: Text(
                                    //(snapshot.data! as dynamic)[widget.MonthName][index],
                                    (snapshot
                                        .data! as dynamic)['Months'][index],
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
                        );
                      });
                }
                else{
                  return Container(
                    child:Center(
                      child: Text(
                      'No Records Present !',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
