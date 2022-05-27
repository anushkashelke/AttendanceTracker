import 'package:attendance/Firebase/teachers/AuthenticateUser.dart';
import 'package:flutter/material.dart';
import '../Utils/Image_picker.dart';
import '../home/home.dart';
class SignIN extends StatefulWidget {
  const SignIN({Key? key}) : super(key: key);

  @override
  State<SignIN> createState() => _SignINState();
}

class _SignINState extends State<SignIN> {
  @override
  final TextEditingController _emailController=TextEditingController();
  final TextEditingController _passwordController=TextEditingController();
  void dispose(){
    super.dispose();
    _passwordController.dispose();
    _emailController.dispose();
  }
  void LogIn() async{
    String res = await Authentication().LogIn(email: _emailController.text ,password: _passwordController.text);
    if(res=="success"){   //if login is successful go to home page
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const Home()));
    }
    else{
      showSnackBar(context, "Invalid email/password");
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
            mainAxisAlignment:MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                padding: EdgeInsets.symmetric(horizontal: 15),
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
                padding:EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15.0, bottom:15.0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller:_passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Password',
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
                  color: Colors.deepPurple,),
                child: TextButton(
                  onPressed: () {   //to jump on pages
                    LogIn();
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
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
