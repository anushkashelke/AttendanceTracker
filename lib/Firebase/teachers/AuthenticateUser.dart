import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:attendance/Firebase/teachers/Teacher.dart' as model;

class Authentication {
  final FirebaseAuth _auth =
      FirebaseAuth.instance; // _auth is our private variable
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
  }) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty || username.isNotEmpty) {
        //||file!=null
        //register new user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        //add details of user to the database
        print(cred.user!.uid);
        model.Teacher_details teacher = model.Teacher_details(
          EmailId: email,
          TeacherName: username,
          uid: cred.user!.uid,
        );
        _firestore.collection('Teachers').doc(cred.user!.uid).set(
              //to store data of new user in firestore collection if it doesn't exist
              teacher.toJson(),
            ); //to store data in collection 'Teachers'
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
      print("Error");
      print("Error");
      print("Error");
      print(res);
      print("Error");
      print("Error");
    }
    return res;
  }

  Future<String> LogIn({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email,
            password:
                password); //this returns email and password back hence we need to await them
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    }
    catch (err) {
      res = err.toString();
    }
    return res;
  }
}
