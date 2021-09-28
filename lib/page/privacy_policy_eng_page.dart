import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyEnglishPage extends StatefulWidget {
  const PrivacyPolicyEnglishPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyEnglishPageState createState() =>
      _PrivacyPolicyEnglishPageState();
}

class _PrivacyPolicyEnglishPageState
    extends State<PrivacyPolicyEnglishPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _pp_english;

  @override
  void initState() {
    super.initState();
    this.getPPEnglish;
  }

  Future getPPEnglish() async {
    await FirebaseFirestore.instance
        .collection('privacyPolicy')
        .doc('1')
        .get()
        .then((value) {
      _pp_english = value.data()!['english'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blue,
          child: FutureBuilder(
              future: getPPEnglish(),
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
                      child: Text(_pp_english),
                    );
                }
              })),
    );
  }
}
