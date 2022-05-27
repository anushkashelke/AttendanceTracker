import 'package:attendance/Firebase/StorageMethods.dart';
import 'package:attendance/Firebase/teachers/addTeachersClass.dart';
import 'package:attendance/newStudent/detectStudent.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddClass extends StatefulWidget {
  final CameraDescription cameraDescription;
  const AddClass({Key? key, required this.cameraDescription}) : super(key: key);

  @override
  State<AddClass> createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  @override
  final FirebaseFirestore storage = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController classname = TextEditingController();
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    var TeacherData = await FirebaseFirestore.instance
        .collection('Teachers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  Future openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Enter Class Name',
          ),
          content: TextField(
            controller: classname,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Storagetypes().AddClassToFirebase(ClassName: classname.text);
              },
              child: Text(
                'Submit',
              ),
            ),
          ],
        ),
      );

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text(
          'New Student',
        ),
      ),
      body: Column(
        children: [
          /*Container(
            alignment: Alignment.center,
            height: 100,
            color: Colors.white, */
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 30, 10, 20),
            child: TextButton(
              onPressed: () {
                openDialog();
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.blue[100])),
              child: Text(
                'Add a Class',
                style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          //),
          FutureBuilder(
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
                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic)[
                        'Total Classes'], //to obtain total number of relevant ids
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FaceDetect(
                                  cameraDescription: widget.cameraDescription,
                                  ClassName: (snapshot.data!
                                      as dynamic)['ClassName'][index]),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width:200,
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
                                    //textAlign: TextAlign.center,
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
                        ),
                      );
                    },
                  ),
                );
              }),
          /*Container(
            child: ListView.builder(
              itemCount: ,
              itemBuilder: (context,index){
                return InkWell(
                  onTap: (){},
                  child: ListTile(
                    title: Text(
                      '',
                    ),
                  ),
                );
              },
            );
        ),  */
        ],
      ),
    );
  }
}
