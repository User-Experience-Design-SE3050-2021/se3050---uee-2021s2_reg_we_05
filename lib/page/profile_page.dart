import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etraffic/widget/profile_picture_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user;

  var _first_name;
  var _last_name;
  var _mobile;
  var _email;
  var urlImage;
  var name;
  var val;
  late File _image;
  File? image;

  @override
  void initState() {
    super.initState();
    this.getUser();
    this.getImageFileFromAssets('images/police_logo.png');
  }

  getUser() async {
    user = await FirebaseAuth.instance.currentUser!;

    _first_name = await user!.displayName.toString();
    _last_name = await user!.displayName.toString();
    _email = await user!.email.toString();
    urlImage = await user!.photoURL.toString();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((value) {
      _mobile = value.data()!['mobile'];
    });

    _image = await urlImage;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    image = await file;

    return file;
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  signUp() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Text('active or waiting');
                  case ConnectionState.done:
                    return Container(
                      child: Column(
                        children: <Widget>[
                          image != null
                              ? ProfilePictureWidget(
                                  image: image,
                                  onClicked: (source) => pickImage(source),
                                )
                              : ProfilePictureWidget(
                                  image: image,
                                  onClicked: (source) => pickImage(source),
                                ),
                          Container(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: TextFormField(
                                        initialValue:
                                            _first_name.split(" ").first,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'First Name cannot be empty';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'First Name',
                                            prefixIcon: Icon(Icons.person)),
                                        onSaved: (input) =>
                                            _first_name = input.toString()),
                                  ),
                                  Container(
                                    child: TextFormField(
                                        initialValue:
                                            _first_name.split(" ").last,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'Last Name cannot be empty';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Last Name',
                                            prefixIcon: Icon(Icons.person)),
                                        onSaved: (input) =>
                                            _last_name = input.toString()),
                                  ),
                                  Container(
                                    child: TextFormField(
                                        initialValue: _email,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'Email cannot be empty';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Email',
                                            prefixIcon: Icon(Icons.email)),
                                        onSaved: (input) =>
                                            _email = input.toString()),
                                  ),
                                  Container(
                                    child: TextFormField(
                                        initialValue: _mobile,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'Mobile Number cannot be empty';
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Mobile Number',
                                            prefixIcon: Icon(Icons.phone)),
                                        onSaved: (input) =>
                                            _mobile = input.toString()),
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: signUp,
                                    child: Text(
                                      'UPDATE PROFILE',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900),
                                    ),
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors
                                                        .blue.shade900)))),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                }
              })),
    );
  }
}
