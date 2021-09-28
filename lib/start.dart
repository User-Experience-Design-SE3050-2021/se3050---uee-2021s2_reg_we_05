import 'dart:ui';
import 'package:etraffic/google_sign_in.dart';
import 'package:etraffic/login.dart';
import 'package:etraffic/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  navigateToLogin() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  navigateToRegister() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.lightBlue[50],
        child: Column(
          children: <Widget>[
            SizedBox(height: 85.0),
            Container(
              child: Image(
                image: AssetImage("images/police_logo.png"),
                width: 160.0,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10.0),
            RichText(
                text: TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'eTraffic',
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900))
                ])),
            SizedBox(height: 10.0),
            Text(
              'You Report, We Decide',
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 30.0),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //     ElevatedButton(
            //       onPressed: navigateToLogin,
            //       child: Text(
            //         'LOGIN',
            //         style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.blue.shade900),
            //       ),
            //       style: ButtonStyle(
            //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //               RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(18.0),
            //                   side: BorderSide(color: Colors.blue.shade900)))),
            //     ),
            //     SizedBox(width: 20),
            //     ElevatedButton(
            //       onPressed: navigateToRegister,
            //       child: Text(
            //         'REGISTER',
            //         style: TextStyle(
            //             fontSize: 20,
            //             fontWeight: FontWeight.bold,
            //             color: Colors.blue.shade900),
            //       ),
            //       style: ButtonStyle(
            //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //               RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(18.0),
            //                   side: BorderSide(color: Colors.blue.shade900)))),
            //     ),
            //   ],
            // ),

            ElevatedButton(
              onPressed: navigateToLogin,
              child: Text(
                'LOGIN',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          )),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade800),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(110, 15, 110, 15))),
            ),
            SizedBox(height: 13),
            ElevatedButton(
              onPressed: navigateToRegister,
              child: Text(
                'REGISTER',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0),
                          )),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade800),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(95, 15, 95, 15))),
            ),

            SizedBox(height: 13),

            // SignInButton(
            //   Buttons.Google,
            //   text: "Sign up with Google",
            //   onPressed: () {},
            // )
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0)
                  ),
                  onPrimary: Colors.black,
                  textStyle: TextStyle(fontSize: 17),
                  minimumSize: Size(280, 50)),
              icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: Text(' Sign Up with Google'),
              onPressed: () {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                provider.googleLogin(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
