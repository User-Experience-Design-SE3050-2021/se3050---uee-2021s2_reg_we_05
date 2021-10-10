// import 'package:etraffic/page/change_password_page.dart';
// import 'package:etraffic/page/privacy_policy_page.dart';
// import 'package:etraffic/page/profile_page.dart';
// import 'package:etraffic/page/submissions_list_page.dart';
// import 'package:etraffic/page/terms_and_conditions_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:etraffic/google_sign_in.dart';

// class NavigationDrawerWidget extends StatelessWidget {
//   final padding = EdgeInsets.symmetric(horizontal: 20);
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser!;

//     final name = user.displayName.toString();
//     final email = user.email.toString();
//     final urlImage = user.photoURL.toString();

//     return Drawer(
//       child: Material(
//         color: Colors.blue.shade800,
//         child: ListView(
//           children: <Widget>[
//             buildHeader(
//                 urlImage: urlImage,
//                 name: name,
//                 email: email,
//                 onClicked: () => Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => ProfilePage(),
//                     ))),

//             Container(
//               padding: padding,
//               child: Column(
//                 children: [
//                   Divider(color: Colors.white70),
//                   const SizedBox(height: 6),

//                   buildMenuItem(
//                       text: 'My Profile',
//                       icon: Icons.account_circle,
//                       onClicked: () => selectedItem(context, 0)),
//                   const SizedBox(height: 1),
//                   buildMenuItem(
//                     text: 'Submissions List',
//                     icon: Icons.list,
//                     onClicked: () => selectedItem(context, 1)),
//                   const SizedBox(height: 1),
//                   buildMenuItem(
//                     text: 'Change Password', 
//                     icon: Icons.vpn_key_rounded,
//                     onClicked: () => selectedItem(context, 2)),

//                   const SizedBox(height: 6),
//                   Divider(color: Colors.white70),
//                   const SizedBox(height: 6),

