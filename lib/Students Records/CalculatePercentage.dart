import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class CalcPercentage extends StatefulWidget {
  final String month;
  final String Uid;
  final int TotalDays;
  const CalcPercentage(
      {Key? key,
      required this.month,
      required this.Uid,
      required this.TotalDays})
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
        //Color('#EE4B2B'),
        Colors.teal,
        Colors.orange,
      ],
      animationDuration: const Duration(seconds: 3),
      chartRadius: MediaQuery.of(context).size.width / 2,
      chartValuesOptions: const ChartValuesOptions(
        showChartValues: true,
        showChartValuesOutside: true,
        showChartValuesInPercentage: true,
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
        title: Text('Record for ' + widget.month),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Number of Days Present : ' +
                            (snapshot.data! as dynamic)[widget.month]
                                .length
                                .toString(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Total Days in ' +
                            widget.month +
                            ' : ' +
                            widget.TotalDays.toString(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        child: AddPieChart(
                            (((snapshot.data! as dynamic)[widget.month].length /
                                    widget.TotalDays) *
                                100),
                            (100.00 -
                                (((snapshot.data! as dynamic)[widget.month]
                                            .length /
                                        widget.TotalDays) *
                                    100))),
                      ),
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
