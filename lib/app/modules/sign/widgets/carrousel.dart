import 'package:flutter/material.dart';

class Carrousel extends StatelessWidget {
  final int index;
  final int length;

  const Carrousel({Key key, this.index, this.length = 0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < length; i++)
          Container(
            width: 6.0,
            height: 6.0,
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == index ? Color(0xff707070) : Color(0xffB9B9B9),
            ),
          )
      ],
    );
  }
}
