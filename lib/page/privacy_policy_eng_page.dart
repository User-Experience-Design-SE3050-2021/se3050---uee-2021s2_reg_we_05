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
  var _line1;
  var _line2;
  var _line3;
  var _line4;

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

    _line1 = await _pp_english.split('privacy of our visitors. ')[1].split('  This Privacy Policy applies')[0];
    _line2 = await _pp_english.split('hesitate to contact us.  ')[1].split(' When you register')[0];
    _line3 = await _pp_english.split('choose to provide. ')[1].split(' All hosting')[0];
    _line4 = await _pp_english.split('they visit websites. ')[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          color: Colors.lightBlue[50],
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
