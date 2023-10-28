import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class TitleWidgetProfile extends StatelessWidget {
  final String title;

  const TitleWidgetProfile({
    Key key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        wXD(8, context),
        wXD(13, context),
        wXD(0, context),
        wXD(13, context),
      ),
      child: Text(
        '$title',
        style: TextStyle(
            color: Color(0xff41C3B3),
            fontSize: wXD(20, context),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
