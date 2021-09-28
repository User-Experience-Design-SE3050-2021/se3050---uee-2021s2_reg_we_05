import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String avatarUrl;
  final Function()? onTap;

  const Avatar({Key? key, required this.avatarUrl, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Center(
      child: Stack(
        children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 53.0,
          child: (avatarUrl == '') 
        ? CircleAvatar(
         radius: 50.0,
         backgroundImage: NetworkImage('https://www.thepeakid.com/wp-content/uploads/2016/03/default-profile-picture.jpg'))
        : CircleAvatar(
         radius: 50.0,
         backgroundImage: NetworkImage(avatarUrl)),
        ),
        Positioned(bottom: 0, right: 4, child: buildEditIcon(color)),
      ],
      )
    ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle(
        {required Widget child, required double all, required Color color}) =>
    ClipOval(
      child: Container(
        padding: EdgeInsets.all(all),
        color: color,
        child: child,
      ),
    );
}