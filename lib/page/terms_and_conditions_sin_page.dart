import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsSinhalaPage extends StatefulWidget {
  const TermsAndConditionsSinhalaPage({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsSinhalaPageState createState() =>
      _TermsAndConditionsSinhalaPageState();
}

class _TermsAndConditionsSinhalaPageState
    extends State<TermsAndConditionsSinhalaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _tc_sinhala;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blue,
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
                      child: Text(_tc_sinhala),
                    );
                }
              })),
    );
  }
}
