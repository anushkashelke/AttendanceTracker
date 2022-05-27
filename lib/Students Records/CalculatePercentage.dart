import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CalcPercentage extends StatefulWidget {
  final String month;
  final String Uid;
  final int TotalDays;
  const CalcPercentage({Key? key, required this.month, required this.Uid, required this.TotalDays}) : super(key: key);

  @override
  State<CalcPercentage> createState() => _CalcPercentageState();
}

class _CalcPercentageState extends State<CalcPercentage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record for '+widget.month),
      ),
      body: Column(
        children: [
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
                return Column(
                  children: [
                    Text(
                      'Number of Days Present : '+(snapshot.data! as dynamic)[widget.month].length.toString()+'/'+ widget.TotalDays.toString(),
                    ),
                    Text(
                      'Percentage of Days Present : '+(((snapshot.data! as dynamic)[widget.month].length/widget.TotalDays)*100).toString(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
