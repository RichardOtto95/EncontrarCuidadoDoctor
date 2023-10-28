import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utilities.dart';

class EncontrarCuidadoNavBar extends StatelessWidget {
  final Widget action;
  final Widget leading;

  const EncontrarCuidadoNavBar({
    Key key,
    this.action,
    this.leading,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxWidth(context) * .184,
      decoration: BoxDecoration(
        color: Color(0xfffafafa),
        boxShadow: [
          BoxShadow(
            color: const Color(0x29000000),
            offset: Offset(0, 3),
            blurRadius: 6,
          ),
        ],
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: wXD(7, context)),
            child: leading,
          ),
          Spacer(),
          Container(
            margin: EdgeInsets.only(right: 7),
            width: maxWidth(context) * .15,
            height: maxWidth(context) * .15,
            child: action,
            alignment: Alignment.centerRight,
          ),
        ],
      ),
    );
  }
}

String formatedCurrency(var value) {
  var newValue = new NumberFormat("#,##0.00", "pt_BR");
  return newValue.format(value);
}
