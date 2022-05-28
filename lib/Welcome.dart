import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'SignupSignin/SignIn.dart';
import 'SignupSignin/SignUp.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Attendance'),
        ),
        body: SafeArea(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Attendance Tracker',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Tangerine',
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                color: Colors.pink[100],
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('All your attendance records at one place !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Tangerine',
                        color: Colors.purple[900],
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 43,
                  width: 130,
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                  ),
                  child: TextButton(
                    onPressed: () {
                      //to jump on pages
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIN()),
                      );
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(color: Colors.indigo, fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    height: 43,
                    width: 130,
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignUp()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.indigo, fontSize: 18,fontWeight: FontWeight.bold),
                      ),
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: LottieBuilder.network(
                'https://assets5.lottiefiles.com/packages/lf20_xyadoh9h.json',
                height: 250,
                animate:true,
                repeat:true,
                reverse:true,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
