import 'package:attendance/Students%20Records/AttendanceRecords.dart';
import 'package:attendance/Students%20Records/StudentRecords.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'RecordOfStudents.dart';

class ClassRoom extends StatefulWidget {
  const ClassRoom({Key? key}) : super(key: key);
  @override
  State<ClassRoom> createState() => _ClassRoomState();
}

class _ClassRoomState extends State<ClassRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        title: Text('Classroom'),
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
          ),
          FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Teachers')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: const CircularProgressIndicator(
                      backgroundColor: Colors.blue,
                    ),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: (snapshot.data! as dynamic)[
                      'Total Classes'], //to obtain total number of relevant ids
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Records(
                                ClassName: (snapshot.data!
                                    as dynamic)['ClassName'][index]),
                          ),
                        );
                      },
                      // Navigator.push(context,MaterialPageRoute(builder: (context)=> FaceDetect(cameraDescription: widget.cameraDescription, ClassName: (snapshot.data! as dynamic)['ClassName'][index]),),);
                      //},
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                          child: Card(
                            color: Colors.purple[100],
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: ListTile(
                                title: Text(
                                  (snapshot.data! as dynamic)['ClassName']
                                      [index],
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontFamily: 'Lato',
                                    letterSpacing: 2.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
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
