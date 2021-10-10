import 'package:etraffic/page/terms_and_conditions_eng_page.dart';
import 'package:etraffic/page/terms_and_conditions_sin_page.dart';
import 'package:etraffic/page/terms_and_conditions_tam_page.dart';
import 'package:flutter/material.dart';

//TERMS AND CONDITIONS PAGE
class TermsAndConditionsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backwardsCompatibility: false,
          title: Text('Terms and Conditions'),
          bottom: TabBar(
            indicatorWeight: 3,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            tabs: <Widget>[
            Tab(text: 'English'),
            Tab(text: 'Sinhala'),
            Tab(text: 'Tamil'),
          ]),
          centerTitle: true,
          backgroundColor: Colors.blue.shade700,
        ),
        body: TabBarView(children: [
          TermsAndConditionsEnglishPage(),
          TermsAndConditionsSinhalaPage(),
          TermsAndConditionsTamilPage(),
          // Center(child: Text('English')),
          // Center(child: Text('Sinhala')),
          // Center(child: Text('Tamil')),
        ]),
      ),
    );
  }
}