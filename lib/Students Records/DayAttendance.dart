import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Day extends StatefulWidget {
  final String date;
  final String Month;
  final String Class;
  const Day(
      {Key? key, required this.date, required this.Class, required this.Month})
      : super(key: key);

  @override
  State<Day> createState() => _DayState();
}

class _DayState extends State<Day> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text(
            widget.date,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 20),
              child: Card(
                color: Colors.teal[100],
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5,15,5,15),
                  child: Text(
                    'Students Present from Class ' + widget.Class,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('Students')
                  .where('Uid',
                      isGreaterThanOrEqualTo:
                          FirebaseAuth.instance.currentUser!.uid)
                  .where(widget.Month, arrayContains: widget.date)
                  .where('Class',isEqualTo:widget.Class)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          return Row(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 10, 5),
                                child: Text(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['Rollno'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Text(
                                  (snapshot.data! as dynamic).docs[index]
                                      ['Name'],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  );
                }
              },
            )
          ],
        ));
  }
}
