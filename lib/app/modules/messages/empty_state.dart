import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const EmptyState(
      {Key key, this.image, this.title, this.description, int height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double wXD(double size, BuildContext context) {
      double finalSize = MediaQuery.of(context).size.width * size / 375;
      return finalSize;
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
      child: Column(
        children: [
          Image.asset(
            image,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.width * .75,
            width: MediaQuery.of(context).size.width * .75,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .02,
          ),
          Container(
              margin: EdgeInsets.symmetric(horizontal: wXD(20, context)),
              alignment: Alignment.center,
              child: Text(
                description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: ColorTheme.textGrey, fontSize: wXD(20, context)),
              )),
        ],
      ),
    );
  }
}
