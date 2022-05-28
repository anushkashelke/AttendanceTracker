import 'package:attendance/Students%20Records/DayAttendance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Month extends StatefulWidget {
  final String MonthName;
  final String ClassName;
  const Month({Key? key, required this.MonthName, required this.ClassName})
      : super(key: key);

  @override
  State<Month> createState() => _MonthState();
}

class _MonthState extends State<Month> {
  @override
  void initState() {
    super.initState();
    FetchData();
  }

  void FetchData() {
    print("Entered");
    try {
      var data = FirebaseFirestore.instance
          .collection('Teachers')
          .where(widget.MonthName, isEqualTo: widget.MonthName)
          .get();
    } catch (err) {
      print(err);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          'Dates',
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            color: Colors.white,
            child: FutureBuilder(
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
                    itemCount: (snapshot.data! as dynamic)[widget.MonthName].length,
                    /*(snapshot.data! as dynamic)
                        .docs
                        .length, */ //to obtain total number of relevant ids
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Day(
                                  date: (snapshot.data!
                                      as dynamic)[widget.MonthName][index],
                                  Class: widget.ClassName,
                                  Month: widget.MonthName),
                            ),
                          );
                        },
                        child: Container(
                          width: 350,
                          child: Card(
                            color: Colors.blue[100],
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10,18, 10,18),
                              child: Text(
                                (snapshot.data! as dynamic)[widget.MonthName]
                                    [index],
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
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}
