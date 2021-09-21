import 'package:flutter/material.dart';

class SubmissionsListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: Text('Submissions List'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
      ),
    );
  }
}