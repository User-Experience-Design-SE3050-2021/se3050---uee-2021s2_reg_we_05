import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etraffic/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String _first_name = '';
  String _last_name = '';
  String _mobile = '';
  String _email = '';
  String _password = '';
  String _confirm_password = '';

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
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

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        User? user = (await _auth.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        if (user != null) {
          user.updateDisplayName(_first_name + ' ' + _last_name);
          firestore.collection('users').doc(user.uid).set({
            'mobile': _mobile
          });
        }
      } catch (e) {
        showError(e.toString());
      }
    }
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
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                child: Image(
                  image: AssetImage("images/police_logo.png"),
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.isEmpty)
                                return 'First Name cannot be empty';
                            },
                            decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(Icons.person)),
                            onSaved: (input) => _first_name = input.toString()),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.isEmpty)
                                return 'Last Name cannot be empty';
                            },
                            decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(Icons.person)),
                            onSaved: (input) => _last_name = input.toString()),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.isEmpty)
                                return 'Mobile Number cannot be empty';
                            },
                            decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                prefixIcon: Icon(Icons.phone)),
                            onSaved: (input) => _mobile = input.toString()),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.isEmpty)
                                return 'Email cannot be empty';
                            },
                            decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email)),
                            onSaved: (input) => _email = input.toString()),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.length < 6)
                                return 'Password must contain atleast 6 characters';
                            },
                            decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock)),
                            obscureText: true,
                            onSaved: (input) => _password = input.toString()),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.length < 6)
                                return 'Confirm Password must contain atleast 6 characters';
                            },
                            decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: Icon(Icons.lock)),
                            obscureText: true,
                            onSaved: (input) => _confirm_password = input.toString()),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: signUp,
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.blue.shade900)))),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
