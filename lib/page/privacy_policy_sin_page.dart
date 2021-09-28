import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrivacyPolicySinhalaPage extends StatefulWidget {
  const PrivacyPolicySinhalaPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicySinhalaPageState createState() =>
      _PrivacyPolicySinhalaPageState();
}

class _PrivacyPolicySinhalaPageState
    extends State<PrivacyPolicySinhalaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _pp_sinhala;

  @override
  void initState() {
    super.initState();
    this.getPPSinhala;
  }

  Future getPPSinhala() async {
    await FirebaseFirestore.instance
        .collection('privacyPolicy')
        .doc('1')
        .get()
        .then((value) {
      _pp_sinhala = value.data()!['sinhala'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blue,
          child: FutureBuilder(
              future: getPPSinhala(),
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
                      child: Text(_pp_sinhala),
                    );
                }
              })),
    );
  }
}
