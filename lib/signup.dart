import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etraffic/google_sign_in.dart';
import 'package:etraffic/homepage.dart';
import 'package:etraffic/login.dart';
import 'package:etraffic/page/privacy_policy_page.dart';
import 'package:etraffic/page/terms_and_conditions_page.dart';
import 'package:etraffic/widget/custom_input_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();

  String _first_name = '';
  String _last_name = '';
  String _mobile = '';
  String _email = '';
  String _password = '';
  String _confirm_password = '';

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>Login()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        User? user = (await _auth.createUserWithEmailAndPassword(
                email: _email, password: _password))
            .user;
        if (user != null) {
          user.updateDisplayName(_first_name + ' ' + _last_name);
          firestore.collection('users').doc(user.uid).set({
            'mobile': _mobile
          });
        }
        //send email verification mail to verify the account
        if (user != null){
           user.sendEmailVerification();
               Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
        }
      } catch (e) {
        showError(e.toString());
      }
    }
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

  //navigate to login page
  navigateToLogin(){
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
  }

  //navigate to terms and conditions page
  navigateToTermsAndConditions() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => TermsAndConditionsPage()));
  }

  //navigate to privacy policy page
  navigateToPrivacyPolicy() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
          children: <Widget>[
            new Container(
              // constraints: BoxConstraints.expand(),
              //   decoration: BoxDecoration(
              //       image: DecorationImage(
              //           image: AssetImage("images/ima.png"),
              //           colorFilter: 
              //               ColorFilter.mode(Colors.black.withOpacity(0.8), 
              //               BlendMode.dstATop),
              //           fit: BoxFit.cover)),   
          ),    
          SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                right: 30,
                child: Container(
                 height: 100,
                 child: Image(
                   image: AssetImage("images/police_logo.png"),
                   fit: BoxFit.contain,
                 ),
               )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, top: 60),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontFamily: 'Cardo',
                          fontSize: 35,
                          color: Color(0xff0C2551),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, top: 10),
                      child: Text(
                        'Sign up to create an account',
                        style: TextStyle(
                          fontFamily: 'Nunito Sans',
                          fontSize: 15,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  //
                  SizedBox(
                    height: 30,
                  ),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                            child: Text(
                              'First Name',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 17,
                                color: Color(0xFF0E3311).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        
                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'First Name cannot be empty';
                              },
                              onSaved: (input) => _first_name = input.toString(),
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                    color: Color(0xFF0E3311).withOpacity(0.2),
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
                            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                            child: Text(
                              'Last Name',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 17,
                                color: Color(0xFF0E3311).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Last Name cannot be empty';
                              },
                              onSaved: (input) => _last_name = input.toString(),
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Color(0xFF0E3311).withOpacity(0.2),
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
                            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 17,
                                color: Color(0xFF0E3311).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Email cannot be empty';
                              },
                              onSaved: (input) => _email = input.toString(),
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                      color: Color(0xFF0E3311).withOpacity(0.2),
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
                            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                            child: Text(
                              'Mobile',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 17,
                                color: Color(0xFF0E3311).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        
                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Mobile number cannot be empty';
                              },
                              onSaved: (input) => _mobile = input.toString(),
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                     color: Color(0xFF0E3311).withOpacity(0.2),
                                  )),
                                ),
                              ),
                        ),
                        //
                        SizedBox(
                          height: 5,
                        ),
                        //
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                            child: Text(
                              'Password',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 17,
                                color: Color(0xFF0E3311).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              obscureText: true,
                              controller: _pass,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Password cannot be empty';
                              },
                          //      controller: _pass,
                          //  validator: (input){
                          //     if(input.isEmpty)
                          //          return 'Empty';
                          //     return null;
                          //     }
                              onSaved: (input) => _password = input.toString(),
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xff0962ff),
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: '6+ Characters',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[350],
                                    fontWeight: FontWeight.w600),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                       color: Color(0xFF0E3311).withOpacity(0.2),
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
                            padding: const EdgeInsets.only(left: 50.0, bottom: 8),
                            child: Text(
                              'Confirm Password',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 17,
                                color: Color(0xFF0E3311).withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              obscureText: true,
                              controller: _confirmPass,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Confirm password cannot be empty';
                                if(input != _pass.text)
                                return "Password does not match";
                              },
                          //     controller: _confirmPass,
                          //  validator: (input){
                          //     if(input.isEmpty)
                          //          return 'Empty';
                          //     if(val != _pass.text)
                          //          return 'Not Match'
                          //     return null;
                          //     }
                              onSaved: (input) => _confirm_password = input.toString(),
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Color(0xff0962ff),
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: '6+ Characters',
                                hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[350],
                                    fontWeight: FontWeight.w600),
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                                focusColor: Color(0xff0962ff),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Color(0xff0962ff)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(
                                       color: Color(0xFF0E3311).withOpacity(0.2),
                                  )),
                                ),
                              ),
                        ),
                      ],
                    )
                  ),
                  //
                  SizedBox(
                    height: 10,
                  ),

                  Wrap(
                    children: <Widget>[
                      Text(
                        'Creating an account means you accept our ',
                        style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'Terms and Conditions',
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[300],
                          ),
                        ),
                        onTap: navigateToTermsAndConditions,
                      ),
                      Text(
                        ' and  ',
                        style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[300],
                          ),
                        ),
                        onTap: navigateToPrivacyPolicy,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                        onPressed: signUp,
                        child: Text(
                          'CREATE ACCOUNT',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100.0),
                                    )),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue.shade800),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.fromLTRB(60, 15, 60, 15))),
                      ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Already have an account? ',
                        style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Product Sans',
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        onTap: navigateToLogin,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Row(
                      children: <Widget>[
                          Expanded(
                              child: Divider(
                                indent: 20,
                                color: Colors.black
                              )
                          ),       

                          Text(" OR "),        

                          Expanded(
                              child: Divider(
                                endIndent: 20,
                                color: Colors.black
                              )
                          ),
                      ]
                  ),
                  SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.0)
                        ),
                        onPrimary: Colors.black,
                        textStyle: TextStyle(fontSize: 17),
                        minimumSize: Size(280, 50)),
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
                    label: Text(' Sign Up with Google'),
                    onPressed: () {
                      final provider =
                          Provider.of<GoogleSignInProvider>(context, listen: false);
                      provider.googleLogin(context);
                    },
                  ),
                  SizedBox(height: 30)
                ],
              ),
            ],
          ),
        ),
          ]),
        backgroundColor: Colors.lightBlue[50],
    );
  }
}