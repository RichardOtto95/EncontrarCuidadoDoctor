import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Function onTap;
  final double width;
  final double height;
  final String title;
  final Widget widget;
  final TextStyle textStyle;

  const RoundedButton({
    Key key,
    this.onTap,
    this.width,
    this.height,
    this.title,
    this.widget,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            widget == null ? Container() : widget,
            Text(
              '$title',
              style: textStyle,
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(53)),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xff41C3B3),
              Color(0xff21BCCE),
            ],
          ),
        ),
      ),
    );
  }
}
