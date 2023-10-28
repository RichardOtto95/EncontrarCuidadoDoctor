import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import 'carrousel.dart';

class OnBoarding4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double hXD(double size, BuildContext context) {
      double finalValue = MediaQuery.of(context).size.height * size / 667;
      return finalValue;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: wXD(360, context),
              width: maxWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.elliptical(600, 300),
                  bottomLeft: Radius.elliptical(600, 300),
                ),
                color: Color(0x6741C3B3),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    // onTap: () => Modular.to.pushNamed('/sign/phone'),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: hXD(15, context),
                        right: hXD(10, context),
                        bottom: hXD(15, context),
                      ),
                      child: Text(
                        'Pular',
                        style: TextStyle(
                          color: Colors.transparent,
                          fontSize: maxWidth * .05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Container(
                      height: wXD(300, context),
                      width: maxWidth,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(600, 300),
                          bottomLeft: Radius.elliptical(600, 300),
                        ),
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                              horizontal: wXD(66, context)),
                          child: SvgPicture.asset(
                            'assets/svg/personclock.svg',
                            semanticsLabel: 'Acme Logo',
                            height: wXD(442, context),
                            width: wXD(214, context),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Text(
              'Na comodidade de sua casa',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: maxWidth * .05,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: wXD(37, context),
              ),
              child: Text(
                'E tudo isso sem precisar sair de casa!.',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: maxWidth * .038,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            Text(
              'Vamos começar?',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: maxWidth * .038,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(flex: 2),
            Carrousel(length: 4, index: 3),
            Spacer(flex: 1),
            InkWell(
              onTap: () => Modular.to.pushNamed('/main'),
              child: Container(
                height: maxWidth * .1493,
                width: maxWidth * .1493,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Color(0xff41C3B3),
                ),
                child: Icon(
                  Icons.check,
                  color: Color(0xfffafafa),
                  size: maxWidth * .1,
                ),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}
