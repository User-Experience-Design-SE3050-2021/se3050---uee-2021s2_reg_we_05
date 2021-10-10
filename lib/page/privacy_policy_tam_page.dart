import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//PRIVACY POLICY PAGE - (TAMIL)
class PrivacyPolicyTamilPage extends StatefulWidget {
  const PrivacyPolicyTamilPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyTamilPageState createState() =>
      _PrivacyPolicyTamilPageState();
}

//FIREBASE CONNECTIVITY
class _PrivacyPolicyTamilPageState
    extends State<PrivacyPolicyTamilPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _pp_tamil;
  var _line1;
  var _line2;
  var _line3;
  var _line4;

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

    _line1 = await _pp_tamil.split('பார்வையாளர்களின் தனியுரிமை. ')[1].split(' இந்த கொள்கை ஆஃப்லைன்')[0];
    _line2 = await _pp_tamil.split('தகவல்களுக்கு செல்லுபடியாகும். ')[1].split(' உங்கள் தகவலை நாங்கள்')[0];
    _line3 = await _pp_tamil.split('eTraffic பின்பற்றுகிறது. ')[1].split(' இது நிகழும்போது அவர்கள்')[0];
    _line4 = await _pp_tamil.split('உங்களுக்கு அறிவுறுத்துகிறோம். ')[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          color: Colors.lightBlue[50],
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
