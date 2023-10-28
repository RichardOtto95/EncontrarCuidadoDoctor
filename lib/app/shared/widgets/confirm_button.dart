import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class ConfirmButton extends StatelessWidget {
  const ConfirmButton({Key key, this.onTap, this.enabled = true})
      : super(key: key);
  final Function onTap;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: enabled ? onTap : () {},
        child: Container(
          height: wXD(57, context),
          width: wXD(57, context),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(90),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  enabled ? Color(0xff41C3B3) : Color(0xffb8b8b8),
                  enabled ? Color(0xff21BCCE) : Color(0xffb8b8b8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  offset: Offset(0, 3),
                  color: Color(0x30000000),
                )
              ]),
          child: Icon(
            Icons.check,
            color: Color(0xfffafafa),
            size: wXD(37, context),
          ),
        ),
      ),
    );
  }
}
