import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  double wXD(double size, BuildContext context) {
    double finalSize = MediaQuery.of(context).size.width * size / 375;
    return finalSize;
  }

  final String title;
  final TextStyle style;
  final double left;
  final double top;
  final double right;
  final double bottom;

  const TitleWidget({
    Key key,
    this.title,
    this.style,
    this.left = 21,
    this.top = 10,
    this.right = 0,
    this.bottom = 7,
  }) : super(key: key);

  TextStyle getStyle(BuildContext context) {
    TextStyle _style;
    if (style == null) {
      _style = TextStyle(color: Color(0xff4C4C4C), fontSize: wXD(19, context));
    } else {
      _style = style;
    }
    return _style;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: wXD(20, context), top: wXD(20, context)),
      child: Text(
        '$title',
        style: getStyle(context),
      ),
    );
  }
}
