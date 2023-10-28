import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SchedulingEmptyState extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const SchedulingEmptyState(
      {Key key, this.image, this.title, this.description, int height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxHeight(context) - wXD(275, context),
      padding: EdgeInsets.symmetric(vertical: wXD(20, context)),
      margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            semanticsLabel: 'Acme Logo',
            height: wXD(120, context),
            width: wXD(200, context),
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: wXD(60, context),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
              alignment: Alignment.center,
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(color: ColorTheme.textGrey, fontSize: 20),
              )),
        ],
      ),
    );
  }
}
