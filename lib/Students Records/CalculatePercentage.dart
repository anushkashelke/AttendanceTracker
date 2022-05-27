import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CalcPercentage extends StatefulWidget {
  final String month;
  final String Uid;
  final int TotalDays;
  final String Name;
  const CalcPercentage(
      {Key? key,
      required this.month,
      required this.Uid,
      required this.TotalDays,
      required this.Name})
      : super(key: key);

  @override
  State<CalcPercentage> createState() => _CalcPercentageState();
}

class _CalcPercentageState extends State<CalcPercentage> {
  PieChart AddPieChart(double present, double absent) {
    return PieChart(
      dataMap: {
        "Present": present,
        "Absent": absent,
      },
      colorList: [
        Colors.teal,
        Color(0xffF55353),
      ],
      animationDuration: const Duration(seconds: 3),
      chartRadius: MediaQuery.of(context).size.width / 2,
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: true,
        //showChartValuesOutside: true,
        showChartValuesInPercentage: true,
        showChartValueBackground: false,
        chartValueStyle: TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      legendOptions: const LegendOptions(
        showLegends: true,
        legendShape: BoxShape.rectangle,
        legendTextStyle: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Record for ' + widget.month),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Total Days in ' +
                    widget.month +
                    ' : ' +
                    widget.TotalDays.toString(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
            FutureBuilder(
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
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                        child: Text(
                          'Number of Days Present : ' +
                              (snapshot.data! as dynamic)[widget.month]
                                  .length
                                  .toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: AddPieChart(
                              (((snapshot.data! as dynamic)[widget.month]
                                          .length /
                                      widget.TotalDays) *
                                  100),
                              (100.00 -
                                  (((snapshot.data! as dynamic)[widget.month]
                                              .length /
                                          widget.TotalDays) *
                                      100))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                        child: Text(
                          'Attendance of ' + widget.Name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
