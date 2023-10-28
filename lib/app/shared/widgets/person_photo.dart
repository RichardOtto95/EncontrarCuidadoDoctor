import 'package:flutter/material.dart';

class PersonPhoto extends StatelessWidget {
  final double size;
  final String photo;
  final Color borderColor;

  const PersonPhoto({
    Key key,
    this.size = 36,
    this.photo,
    this.borderColor = Colors.transparent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 0),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        border: Border.all(
          width: 3.0,
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: CircleAvatar(
        radius: 85,
        backgroundColor: Color(0xfffafafa),
        child: CircleAvatar(
          backgroundImage: photo == null
              ? AssetImage('assets/img/defaultUser.png')
              : NetworkImage(photo),
          backgroundColor: Colors.white,
          radius: 82,
        ),
      ),
    );
  }
}
