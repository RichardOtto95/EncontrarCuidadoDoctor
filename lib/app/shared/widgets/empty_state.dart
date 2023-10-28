import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:flutter/material.dart';

import '../utilities.dart';

class EmptyStateList extends StatelessWidget {
  final String image;
  final String title;
  final String description;
  final double height;
  final double width;
  final double top;

  const EmptyStateList({
    Key key,
    this.image,
    this.title = '',
    this.description = '',
    this.height = 250,
    this.width = 250,
    this.top = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
      child: Column(
        children: [
          SizedBox(
            height: wXD(top, context),
            width: MediaQuery.of(context).size.width,
          ),
          Image.asset(
            image,
            fit: BoxFit.fill,
            height: wXD(height, context),
            width: wXD(width, context),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: wXD(7, context)),
            child: Text(
              title,
              style: TextStyle(
                color: ColorTheme.textColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: wXD(15, context)),
              alignment: Alignment.center,
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorTheme.textGrey,
                  fontSize: 20,
                ),
              )),
        ],
      ),
    );
  }
}
