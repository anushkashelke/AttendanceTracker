import 'package:attendance/Firebase/StorageMethods.dart';
import 'package:attendance/MarkAttendance/markAttendance.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Services/DataBase.dart';
import '../Services/MLKitService.dart';
import '../Services/faceNetService.dart';
import '../Students Records/ClassRooms.dart';
import '../Students Records/RecordOfStudents.dart';
import '../newStudent/AddClass.dart';
import '../newStudent/detectStudent.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
  void markpresent(String uid){
    _HomeState().markpresent(uid);
  }
}

class _HomeState extends State<Home> {
  @override
  FaceNetService _faceNetService = FaceNetService();
  MLKitService _mlKitService = MLKitService();
  DataBaseService _dataBaseService = DataBaseService();

  late CameraDescription cameraDescription;
  bool loading = false;
  DateTime selectedDate = DateTime.now();
  String Date = '';
  String Month = '';

  @override
  void initState() {
    super.initState();
    selectDate('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
        DateFormat.LLLL().format(selectedDate));
    //_startUp();
  }

  void selectDate(String DATE, String MONTH) {
    Storagetypes().AddDateToFirebase(MonthName: MONTH, Date: DATE);
    //Storagetypes().MarkasPresent(MonthName: MonthName, Date: Date, StudentId: StudentId)
  }
  void markpresent(String UID){
    print("Entered here");
    Storagetypes().MarkasPresent(MonthName: DateFormat.LLLL().format(selectedDate), Date: '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}', Uid: UID);
  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection == CameraLensDirection.front,
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.loadDB();
    _mlKitService.initialize();
    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2022, 1),
        lastDate: DateTime(2022, 12));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        Date = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
        Month = DateFormat.LLLL().format(selectedDate);
        selectDate(Date, Month);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(
          'Attendance',
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                child: InkWell(
                  onTap: () {
                    _startUp();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddClass(
                            cameraDescription: cameraDescription), //FaceDetect(
                        //cameraDescription: cameraDescription),
                      ),
                    );
                  },
                  child: Container(
                    width: 350,
                    child: Card(
                      color: Colors.pink[100],
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 0, 25),
                        child: Text(
                          'Add New Student',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _startUp();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => markAttendance(
                              cameraDescription: cameraDescription)),
                    );
                  },
                  child: Container(
                    width: 350,
                    child: Card(
                      color: Colors.pink[100],
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 0, 25),
                        child: Text(
                          'Take Attendance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _startUp();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClassRoom()),
                    );
                  },
                  child: Container(
                    width: 350,
                    child: Card(
                      color: Colors.pink[100],
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 0, 25),
                        child: Text(
                          'Your Classrooms',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    width: 350,
                    child: Card(
                      color: Colors.pink[100],
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 25, 0, 25),
                        child: Text(
                          'Set Date to mark attendance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text('Current Date: ' +
              '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
        ],
      ),
    );
  }
}
