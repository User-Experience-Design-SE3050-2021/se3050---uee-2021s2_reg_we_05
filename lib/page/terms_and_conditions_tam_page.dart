import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//TERMS AND CONDITIONS PAGE - (TAMIL)
class TermsAndConditionsTamilPage extends StatefulWidget {
  const TermsAndConditionsTamilPage({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsTamilPageState createState() =>
      _TermsAndConditionsTamilPageState();
}

//FIREBASE CONNECTIVITY
class _TermsAndConditionsTamilPageState
    extends State<TermsAndConditionsTamilPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _tc_tamil;
  var _line1;
  var _line2;
  var _line3;
  var _line4;

  @override
  void initState() {
    super.initState();
    this.getTCTamil;
  }

  Future getTCTamil() async {
    await FirebaseFirestore.instance
        .collection('termsAndConditions')
        .doc('1')
        .get()
        .then((value) {
      _tc_tamil = value.data()!['tamil'];
    });

    _line1 = await _tc_tamil.split('  இதை அணுகுவதன் மூலம் நீங்கள்')[0];
    _line2 = await _tc_tamil.split('வரவேற்கிறோம்!  ')[1].split('  ஒருமை, பன்மை,')[0];
    _line3 = await _tc_tamil.split('உள்ள சட்டத்திற்கு உட்பட்டது. ')[1].split(' குக்கீகள் எங்கள்')[0];
    _line4 = await _tc_tamil.split('கருத்துக்களையும் பிரதிபலிக்கின்றன. ')[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          color: Colors.lightBlue[50],
          child: FutureBuilder(
              future: getTCTamil(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Center(
                      child: Text('none'),
                    );
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.done:
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          Text(
                            _line1,
                            style: TextStyle(
                                letterSpacing: 1, wordSpacing: 1, height: 1.3),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _line2,
                            style: TextStyle(
                                letterSpacing: 1, wordSpacing: 1, height: 1.3),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _line3,
                            style: TextStyle(
                                letterSpacing: 1, wordSpacing: 1, height: 1.3),
                          ),
                          SizedBox(height: 10),
                          Text(
                            _line4,
                            style: TextStyle(
                                letterSpacing: 1, wordSpacing: 1, height: 1.3),
                          ),
                        ],
                      )
                    );
                }
              })),
    );
  }
}
