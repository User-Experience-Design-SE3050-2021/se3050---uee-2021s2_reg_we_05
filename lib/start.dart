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
    return SafeArea(
      child: Scaffold(
      body: Container(
        // constraints: BoxConstraints.expand(),
        //         decoration: BoxDecoration(
        //             image: DecorationImage(
        //                 image: AssetImage("images/3.jpg"),
        //                 fit: BoxFit.cover)),        
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0), 
        alignment: Alignment.center,
        color: Colors.lightBlue[50],
        child: Column(
          children: <Widget>[
            SizedBox(height: 20.0),
            Container(
              child: Image(
                image: AssetImage("images/police_logo.png"),
                width: 250.0,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 25.0),
            RichText(
                text: TextSpan(
                    text: 'Welcome to ',
                    style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                  TextSpan(
                      text: 'eTraffic',
                      style: TextStyle(
                          fontSize: 40.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900))
                ])),
            SizedBox(height: 20.0),
            Text(
              'You Report, We Decide',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,)
            ),
            SizedBox(height: 50.0),
            // Container(
            //   child: Image(
            //     image: AssetImage("images/police_logo.png"),
            //     width: 250.0,
            //     fit: BoxFit.contain,
            //   ),
            // ),
            SizedBox(height: 10.0),
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
                          borderRadius: BorderRadius.circular(20.0),
                          )),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade800),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(95, 15, 95, 15))),
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
                          borderRadius: BorderRadius.circular(20.0),
                          )),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade800),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(80, 15, 80, 15))),
            ),

            SizedBox(height: 13),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                  ),
                  onPrimary: Colors.black,
                  textStyle: TextStyle(fontSize: 17),
                  minimumSize: Size(250, 50)),
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
    ));
  }
}
