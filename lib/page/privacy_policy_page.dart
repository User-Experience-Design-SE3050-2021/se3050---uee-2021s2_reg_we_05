import 'package:etraffic/page/privacy_policy_eng_page.dart';
import 'package:etraffic/page/privacy_policy_sin_page.dart';
import 'package:etraffic/page/privacy_policy_tam_page.dart';
import 'package:flutter/material.dart';

//PRIVACY POLICY PAGE
class PrivacyPolicyPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backwardsCompatibility: false,
          title: Text('Privacy Policy'),
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
          PrivacyPolicyEnglishPage(),
          PrivacyPolicySinhalaPage(),
          PrivacyPolicyTamilPage()
          // Center(child: Text('English')),
          // Center(child: Text('Sinhala')),
          // Center(child: Text('Tamil')),
        ]),
      ),
    );
  }
}