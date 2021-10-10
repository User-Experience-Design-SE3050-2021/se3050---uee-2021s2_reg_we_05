import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//TERMS AND CONDITIONS PAGE (SINHALA)
class TermsAndConditionsSinhalaPage extends StatefulWidget {
  const TermsAndConditionsSinhalaPage({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsSinhalaPageState createState() =>
      _TermsAndConditionsSinhalaPageState();
}

//FIREBASE CONNECTIVITY
class _TermsAndConditionsSinhalaPageState
    extends State<TermsAndConditionsSinhalaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _tc_sinhala;
  var _line1;
  var _line2;
  var _line3;
  var _line4;

  @override
  void initState() {
    super.initState();
    this.getTCSinhala;
  }

  Future getTCSinhala() async {
    await FirebaseFirestore.instance
        .collection('termsAndConditions')
        .doc('1')
        .get()
        .then((value) {
      _tc_sinhala = value.data()!['sinhala'];
    });

    _line1 = await _tc_sinhala.split('  මෙයට ප්‍රවේශ වීමෙන්')[0];
    _line2 = await _tc_sinhala.split('පිළිගනිමු!  ')[1].split('  මෙම නියමයන් සහ')[0];
    _line3 = await _tc_sinhala.split('නීතියට යටත් වේ. ')[1].split(' අපගේ සමහර')[0];
    _line4 = await _tc_sinhala.split('සමාලෝචනය නොකරයි. ')[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          color: Colors.lightBlue[50],
          child: FutureBuilder(
              future: getTCSinhala(),
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
