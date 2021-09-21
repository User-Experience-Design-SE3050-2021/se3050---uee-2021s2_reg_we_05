import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

      print('HEREEEEEEEEEEEEEEE');
      print(user!.email.toString());
      print(_current_pw.toString());
      print(cred);

      if (cred == null) {
        Fluttertoast.showToast(
            msg: "Provided password is incorrect",
            backgroundColor: Colors.grey,
            fontSize: 18);
      }

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
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
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
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.length < 6)
                                return 'Password must contain atleast 6 characters';
                            },
                            decoration: InputDecoration(
                                labelText: 'Current Password',
                                prefixIcon: Icon(Icons.lock)),
                            controller: _currentPasswordController,
                            obscureText: true,
                            onSaved: (input) => _current_pw = input.toString()),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.length < 6)
                                return 'New Password must contain atleast 6 characters';
                            },
                            decoration: InputDecoration(
                                labelText: 'New Password',
                                prefixIcon: Icon(Icons.lock)),
                            controller: _newPasswordController,
                            obscureText: true,
                            onSaved: (input) => _new_pw = input.toString()),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != _newPasswordController.text)
                                return 'Confirm Password does not match with new password';
                            },
                            decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                prefixIcon: Icon(Icons.lock)),
                            controller: _confirmNewPasswordController,
                            obscureText: true,
                            onSaved: (input) =>
                                _reconfirm_pw = input.toString()),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: changePassword,
                        child: Text(
                          'CHANGE PASSWORD',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900),
                        ),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Colors.blue.shade900)))),
                      )
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
