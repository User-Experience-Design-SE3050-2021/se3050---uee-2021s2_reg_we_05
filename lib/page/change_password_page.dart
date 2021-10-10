import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//CHANGE PASSWORD PAGE
class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  var _current_pw, _new_pw, _reconfirm_pw, user, cred;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _currentPasswordController = TextEditingController();
  var _newPasswordController = TextEditingController();
  var _confirmNewPasswordController = TextEditingController();

  bool checkCurrentPasswordValid = true;

  @override
  void initState() {
    super.initState();
  }

  changePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      user = await FirebaseAuth.instance.currentUser;
      cred = await EmailAuthProvider.credential(
          email: user!.email.toString(), password: _current_pw.toString());

      if (cred == null) {
        Fluttertoast.showToast(
            msg: "Provided password is incorrect",
            backgroundColor: Colors.grey,
            fontSize: 18);
      }

      //SUCCESSFUL/UNSUCCESSFUL TOAST MESSAGES
      user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(_reconfirm_pw).then((value) {
          Fluttertoast.showToast(
              msg: "Password changed successfully",
              backgroundColor: Colors.grey,
              fontSize: 18);
        }).catchError((onError) {
          Fluttertoast.showToast(
              msg: "Error: Unable to change password",
              backgroundColor: Colors.grey,
              fontSize: 18);
        });
      }).catchError((onError) {
        Fluttertoast.showToast(
          msg: "Provided password does not match",
          backgroundColor: Colors.grey,
          fontSize: 18);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      appBar: AppBar(
        title: Text('Change Password'),
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
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 50.0, bottom: 8, top: 30),
                            child: Text(
                              'Current Password',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 15,
                                color: Color(0xff8f9db5),
                              ),
                            ),
                          ),
                        ),
                        
                        //VALIDATIONS TO MAKE CURRENT PASSWORD FIELD REQUIRED AND PASSWORD LENGTH TO EXCEED 6 CHARACTERS
                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              obscureText: true,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'Current password cannot be empty';
                              },
                              onSaved: (input) => _current_pw = input.toString(),
                              controller: _currentPasswordController,
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
                              'New Password',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 15,
                                color: Color(0xff8f9db5),
                              ),
                            ),
                          ),
                        ),

                        //VALIDATIONS TO MAKE NEW PASSWORD FIELD REQUIRED AND PASSWORD LENGTH TO BE MORE THAN 6 CHARACTERS
                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              obscureText: true,
                              validator: (input) {
                                if (input != null && input.isEmpty)
                                  return 'New password cannot be empty';
                              },
                              onSaved: (input) => _new_pw = input.toString(),
                              controller: _newPasswordController,
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
                              'Confirm Password',
                              style: TextStyle(
                                fontFamily: 'Product Sans',
                                fontSize: 15,
                                color: Color(0xff8f9db5),
                              ),
                            ),
                          ),
                        ),

                        //VALIDATIONS TO ENSURE PASSWORDS DO NOT MATCH EACH OTHER AND PASSWORD LENGTH TO EXCEED 6 CHARACTERS
                        Container(
                          padding: const EdgeInsets.fromLTRB(40, 0, 40, 15),
                          child: TextFormField(
                              obscureText: true,
                              validator: (input) {
                                if(input != _newPasswordController.text)
                                  return 'Confirm password does not match';
                              },
                              onSaved: (input) => _reconfirm_pw = input.toString(),
                              controller: _confirmNewPasswordController,
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
                                    color: (Colors.grey[350])!,
                                  )),
                                ),
                              ),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: changePassword,
                        child: Text(
                          'CHANGE PASSWORD',
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
