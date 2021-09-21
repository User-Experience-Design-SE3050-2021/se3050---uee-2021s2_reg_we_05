import 'dart:io';

import 'package:flutter/material.dart';

class ViolationDetailsPage extends StatefulWidget {
  final File? violation_image;

  const ViolationDetailsPage({Key? key, this.violation_image})
      : super(key: key);

  @override
  _ViolationDetailsPageState createState() => _ViolationDetailsPageState();
}

class _ViolationDetailsPageState extends State<ViolationDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _description = '';
  String _comment = '';
  String _location = '';

  saveViolation(){}
  uploadViolation(){}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('Violation Details'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Image.file(
                widget.violation_image!,
                width: 200,
                height: 400,
                fit: BoxFit.contain,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.isEmpty)
                                return 'This field cannot be empty';
                            },
                            decoration: InputDecoration(
                                labelText: 'Description',
                                prefixIcon: Icon(Icons.person)),
                            onSaved: (input) => _description = input.toString()),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.isEmpty)
                                return 'This field cannot be empty';
                            },
                            decoration: InputDecoration(
                                labelText: 'Comments/Suggestions',
                                prefixIcon: Icon(Icons.person)),
                            onSaved: (input) => _comment = input.toString()),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input != null && input.isEmpty)
                                return 'This field cannot be empty';
                            },
                            decoration: InputDecoration(
                                labelText: 'Mobile Number',
                                prefixIcon: Icon(Icons.phone)),
                            onSaved: (input) => _location = input.toString()),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: saveViolation,
                        child: Text(
                          'SAVE',
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
                      ),
                      ElevatedButton(
                        onPressed: uploadViolation,
                        child: Text(
                          'UPLOAD',
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
