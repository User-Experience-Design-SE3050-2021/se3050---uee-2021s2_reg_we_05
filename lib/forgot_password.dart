import 'package:etraffic/homepage.dart';
import 'package:etraffic/login.dart';
import 'package:etraffic/signup.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email = '';

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  changePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Fluttertoast.showToast(
        msg: "New password sent to email",
        backgroundColor: Colors.grey,
        fontSize: 18);
    }
  }

  navigateToLogin() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Stack(children: [
          // Positioned(
          //   top: 20,
          //   right: 30,
          //   child: Container(
          //    height: 100,
          //    child: Image(
          //      image: AssetImage("images/police_logo.png"),
          //      fit: BoxFit.contain,
          //    ),
          //  )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0, top: 40),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontFamily: 'Cardo',
                      fontSize: 35,
                      color: Color(0xff0C2551),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 5),
                  child: Text(
                    'Reset password using email',
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
                height: 30,
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
                          'Email',
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
                            return 'Email cannot be empty';
                        },
                        onSaved: (input) => _email = input.toString(),
                        style: TextStyle(
                            fontSize: 19,
                            color: Color(0xff0962ff),
                            fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          hintText: 'johndoe@gmail.com',
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
                      onPressed: changePassword,
                      child: Text(
                        'RESET PASSWORD',
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
                            'Login',
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[300],
                            ),
                          ),
                          onTap: navigateToLogin,
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
      backgroundColor: Colors.lightBlue[50],
    ));
  }
}
