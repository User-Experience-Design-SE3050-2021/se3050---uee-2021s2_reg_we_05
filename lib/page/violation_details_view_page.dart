import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etraffic/homepage.dart';
import 'package:etraffic/page/submissions_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:etraffic/model/violation_data_model.dart';
import 'package:flutter/material.dart';

class ViolationDetailsViewPage extends StatefulWidget {
  final ViolationDataModel violationDataModel;

  const ViolationDetailsViewPage({Key? key, required this.violationDataModel})
      : super(key: key);

  @override
  _ViolationDetailsViewPageState createState() =>
      _ViolationDetailsViewPageState();
}

class _ViolationDetailsViewPageState extends State<ViolationDetailsViewPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://etraffic-8ba4d.appspot.com');

  String _description = '';
  String _comment = '';
  String _location = '';
  String _downloadUrl = '';
  String _status = '';
  var endRemoved;
  var result;

  @override
  void initState() {
    super.initState();
    this.assignValues();
  }

  Future<void> assignValues() async {
    _description = widget.violationDataModel.description;
    _comment = widget.violationDataModel.comment;
    _location = widget.violationDataModel.location;
    _downloadUrl = widget.violationDataModel.imageUrl;
    _status = widget.violationDataModel.status;
    endRemoved = _downloadUrl.split('?alt')[0];
    //result is the document id
    result = endRemoved.split('violation%2F')[1];
  }

//method to update violatins
  updateViolation() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await firestore
            .collection('violations')
            .doc(user.uid)
            .collection('violation')
            .doc(result)
            .update({
          'status': 'Submitted',
          'description': _description,
          'comment': _comment,
          'location': _location,
          'dateTime': new DateTime.now()
        }).then((value) => {
                  Fluttertoast.showToast(
                      msg: "Details updated successfully",
                      backgroundColor: Colors.grey,
                      fontSize: 18)
                });
      } catch (onError) {
        print(onError);
      }
    }
  }

//method to delete violation
  deleteViolation(String val, BuildContext context) async {
    storage
        .ref()
        .child('violations/user/${user.uid}/violation/$result')
        .delete()
        .then((value) => {
              firestore
                  .collection('violations')
                  .doc(user.uid)
                  .collection('violation')
                  .doc(result)
                  .delete()
                  .then((value) => {
                        Fluttertoast.showToast(
                            msg: "Violation deleted successfully",
                            backgroundColor: Colors.grey,
                            fontSize: 18),
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => HomePage()))
                      })
            });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: assignValues(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('none');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
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
                        SizedBox(height: 30),
                        Text(
                          _status,
                          style: TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: (_status == 'Submitted')
                                  ? Colors.lightGreen[300]
                                  : (_status == 'In review')
                                      ? Colors.orange
                                      : (_status == 'Rejected')
                                          ? Colors.red
                                          : Colors.green),
                        ),
                        SizedBox(height: 20),
                        Image.network(
                          _downloadUrl,
                          width: 190,
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
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    initialValue: _description,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Description cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _description = input.toString(),
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
                                        borderSide: BorderSide(
                                            color: Color(0xff0962ff)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    initialValue: _comment,
                                    onSaved: (input) =>
                                        _comment = input.toString(),
                                    style: TextStyle(
                                        fontSize: 19,
                                        color: Color(0xff0962ff),
                                        fontWeight: FontWeight.bold),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Had parked blocking an entrance',
                                      hintStyle: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[350],
                                          fontWeight: FontWeight.w600),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 20, horizontal: 25),
                                      focusColor: Color(0xff0962ff),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Color(0xff0962ff)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                    padding: const EdgeInsets.only(
                                        left: 50.0, bottom: 8),
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
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 0, 40, 15),
                                  child: TextFormField(
                                    initialValue: _location,
                                    keyboardType: TextInputType.number,
                                    validator: (input) {
                                      if (input != null && input.isEmpty)
                                        return 'Location cannot be empty';
                                    },
                                    onSaved: (input) =>
                                        _location = input.toString(),
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
                                        borderSide: BorderSide(
                                            color: Color(0xff0962ff)),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: (Colors.grey[350])!,
                                          )),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                SizedBox(height: 20),
                                if (_status == 'Submitted') ...[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: updateViolation,
                                          child: Text(
                                            'UPDATE',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.blue.shade800),
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.fromLTRB(
                                                          50, 15, 50, 15))),
                                        ),
                                        SizedBox(width: 10),
                                        ElevatedButton(
                                          onPressed: () => showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  AlertDialog(
                                                    title: Text(
                                                        'Confirm Deletion'),
                                                    content: Text(
                                                        'Click "OK" to confirm deletion'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'Cancel'),
                                                          child:
                                                              Text('Cancel')),
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context,
                                                                  'OK'),
                                                          child: Text('OK'))
                                                    ],
                                                  )).then((value) => {
                                                if (value == 'OK')
                                                  {
                                                    deleteViolation(
                                                        value.toString(),
                                                        context)
                                                  }
                                              }),
                                          child: Text(
                                            'DELETE',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                              )),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Colors.red.shade800),
                                              padding: MaterialStateProperty
                                                  .all<EdgeInsetsGeometry>(
                                                      EdgeInsets.fromLTRB(
                                                          50, 15, 50, 15))),
                                        ),
                                      ]),
                                  SizedBox(height: 30)
                                ]
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
        });
  }
}