//                   buildMenuItem(
//                     text: 'Terms and Conditions', 
//                     icon: Icons.notes,
//                     onClicked: () => selectedItem(context, 3)),
//                   const SizedBox(height: 1),
//                   buildMenuItem(
//                     text: 'Privacy Policy', 
//                     icon: Icons.shield,
//                     onClicked: () => selectedItem(context, 4)),
//                   const SizedBox(height: 6),
//                   Divider(color: Colors.white70),
//                   const SizedBox(height: 6),
//                   buildMenuItem(
//                     text: 'Logout', 
//                     icon: Icons.exit_to_app,
//                     onClicked: () => selectedItem(context, 5)),
//                 ],
//               )
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildHeader({
//     required String urlImage,
//     required String name,
//     required String email,
//     required VoidCallback onClicked,
//   }) =>
//       InkWell(
//         onTap: onClicked,
//         child: Container(
//           padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
//           child: Row(
//             children: [
//               CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
//               SizedBox(width: 20),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: TextStyle(fontSize: 20, color: Colors.white),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     email,
//                     style: TextStyle(fontSize: 14, color: Colors.white),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       );

//   Widget buildMenuItem({
//     required String text,
//     required IconData icon,
//     VoidCallback? onClicked,
//   }) {
//     final color = Colors.white;
//     final hoverColor = Colors.white70;

//     return ListTile(
//       leading: Icon(icon, color: color),
//       title: Text(text, style: TextStyle(color: color)),
//       hoverColor: hoverColor,
//       onTap: onClicked,
//     );
//   }

//   void selectedItem(BuildContext context, int index) {
//     Navigator.of(context).pop();

//     switch (index) {
//       case 0:
//         Navigator.of(context).push(MaterialPageRoute(
//           builder: (context) => ProfilePage(),
//         ));
//         break;
//       case 1:
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => SubmissionsListPage(),
//       ));
//       break;
//       case 2:
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => ChangePasswordPage(),
//       ));
//       break;
//       case 3:
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => TermsAndConditionsPage(),
//       ));
//       break;
//       case 4:
//       Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => PrivacyPolicyPage(),
//       ));
//       break;
//       case 5:
//       final provider = Provider.of<GoogleSignInProvider>(
//           context,
//           listen: false);
//       provider.logout();
//       break;
//     }
//   }
// }



// // import 'package:etraffic/page/change_password_page.dart';
// // import 'package:etraffic/page/feedback.dart';
// // import 'package:etraffic/page/privacy_policy_page.dart';
// // import 'package:etraffic/page/profile_page.dart';
// // import 'package:etraffic/page/submissions_list_page.dart';
// // import 'package:etraffic/page/terms_and_conditions_page.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:etraffic/google_sign_in.dart';

// // class NavigationDrawerWidget extends StatelessWidget {
// //   final padding = EdgeInsets.symmetric(horizontal: 20);
// //   @override
// //   Widget build(BuildContext context) {
// //     final user = FirebaseAuth.instance.currentUser!;

// //     final name = user.displayName.toString();
// //     final email = user.email.toString();
// //     final urlImage = user.photoURL.toString();

// //     return Drawer(
// //       child: Material(
// //         color: Colors.blue.shade800,
// //         child: ListView(
// //           children: <Widget>[
// //             buildHeader(
// //                 urlImage: urlImage,
// //                 name: name,
// //                 email: email,
// //                 onClicked: () => Navigator.of(context).push(MaterialPageRoute(
// //                       builder: (context) => ProfilePage(),
// //                     ))),

// //             Container(
// //               padding: padding,
// //               child: Column(
// //                 children: [
// //                   Divider(color: Colors.white70),
// //                   const SizedBox(height: 6),

// //                   buildMenuItem(
// //                       text: 'My Profile',
// //                       icon: Icons.account_circle,
// //                       onClicked: () => selectedItem(context, 0)),
// //                   const SizedBox(height: 1),
// //                   buildMenuItem(
// //                     text: 'Submissions List',
// //                     icon: Icons.list,
// //                     onClicked: () => selectedItem(context, 1)),
// //                   const SizedBox(height: 1),
// //                   buildMenuItem(
// //                     text: 'Change Password', 
// //                     icon: Icons.vpn_key_rounded,
// //                     onClicked: () => selectedItem(context, 2)),

// //                   const SizedBox(height: 6),
// //                   Divider(color: Colors.white70),
// //                   const SizedBox(height: 6),

// //                   buildMenuItem(
// //                     text: 'Terms and Conditions', 
// //                     icon: Icons.notes,
// //                     onClicked: () => selectedItem(context, 3)),
// //                   const SizedBox(height: 1),
// //                   buildMenuItem(
// //                     text: 'Privacy Policy', 
// //                     icon: Icons.shield,
// //                     onClicked: () => selectedItem(context, 4)),
// //                   const SizedBox(height: 6),
// //                   Divider(color: Colors.white70),
// //                   const SizedBox(height: 6),
// //                   buildMenuItem(
// //                       text: 'User Feedback',
// //                       icon: Icons.account_circle,
// //                       onClicked: () => selectedItem(context, 5)),
// //                   const SizedBox(height: 1),
// //                   buildMenuItem(
// //                     text: 'Logout', 
// //                     icon: Icons.exit_to_app,
// //                     onClicked: () => selectedItem(context, 6)),
// //                 ],
// //               )
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Widget buildHeader({
// //     required String urlImage,
// //     required String name,
// //     required String email,
// //     required VoidCallback onClicked,
// //   }) =>
// //       InkWell(
// //         onTap: onClicked,
// //         child: Container(
// //           padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
// //           child: Row(
// //             children: [
// //               CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
// //               SizedBox(width: 20),
// //               Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     name,
// //                     style: TextStyle(fontSize: 20, color: Colors.white),
// //                   ),
// //                   SizedBox(height: 4),
// //                   Text(
// //                     email,
// //                     style: TextStyle(fontSize: 14, color: Colors.white),
// //                   ),
// //                 ],
// //               )
// //             ],
// //           ),
// //         ),
// //       );

// //   Widget buildMenuItem({
// //     required String text,
// //     required IconData icon,
// //     VoidCallback? onClicked,
// //   }) {
// //     final color = Colors.white;
// //     final hoverColor = Colors.white70;

// //     return ListTile(
// //       leading: Icon(icon, color: color),
// //       title: Text(text, style: TextStyle(color: color)),
// //       hoverColor: hoverColor,
// //       onTap: onClicked,
// //     );
// //   }

// //   void selectedItem(BuildContext context, int index) {
// //     Navigator.of(context).pop();

// //     switch (index) {
// //       case 0:
// //         Navigator.of(context).push(MaterialPageRoute(
// //           builder: (context) => ProfilePage(),
// //         ));
// //         break;
// //       case 1:
// //       Navigator.of(context).push(MaterialPageRoute(
// //         builder: (context) => SubmissionsListPage(),
// //       ));
// //       break;
// //       case 2:
// //       Navigator.of(context).push(MaterialPageRoute(
// //         builder: (context) => ChangePasswordPage(),
// //       ));
// //       break;
// //       case 3:
// //       Navigator.of(context).push(MaterialPageRoute(
// //         builder: (context) => TermsAndConditionsPage(),
// //       ));
// //       break;
// //       case 4:
// //       Navigator.of(context).push(MaterialPageRoute(
// //         builder: (context) => PrivacyPolicyPage(),
// //       ));
// //       break;
// //       case 5:
// //       Navigator.of(context).push(MaterialPageRoute(
// //         builder: (context) => RatingPage(),
// //       ));
// //       break;
// //       case 6:
// //       final provider = Provider.of<GoogleSignInProvider>(
// //           context,
// //           listen: false);
// //       provider.logout();
// //       break;
// //     }
// //   }
// // }


import 'package:etraffic/Feedback.dart';
import 'package:etraffic/page/change_password_page.dart';
import 'package:etraffic/page/privacy_policy_page.dart';
import 'package:etraffic/page/profile_page.dart';
import 'package:etraffic/page/submissions_list_page.dart';
import 'package:etraffic/page/terms_and_conditions_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:etraffic/google_sign_in.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    final name = user.displayName.toString();
    final email = user.email.toString();
    final urlImage = user.photoURL.toString();

    return Drawer(
      child: Material(
        color: Colors.blue.shade800,
        child: ListView(
          children: <Widget>[
            buildHeader(
                urlImage: urlImage,
                name: name,
                email: email,
                onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ))),

            Container(
              padding: padding,
              child: Column(
                children: [
                  Divider(color: Colors.white70),
                  const SizedBox(height: 6),

                  buildMenuItem(
                      text: 'My Profile',
                      icon: Icons.account_circle,
                      onClicked: () => selectedItem(context, 0)),
                  const SizedBox(height: 1),
                  buildMenuItem(
                    text: 'Submissions List',
                    icon: Icons.list,
                    onClicked: () => selectedItem(context, 1)),
                  const SizedBox(height: 1),
                  buildMenuItem(
                    text: 'Change Password', 
                    icon: Icons.vpn_key_rounded,
                    onClicked: () => selectedItem(context, 2)),

                  const SizedBox(height: 6),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 6),

                  buildMenuItem(
                    text: 'Terms and Conditions', 
                    icon: Icons.notes,
                    onClicked: () => selectedItem(context, 3)),
                  const SizedBox(height: 1),
                  buildMenuItem(
                    text: 'Privacy Policy', 
                    icon: Icons.shield,
                    onClicked: () => selectedItem(context, 4)),
                  const SizedBox(height: 6),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 6),
                  buildMenuItem(
                    text: 'User Feedback', 
                    icon: Icons.account_circle,
                    onClicked: () => selectedItem(context, 5)),
                  const SizedBox(height: 6),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 6),
                  buildMenuItem(
                    text: 'Logout', 
                    icon: Icons.exit_to_app,
                    onClicked: () => selectedItem(context, 6)),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProfilePage(),
        ));
        break;
      case 1:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SubmissionsListPage(),
      ));
      break;
      case 2:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ChangePasswordPage(),
      ));
      break;
      case 3:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TermsAndConditionsPage(),
      ));
      break;
      case 4:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PrivacyPolicyPage(),
      ));
      break;
      case 5:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => RatingPage(),
      ));
      break;
      case 6:
      final provider = Provider.of<GoogleSignInProvider>(
          context,
          listen: false);
      provider.logout();
      break;
    }
  }
}