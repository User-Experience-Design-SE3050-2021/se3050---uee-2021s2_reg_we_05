import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyTamilPage extends StatefulWidget {
  const PrivacyPolicyTamilPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyTamilPageState createState() =>
      _PrivacyPolicyTamilPageState();
}

class _PrivacyPolicyTamilPageState
    extends State<PrivacyPolicyTamilPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _pp_tamil;

  @override
  void initState() {
    super.initState();
    this.getPPTamil;
  }

  Future getPPTamil() async {
    await FirebaseFirestore.instance
        .collection('privacyPolicy')
        .doc('1')
        .get()
        .then((value) {
      _pp_tamil = value.data()!['tamil'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.blue,
          child: FutureBuilder(
              future: getPPTamil(),
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
                      child: Text(_pp_tamil),
                    );
                }
              })),
    );
  }
}
