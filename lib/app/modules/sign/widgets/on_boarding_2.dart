import 'package:encontrar_cuidadodoctor/app/modules/sign/widgets/carrousel.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import 'on_boarding_3.dart';

class OnBoarding2 extends StatelessWidget {
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
                    onTap: () => Modular.to.pushNamed('/main'),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: hXD(15, context),
                        right: hXD(10, context),
                        bottom: hXD(15, context),
                      ),
                      child: Text(
                        'Pular',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: maxWidth * .05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.elliptical(600, 300),
                        bottomLeft: Radius.elliptical(600, 300),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: NeverScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(width: wXD(40, context)),
                                SvgPicture.asset(
                                  'assets/svg/notebook.svg',
                                  semanticsLabel: 'Acme Logo',
                                  height: wXD(231, context),
                                  width: wXD(458, context),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                ),
                              ],
                            ),
                            SizedBox(width: wXD(20, context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(flex: 2),
            Text(
              'A Consulta que você precisa',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: maxWidth * .05,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(flex: 1),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: wXD(37, context),
              ),
              child: Text(
                'Pesquise pelo especialista perfeito para você e agende sua consulta.',
                style: TextStyle(
                  color: Color(0xff707070),
                  fontSize: maxWidth * .038,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Spacer(flex: 1),
            Text(
              '',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: maxWidth * .038,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(flex: 2),
            Carrousel(length: 4, index: 1),
            Spacer(flex: 1),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => OnBoarding3()));
              },
              child: Container(
                height: maxWidth * .1493,
                width: maxWidth * .1493,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: Color(0xff41C3B3),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: Color(0xfffafafa),
                  size: maxWidth * .1,
                ),
              ),
            ),
            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
