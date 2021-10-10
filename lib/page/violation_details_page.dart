import 'dart:io';
import 'package:etraffic/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ViolationDetailsPage extends StatefulWidget {
  final File violation_image;

  const ViolationDetailsPage({Key? key, required this.violation_image})
      : super(key: key);

  @override
  _ViolationDetailsPageState createState() => _ViolationDetailsPageState();
}

class _ViolationDetailsPageState extends State<ViolationDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://etraffic-8ba4d.appspot.com');
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  String _description = '';
  String _comment = '';
  var _location = "";
  String downloadUrl = '';

  @override
  void initState() {
    super.initState();
    // this.getCurrentLocation();
  }

  saveViolation() {
    Fluttertoast.showToast(
        msg: "Image saved to device storage",
        backgroundColor: Colors.grey,
        fontSize: 18);
  }

  uploadViolation(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        var baseName = await basename(widget.violation_image.toString());
        var storageRef = storage
            .ref()
            .child('violations/user/${user.uid}/violation/$baseName');
        var uploadTask = storageRef.putFile(widget.violation_image);
        await uploadTask.whenComplete(() async {
          try {
            downloadUrl = await storageRef.getDownloadURL();

            await firestore
                .collection('violations')
                .doc(user.uid)
                .collection('violation')
                .doc(baseName)
                .set({
              'imageUrl': downloadUrl,
              'status': 'Submitted',
              'description': _description,
              'comment': _comment,
              'location': _location,
              'dateTime': new DateTime.now()
            }).then((value) => {
                      Fluttertoast.showToast(
                          msg: "Violation reported successfully",
                          backgroundColor: Colors.grey,
                          fontSize: 18),
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()))
                    });
          } catch (onError) {
            print(onError);
          }
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  // void getCurrentLocation() async {
  //   var position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  //   var lastPosition = await Geolocator.getLastKnownPosition();
  //   print(lastPosition);
  //   setState(() {
  //     _location = "$position";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Violation Details'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              Image.file(
                widget.violation_image,
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                          child: Text(
                            'Description',
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              color: Color(0xff8f9db5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                        child: TextFormField(
                          validator: (input) {
                            if (input != null && input.isEmpty)
                              return 'Description cannot be empty';
                          },
                          onSaved: (input) => _description = input.toString(),
                          style: TextStyle(
                              fontSize: 19,
                              color: Color(0xff0962ff),
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Parking on the wrong side',
                            hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[350],
                                fontWeight: FontWeight.w600),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            focusColor: Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff0962ff)),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: (Colors.grey[350])!,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                          child: Text(
                            'Comment/Suggestion',
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              color: Color(0xff8f9db5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                        child: TextFormField(
                          onSaved: (input) => _comment = input.toString(),
                          style: TextStyle(
                              fontSize: 19,
                              color: Color(0xff0962ff),
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Had parked blocking an entrance',
                            hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[350],
                                fontWeight: FontWeight.w600),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            focusColor: Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff0962ff)),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: (Colors.grey[350])!,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                          child: Text(
                            'Location',
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              color: Color(0xff8f9db5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                        child: TextFormField(
                          // initialValue: _location,
                          initialValue: "35.1685326, 9.6584235",
                          enabled: false,
                          keyboardType: TextInputType.number,
                          validator: (input) {
                            if (input != null && input.isEmpty)
                              return 'Location cannot be empty';
                          },
                          onSaved: (input) => _location = input.toString(),
                          style: TextStyle(
                              fontSize: 19,
                              color: Color(0xff0962ff),
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: '42.048, 2.483',
                            hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[350],
                                fontWeight: FontWeight.w600),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 25),
                            focusColor: Color(0xff0962ff),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Color(0xff0962ff)),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: (Colors.grey[350])!,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: saveViolation,
                              child: Text(
                                'SAVE',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue.shade800),
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      EdgeInsets.fromLTRB(50, 15, 50, 15))),
                            ),
                            SizedBox(width: 20),
                            ElevatedButton(
                              onPressed: () => uploadViolation(context),
                              child: Text(
                                'UPLOAD',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blue.shade800),
                                  padding: MaterialStateProperty.all<
                                          EdgeInsetsGeometry>(
                                      EdgeInsets.fromLTRB(40, 15, 40, 15))),
                            ),
                          ]),
                      SizedBox(height: 30)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
