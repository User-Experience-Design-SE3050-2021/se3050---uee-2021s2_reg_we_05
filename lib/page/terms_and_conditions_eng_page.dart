import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsEnglishPage extends StatefulWidget {
  const TermsAndConditionsEnglishPage({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsEnglishPageState createState() =>
      _TermsAndConditionsEnglishPageState();
}

class _TermsAndConditionsEnglishPageState
    extends State<TermsAndConditionsEnglishPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _tc_english;

  @override
  void initState() {
    super.initState();
    this.getTCEnglish;
  }

  Future getTCEnglish() async {
    await FirebaseFirestore.instance
        .collection('termsAndConditions')
        .doc('1')
        .get()
        .then((value) {
      _tc_english = value.data()!['english'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blue,
          child: FutureBuilder(
              future: getTCEnglish(),
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
                      child: Text(_tc_english),
                    );
                }
              })),
    );
  }
}
