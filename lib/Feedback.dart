import 'package:flutter/material.dart';
import 'package:etraffic/rating.dart';
import 'package:etraffic/homepage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class RatingPage extends StatefulWidget {
  @override
  _RatingPage createState() => _RatingPage();
}

class _RatingPage extends State<RatingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://etraffic-8ba4d.appspot.com');
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  int _rating = 1;
  String _comments = '';

  saveFeedback() async{
      if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          try {
                await firestore
                    .collection('feedbacks')
                    .doc(user.uid)
                    .set({'comments': _comments}).then((value) => {
                          Fluttertoast.showToast(
                              msg: "Feedback recorded successfully",
                              backgroundColor: Colors.grey,
                              fontSize: 18),
                          // Navigator.of(context).push(
                          //     MaterialPageRoute(builder: (context) => HomePage()))
                        });
              } catch (onError) {
        Fluttertoast.showToast(
            msg: "ERROR: Unable to submit your feedback",
            backgroundColor: Colors.grey,
            fontSize: 18);
      }
  }
}

// saveFeedback() async {
//     Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
//   }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
          title: Text('User Feedback'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          backwardsCompatibility: false,
      ),
        body: Stack(
          children: <Widget>[
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:15),
              Padding(
                padding: const EdgeInsets.all(20.0),
              child: Container(child: Text("Rate on how much you are satisfied with the eTraffic App",
                style: TextStyle(color: Colors.black, fontSize: 22.0,fontWeight:FontWeight.bold),)),
            ),
              SizedBox(height:30),
              Rating((rating) {
                setState(() {
                  _rating = rating;
                });
              }, 5),
              SizedBox(
                  height: 60,
                  child: (_rating != null && _rating != 0)
                      ? Text("You selected $_rating rating",
                          style: TextStyle(fontSize: 18))
                      : SizedBox.shrink()),
              SizedBox(height:10),

              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                          child: Text(
                            'Add Comments/Suggestions',
                            style: TextStyle(
                              fontFamily: 'Product Sans',
                              fontSize: 15,
                              color: Color(0xff8f9db5),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 15),
                        child: TextFormField(
                          validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Feedback cannot be empty';
                              },
                          onSaved: (input) => _comments = input.toString(),
                          style: TextStyle(
                              fontSize: 19,
                              color: Color(0xff0962ff),
                              fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'Add comment',
                            hintStyle: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[350],
                                fontWeight: FontWeight.w600),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 30, horizontal: 25),
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
                  ],
                )
              ),
            SizedBox(height:10),
             ElevatedButton(
                      onPressed:saveFeedback,
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100.0),
                          )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.blue.shade800),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                                  EdgeInsets.fromLTRB(50, 10, 50, 10))),
                    ),
            ],
          ),
        )]
    ),
            backgroundColor: Colors.lightBlue[50],
  ),
  );
  
  }
}

