import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//PRIVACY POLICY PAGE (SINHALA)
class PrivacyPolicySinhalaPage extends StatefulWidget {
  const PrivacyPolicySinhalaPage({Key? key}) : super(key: key);

  @override
  _PrivacyPolicySinhalaPageState createState() =>
      _PrivacyPolicySinhalaPageState();
}

//FIREBASE CONNECTIVITY
class _PrivacyPolicySinhalaPageState
    extends State<PrivacyPolicySinhalaPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var _pp_sinhala;
  var _line1;
  var _line2;
  var _line3;
  var _line4;

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

    _line1 = await _pp_sinhala.split('පෞද්ගලිකත්‍වය යි. ')[1].split(' අපගේ පෞද්ගලිකත්‍')[0];
    _line2 = await _pp_sinhala.split('තොරතුරකට අදාළ නොවේ. ')[1].split(' ඔබ කෙලින්ම අප හා සම්බන්ධ')[0];
    _line3 = await _pp_sinhala.split('ඔබට පැහැදිලි වනු ඇත. ')[1].split(' ඔබට ඊමේල් යවන්න වංචා')[0];
    _line4 = await _pp_sinhala.split('අදහස් හුවමාරු කර ගන්න. ')[1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.all(10),
          color: Colors.lightBlue[50],
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
