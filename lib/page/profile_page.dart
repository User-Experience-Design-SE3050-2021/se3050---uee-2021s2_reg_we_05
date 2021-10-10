import 'dart:io';
import 'package:etraffic/start.dart';
import 'package:etraffic/widget/avatar_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
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
  final FirebaseStorage storage =
      FirebaseStorage.instanceFor(bucket: 'gs://etraffic-8ba4d.appspot.com');
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser!;

  var _first_name;
  var _last_name;
  var _mobile;
  var _email;
  var urlImage;
  var name;
  var val;
  late File _image;
  File? image;
  String downloadUrl = '';

  @override
  void initState() {
    super.initState();
    this.getUser();
    this.getImageFileFromAssets('images/police_logo.png');
  }

  getUser() async {
    _first_name = await user.displayName.toString();
    _last_name = await user.displayName.toString();
    _email = await user.email.toString();
    urlImage = await user.photoURL.toString();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) {
      _mobile = value.data()!['mobile'];
    });

    //getting profile pic
    var storageRef = await storage.ref().child('user/profile/${user.uid}');
    downloadUrl = await storageRef.getDownloadURL();

    // _image = await urlImage;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      // if (image == null) return;

      if (image != null) {
        //cropping start
        final cropped = await ImageCropper.cropImage(
            sourcePath: image.path,
            cropStyle: CropStyle.circle,
            aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
            compressQuality: 100,
            maxWidth: 700,
            maxHeight: 700,
            compressFormat: ImageCompressFormat.jpg,
            androidUiSettings: AndroidUiSettings(
                toolbarColor: Colors.blue.shade700,
                toolbarTitle: "Crop Image",
                statusBarColor: Colors.blue.shade900,
                activeControlsWidgetColor: Colors.blue.shade900,
                backgroundColor: Colors.lightBlue[50]));
        //cropping end
        this.setState(() {
          this.image = cropped;
        });

        await uploadProfilePicture(cropped!);
      }

      // final imageTemporary = File(image.path);
      // setState(() => this.image = imageTemporary);
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

  updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        await firestore
            .collection('users')
            .doc(user.uid)
            .set({'mobile': _mobile}).then((value) => {
                  Fluttertoast.showToast(
                      msg: "Details updated successfully",
                      backgroundColor: Colors.grey,
                      fontSize: 18)
                });
      } catch (onError) {
        Fluttertoast.showToast(
            msg: "ERROR: Unable to update user details",
            backgroundColor: Colors.grey,
            fontSize: 18);
      }
    }
  }

  deleteProfile(BuildContext context) async {
    user.delete().then((value) async => {
          await firestore.collection('users').doc(user.uid).delete(),
          Fluttertoast.showToast(
              msg: "User deleted successfully",
              backgroundColor: Colors.grey,
              fontSize: 18),
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Start()))
        });
  }

  uploadProfilePicture(File file) async {
    var storageRef = storage.ref().child('user/profile/${user.uid}');
    var uploadTask = storageRef.putFile(file);
    await uploadTask.whenComplete(() async {
      try {
        downloadUrl = await storageRef.getDownloadURL();
        Fluttertoast.showToast(
            msg: "Profile picture updated successfully",
            backgroundColor: Colors.grey,
            fontSize: 18);
      } catch (onError) {
        Fluttertoast.showToast(
            msg: "ERROR: Unable to update profile picture",
            backgroundColor: Colors.grey,
            fontSize: 18);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('My Profile'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder(
              future: getUser(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('none');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height/3),
                          CircularProgressIndicator()
                        ],
                      )
                    );
                  case ConnectionState.done:
                    return Container(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30),
                          (user.providerData[0].providerId == 'google.com')
                              ? CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 53.0,
                                  child: CircleAvatar(
                                      radius: 50.0,
                                      backgroundImage: NetworkImage(urlImage)))
                              : Avatar(
                                  avatarUrl: downloadUrl,
                                  onTap: () {
                                    pickImage(ImageSource.gallery);
                                  }

                                  // () async {
                                  //   var pickedFile = await ImagePicker()
                                  //       .pickImage(source: ImageSource.gallery);
                                  //   File image = File(pickedFile!.path);

                                  //   await uploadProfilePicture(image);
                                  // }
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
                                          'First Name',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            color: Color(0xff8f9db5),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 40, 15),
                                      child: TextFormField(
                                        initialValue: _first_name.split(' ')[0],
                                        enabled: false,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'First Name cannot be empty';
                                        },
                                        onSaved: (input) =>
                                            _first_name = input.toString(),
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0xff0962ff),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          hintText: 'John',
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[350],
                                              fontWeight: FontWeight.w600),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 25),
                                          focusColor: Color(0xff0962ff),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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
                                    //
                                    SizedBox(
                                      height: 5,
                                    ),

                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0, bottom: 8),
                                        child: Text(
                                          'Last Name',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            color: Color(0xff8f9db5),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 40, 15),
                                      child: TextFormField(
                                        initialValue: _first_name.split(' ')[1],
                                        enabled: false,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'Last Name cannot be empty';
                                        },
                                        onSaved: (input) =>
                                            _last_name = input.toString(),
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0xff0962ff),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          hintText: 'Doe',
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[350],
                                              fontWeight: FontWeight.w600),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 25),
                                          focusColor: Color(0xff0962ff),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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

                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0, bottom: 8),
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            color: Color(0xff8f9db5),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 40, 15),
                                      child: TextFormField(
                                        initialValue: _email,
                                        enabled: false,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'Email cannot be empty';
                                        },
                                        onSaved: (input) =>
                                            _email = input.toString(),
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0xff0962ff),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          hintText: 'johndoe@gmail.com',
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[350],
                                              fontWeight: FontWeight.w600),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 25),
                                          focusColor: Color(0xff0962ff),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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

                                    SizedBox(
                                      height: 5,
                                    ),
                                    //
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 50.0, bottom: 8),
                                        child: Text(
                                          'Mobile',
                                          style: TextStyle(
                                            fontFamily: 'Product Sans',
                                            fontSize: 15,
                                            color: Color(0xff8f9db5),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 0, 40, 15),
                                      child: TextFormField(
                                        initialValue: _mobile,
                                        keyboardType: TextInputType.number,
                                        validator: (input) {
                                          if (input != null && input.isEmpty)
                                            return 'Mobile number cannot be empty';
                                        },
                                        onSaved: (input) =>
                                            _mobile = input.toString(),
                                        style: TextStyle(
                                            fontSize: 19,
                                            color: Color(0xff0962ff),
                                            fontWeight: FontWeight.bold),
                                        decoration: InputDecoration(
                                          hintText: '0771234567',
                                          hintStyle: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey[350],
                                              fontWeight: FontWeight.w600),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 25),
                                          focusColor: Color(0xff0962ff),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
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

                                    ElevatedButton(
                                      onPressed: updateProfile,
                                      child: Text(
                                        'UPDATE PROFILE',
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
                                                BorderRadius.circular(100.0),
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blue.shade800),
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.fromLTRB(
                                                  75, 15, 75, 15))),
                                    ),
                                    SizedBox(height: 13),
                                    ElevatedButton(
                                      onPressed: () => showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                                title: Text('Confirm Deletion'),
                                                content: Text(
                                                    'Click "OK" to confirm deletion'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(context,
                                                              'Cancel'),
                                                      child: Text('Cancel')),
                                                  TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'OK'),
                                                      child: Text('OK'))
                                                ],
                                              )).then((value) => {
                                            if (value == 'OK')
                                              {deleteProfile(context)}
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
                                                BorderRadius.circular(100.0),
                                          )),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.red.shade800),
                                          padding: MaterialStateProperty.all<
                                                  EdgeInsetsGeometry>(
                                              EdgeInsets.fromLTRB(
                                                  119, 15, 119, 15))),
                                    ),

                                    SizedBox(height: 30),
                                  ],
                                )),
                          )
                        ],
                      ),
                    );
                }
              })),
    );
  }
}
