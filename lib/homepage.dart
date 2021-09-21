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
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('App Bar'),
      ),
      body: Container(
        child: !isLoggedIn
            ? SizedBox(
                height: MediaQuery.of(context).size.height / 1.3,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Column(
                children: <Widget>[
                  buildButton(
                      title: 'Open Camera',
                      icon: Icons.camera_alt,
                      onClicked: () => pickImage(ImageSource.camera)),

                  // SizedBox(height: 40),
                  // image != null
                  //     ? Image.file(
                  //         image!,
                  //         width: 200,
                  //         height: 400,
                  //         fit: BoxFit.contain,
                  //       )
                  //     : FlutterLogo(size: 160)

                  // Container(
                  //   height: 400,
                  //   child: Image(
                  //     image: AssetImage("images/police_logo.png"),
                  //     fit: BoxFit.contain,
                  //   ),
                  // ),
                  // Container(
                  //   child: Text(
                  //     "Hello ${user.displayName} you are logged in as ${user.email}",
                  //     style: TextStyle(
                  //         fontSize: 20.0, fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // ElevatedButton(
                  //   // onPressed: signOut,
                  //   onPressed: () {
                  //     final provider = Provider.of<GoogleSignInProvider>(
                  //         context,
                  //         listen: false);
                  //     provider.logout();
                  //   },
                  //   child: Text(
                  //     'SIGN OUT',
                  //     style: TextStyle(
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold,
                  //         color: Colors.blue.shade900),
                  //   ),
                  //   style: ButtonStyle(
                  //       shape:
                  //           MaterialStateProperty.all<RoundedRectangleBorder>(
                  //               RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(18.0),
                  //                   side: BorderSide(
                  //                       color: Colors.blue.shade900)))),
                  // )
                ],
              ),
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
