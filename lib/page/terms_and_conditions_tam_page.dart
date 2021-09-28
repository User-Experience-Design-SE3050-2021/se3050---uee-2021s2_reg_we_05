import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsTamilPage extends StatefulWidget {
  const TermsAndConditionsTamilPage({Key? key}) : super(key: key);

  @override
  _TermsAndConditionsTamilPageState createState() =>
      _TermsAndConditionsTamilPageState();
}

class _TermsAndConditionsTamilPageState
    extends State<TermsAndConditionsTamilPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _tc_tamil;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blue,
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
                      child: Text(_tc_tamil),
                    );
                }
              })),
    );
  }
}
