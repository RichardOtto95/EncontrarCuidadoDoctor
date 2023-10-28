// import 'dart:async';
import 'package:flutter/material.dart';
import '../utilities.dart';

class DialogNotification extends StatelessWidget {
  final String text;
  final double bottom;
  final Function onClose;

  const DialogNotification({
    Key key,
    this.text,
    this.bottom = 118,
    this.onClose,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 3), () {
    //   onClose();
    // });
    return Container(
      padding: EdgeInsets.only(bottom: wXD(bottom, context)),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: wXD(47, context),
            width: wXD(311, context),
            padding: EdgeInsets.symmetric(horizontal: wXD(17, context)),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Color(0x40000000),
                    blurRadius: 6,
                    offset: Offset(0, 4)),
              ],
              borderRadius: BorderRadius.all(Radius.circular(7)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xff41c3b3),
                  Color(0xff21bcce),
                ],
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  '$text',
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Color(0xfffafafa),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto'),
                ),
                Spacer(),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onClose,
                    child: Text(
                      'Fechar',
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Color(0xfffafafa),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Roboto'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
