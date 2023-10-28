import 'package:flutter/material.dart';

class CardProfile extends StatelessWidget {
  var divisorColor = Color.fromRGBO(189, 174, 167, 1);
  var primaryColor = Color.fromRGBO(255, 132, 0, 1);
  final double size;
  final String photo;
  CardProfile({Key key, this.size, this.photo}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Color(0xfffafafa),
      child: CircleAvatar(
        backgroundImage: photo != null
            ? NetworkImage(photo)
            : AssetImage('assets/img/defaultUser.png'),
        backgroundColor: Colors.white,
        // child: ,
        radius: size - 3,
      ),
    );
  }
}
