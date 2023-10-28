import 'package:flutter/material.dart';
import '../utilities.dart';
import 'encontrar_cuidado._navbar.dart';

class EncontrarCuidadoAppBar extends StatelessWidget {
  final String title;
  final Function onTap;
  final Widget action;

  const EncontrarCuidadoAppBar({
    Key key,
    this.title,
    this.onTap,
    this.action,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    return EncontrarCuidadoNavBar(
      leading: Row(
        children: [
          onTap != null
              ? Padding(
                  padding: EdgeInsets.only(
                      left: wXD(11, context), right: wXD(11, context)),
                  child: InkWell(
                    onTap: onTap,
                    child: Icon(
                      Icons.arrow_back_ios_outlined,
                      size: maxWidth * 26 / 375,
                      color: Color(0xff707070),
                    ),
                  ),
                )
              : Container(
                  width: wXD(40, context),
                ),
          Text(
            '$title',
            style: TextStyle(
                color: Color(0xff707070),
                fontSize: wXD(20, context),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
      action: action,
    );
  }
}
