import 'package:flutter/material.dart';

import '../utilities.dart';

class Separator extends StatelessWidget {
  final double vertical;
  final double horizontal;

  const Separator({
    Key key,
    this.vertical = 0,
    this.horizontal = 25,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: wXD(375, context),
      height: wXD(1, context),
      margin: EdgeInsets.symmetric(
          horizontal: wXD(horizontal, context),
          vertical: wXD(vertical, context)),
      color: Color(0xff707070).withOpacity(.26),
    );
  }
}
