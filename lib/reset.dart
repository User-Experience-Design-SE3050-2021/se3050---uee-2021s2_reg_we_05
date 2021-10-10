import 'package:etraffic/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  String _email = '';
  final auth = FirebaseAuth.instance;

  navigateToLogin() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            new Container(
              constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/background.png"),
                        fit: BoxFit.cover)),   
          ),    
        SingleChildScrollView(    
          child: Stack(children: [
            Positioned(
                // top: 20,
                right: 120,
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
              SizedBox(height: 150),
          Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30),
                  child: Text(
                    'Forgot your password?',
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
               SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 10, right: 50),
                  child: Text(
                    'Enter your registered email below and we will email you the link to reset your password',
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
              SizedBox(
                height: 30,
              ),
             Form(
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
                        keyboardType: TextInputType.emailAddress,
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
                        onChanged: (value) {
                                        setState(() {
                                          _email = value.trim();
                                        });
                                      },
                      ),
                    ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
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
                onPressed: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pop();
                },                
              ),
            ],
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
              SizedBox(height: 30),
         
        ],),
        ),
        ]),
        ]),
      // backgroundColor: Colors.lightBlue[50],
        ),
    ]));
  }
}
