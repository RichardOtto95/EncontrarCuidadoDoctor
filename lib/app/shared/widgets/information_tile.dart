import 'package:flutter/material.dart';

import '../utilities.dart';

class InformationTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final double left;
  final Color color;

  const InformationTitle({
    Key key,
    this.icon,
    this.title,
    this.color,
    this.left,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getLeft(BuildContext context) {
    double _left;
    if (left == null) {
      _left = wXD(30, context);
    } else {
      _left = left;
    }
    return _left;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: getLeft(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: wXD(22, context),
            color: Color(0xff707070).withOpacity(.8),
          ),
          SizedBox(
            width: wXD(10, context),
          ),
          Container(
            width: wXD(294, context),
            padding: EdgeInsets.only(top: wXD(2, context)),
            child: Text(
              '$title',
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w500,
                fontSize: wXD(15, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
