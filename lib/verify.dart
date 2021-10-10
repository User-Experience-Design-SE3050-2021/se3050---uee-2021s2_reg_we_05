import 'package:etraffic/homepage.dart';
import 'package:etraffic/login.dart';
import 'package:etraffic/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  VerifyOTP() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Fluttertoast.showToast(
        msg: "Verification code sent to email",
        backgroundColor: Colors.grey,
        fontSize: 18);
    }
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        body: Container(
           constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/background.png"),
                        fit: BoxFit.cover)),
        padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
        child: Stack(children: [
          Positioned(
                // top: 20,
                right: 110,
                child: Container(
                 height: 150,
                 child: Image(   
                   image: AssetImage("images/police_logo.png"),
                   fit: BoxFit.fill,
                 ), 
            )),
            
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 160),
                  child: Text(
                    '  Account Recovery',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Cardo',
                      fontSize: 30,
                      color: Color(0xff0C2551),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 10, right: 50),
                  child: Text(
                    'A verification code has been sent to your email address',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              //
              SizedBox(
                height: 50,
              ),

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                        child: Text(
                          'Please Enter your code below',
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            color: Color(0xff8f9db5),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                      child: TextFormField(
                        validator: (input) {
                          if (input != null && input.isEmpty)
                            return 'OTP cannot be empty';
                        },
                        onSaved: (input) => _email = input.toString(),
                        style: TextStyle(
                            fontSize: 19,
                            color: Color(0xff0962ff),
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: '1234',
                          hintStyle: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[350],
                              fontWeight: FontWeight.w600),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          focusColor: Color(0xff0962ff),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Color(0xff0962ff)),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(
                                color: (Colors.grey[350])!,
                              )),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    ElevatedButton(
                      onPressed: VerifyOTP,
                      child: Text(
                        'Verify OTP',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade800),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.fromLTRB(60, 15, 60, 15))),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Return to ",
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'SignUp',
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[300],
                            ),
                          ),
                          onTap: navigateToSignUp,
                        ),
                      ],
                    ),
                    SizedBox(height: 30)
                  ],
                ),
              )
            ],
          ),
        ]),
      ),
      // backgroundColor: Colors.lightBlue[50],
    ));
  }
}

