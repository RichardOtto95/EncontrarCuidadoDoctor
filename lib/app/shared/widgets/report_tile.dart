import 'package:flutter/material.dart';

class ReportTile extends StatelessWidget {
  final String text;
  final double top;
  final double bottom;
  final double horizontal;
  final double fontSize;
  final FontWeight fontWeight;
  final Color iconColor;
  final Function onTap;

  const ReportTile({
    Key key,
    this.text,
    this.top = 18,
    this.bottom = 13,
    this.horizontal = 28,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.iconColor = const Color(0x80707070),
    this.onTap,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          top: wXD(top, context),
          bottom: wXD(bottom, context),
        ),
        margin: EdgeInsets.symmetric(
          horizontal: wXD(horizontal, context),
        ),
        child: Row(
          children: [
            Text(
              '$text',
              style: TextStyle(
                fontSize: wXD(fontSize, context),
                color: Color(0xff707070),
                fontWeight: fontWeight,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_outlined,
              size: wXD(15, context),
              color: iconColor,
            ),
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0x40707070),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
