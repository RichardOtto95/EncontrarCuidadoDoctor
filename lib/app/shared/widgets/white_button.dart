import 'package:flutter/material.dart';

import '../utilities.dart';

class WhiteButton extends StatelessWidget {
  final bool borderColorBlue;
  final Function onTap;
  final double width;
  final double height;
  final String text;
  final Color color;
  final double top;
  final double bottom;
  final bool circularIndicator;
  const WhiteButton({
    Key key,
    this.onTap,
    this.width = 240,
    this.height = 47,
    this.text = 'Remover cartão',
    this.color = const Color(0xffDB2828),
    this.top = 5,
    this.bottom = 35,
    this.circularIndicator = false,
    this.borderColorBlue = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: circularIndicator ? () {} : onTap,
        child: Container(
          margin: EdgeInsets.only(
              top: wXD(top, context), bottom: wXD(bottom, context)),
          decoration: BoxDecoration(
            color: Color(0xfffafafa),
            borderRadius: BorderRadius.all(Radius.circular(17)),
            // border: Border.all(color: Color(0x50707070)),
            border: Border.all(
              // width: borderColorBlue ? 2 : 1,
              width: 1,
              color: borderColorBlue ? Color(0xff41c3b3) : Color(0x50707070),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x25000000),
                offset: Offset(0, 4),
                blurRadius: 5,
              )
            ],
          ),
          height: wXD(height, context),
          width: wXD(width, context),
          alignment: Alignment.center,
          child: circularIndicator
              ? Container(
                  height: wXD(30, context),
                  width: wXD(30, context),
                  child: CircularProgressIndicator(),
                )
              : Text(
                  '$text',
                  style: TextStyle(
                    color: color,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
      ),
    );
  }
}
