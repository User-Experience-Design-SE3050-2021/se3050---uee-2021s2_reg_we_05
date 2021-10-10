import 'dart:io';
import 'package:etraffic/model/violation_data_model.dart';
import 'package:etraffic/page/violation_details_view_page.dart';
import 'package:etraffic/widget/avatar_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etraffic/widget/profile_picture_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';

class SubmissionsListPage extends StatefulWidget {
  const SubmissionsListPage({Key? key}) : super(key: key);

  @override
  _SubmissionsListPageState createState() => _SubmissionsListPageState();
}

class _SubmissionsListPageState extends State<SubmissionsListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://etraffic-8ba4d.appspot.com');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;
  late CollectionReference _collectionRef;

  late List<ViolationDataModel> violationsList;

  @override
  void initState() {
    super.initState();
    this.getSubmissions();
  }

  Future<void> getSubmissions() async {
    user = await FirebaseAuth.instance.currentUser!;
    _collectionRef = await FirebaseFirestore.instance
        .collection('violations')
        .doc(user!.uid)
        .collection('violation');

    QuerySnapshot querySnapshot = await _collectionRef.get();

    List allData = await querySnapshot.docs.map((doc) => doc.data()).toList();

    violationsList = await List.generate(
        allData.length,
        (index) => ViolationDataModel(
            allData[index]['imageUrl'],
            allData[index]['description'],
            allData[index]['comment'],
            allData[index]['location'],
            allData[index]['status']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          title: Text('Submissions List'),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          backwardsCompatibility: false,
        ),
        body: FutureBuilder(
            future: getSubmissions(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text('none');
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.done:
                  return ListView.separated(
                      separatorBuilder: (_, i) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(color: Colors.black),
                        );
                      },
                      padding: EdgeInsets.only(top: 10, right: 10, left: 10),
                      itemCount: violationsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ViolationDetailsViewPage(
                                          violationDataModel:
                                              violationsList[index])));
                            },
                            child: Container(
                                height: 150,
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0xFFB3E5FC),
                                            offset: Offset(5, 5),
                                            spreadRadius: 1)
                                      ],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Row(
                                    children: <Widget>[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          violationsList[index].imageUrl,
                                          fit: BoxFit.cover,
                                          height: 130,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                violationsList[index]
                                                    .description,
                                                style: TextStyle(
                                                    fontFamily: 'Nunito Sans',
                                                    fontSize: 15,
                                                    color: Colors.grey[600],
                                                    fontWeight: FontWeight.w700,
                                                    height: 2),
                                              ),
                                              Text(
                                                violationsList[index].comment,
                                                style: TextStyle(
                                                    fontFamily: 'Nunito Sans',
                                                    fontSize: 15,
                                                    color: Colors.grey[500],
                                                    fontWeight: FontWeight.w500,
                                                    height: 1.5),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      _buildChip(violationsList[index].status),
                                    ],
                                  ),
                                )));
                      });
              }
            }));
  }

  Widget _buildChip(String status) {
    var text = status;
    var color = Colors.blueGrey;

    switch (status) {
      case "Rejected":
        color = Colors.red;
        break;
      case "Submitted":
        color = Colors.lightGreen;
        break;
      case "Approved":
        color = Colors.green;
        break;
      case "In Review":
        color = Colors.orange;
        break;
      default:
        color = Colors.blueGrey;
    }
    return Container(
      padding: EdgeInsets.all(8),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Text(text,
          style: TextStyle(
              fontFamily: 'Nunito Sans',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.5,
              color: Colors.white)),
    );
  }
}
