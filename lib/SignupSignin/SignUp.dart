import 'package:attendance/Firebase/teachers/AuthenticateUser.dart';
import 'package:flutter/material.dart';
import '../Utils/Image_picker.dart';
import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  final TextEditingController _teacherName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void dispose() {
    super.dispose();
    _teacherName.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }

  void SignUpUser() async {
    String res = await Authentication().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _teacherName.text);
    if (res == "success") {
      Navigator.of(context).pushReplacement(
          //through push replacement it won't navigate back to sign up page from the home page
          MaterialPageRoute(builder: (context) => const Home()));
    } else {
      showSnackBar(context,'Please enter all the fields');
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Attendance'),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: _teacherName,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter Name',
                    hintStyle: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 0.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email Id',
                    hintText: 'Enter Your Email Address',
                    hintStyle: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Set Password',
                    hintStyle: TextStyle(
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
              Container(
                height: 43,
                width: 130,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                ),
                child: TextButton(
                  onPressed: () {
                    //to jump on pages
                    SignUpUser();
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
