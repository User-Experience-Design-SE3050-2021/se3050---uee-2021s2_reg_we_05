import 'package:etraffic/google_sign_in.dart';
import 'package:etraffic/navigation_drawer_widget.dart';
import 'package:etraffic/page/violation_details_page.dart';
import 'package:etraffic/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User user;
  bool isLoggedIn = false;
  File? image;
  var _firstName;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);

      Navigator.of(context).push(new MaterialPageRoute(
          builder: (context) =>
              new ViolationDetailsPage(violation_image: File(image.path))));
    } on PlatformException catch (e) {
      print('Failed to pick image $e');
    }
  }

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Start()));
      }
    });
  }

  getUser() async {
    User? firebaseUser = await _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser!;
        this.isLoggedIn = true;
        _firstName = user.displayName.toString();
      });
    }
  }

  signOut() async {
    _auth.signOut();
  }

  @override
  void initState() {
    this.checkAuthentication();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery. of(context). size. height;

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backwardsCompatibility: false,
        backgroundColor: Colors.blue.shade700,
        title: _firstName == null
            ? CircularProgressIndicator()
            : Text('Hi ' + _firstName!.split(' ').first + '!'),
      ),
      body: Container(
        child: !isLoggedIn
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                  'Need to report a violation?',
                  style: TextStyle(
                    fontFamily: 'Cardo',
                    fontSize: 25,
                    color: Color(0xff0C2551),
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 25),
                MaterialButton(
                  elevation: 10,
                onPressed: () => pickImage(ImageSource.camera),
                color: Colors.blue,
                textColor: Colors.white,
                child: Icon(
                  Icons.camera_alt,
                  size: 24,
                ),
                padding: EdgeInsets.all(45),
                shape: CircleBorder(),
              ),
              SizedBox(height: 25),
              SizedBox(
                  width:300,
                  child: Text(
                  'Click the button above to open the camera and submit a picture of the violation',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                ),
                ],
              )
            )
      ),
    );
  }

  Widget buildButton({
    required String title,
    required IconData icon,
    required VoidCallback onClicked,
  }) =>
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              minimumSize: Size.fromHeight(56),
              primary: Colors.white,
              onPrimary: Colors.black,
              textStyle: TextStyle(fontSize: 20)),
          child: Row(
            children: [
              Icon(icon, size: 28),
              const SizedBox(width: 16),
              Text(title)
            ],
          ),
          onPressed: onClicked);
}
