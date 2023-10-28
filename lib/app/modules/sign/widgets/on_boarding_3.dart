import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import 'carrousel.dart';
import 'on_boarding_4.dart';

class OnBoarding3 extends StatelessWidget {
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
                    child: Container(
                      height: wXD(290, context),
                      width: maxWidth,
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.elliptical(600, 300),
                          bottomLeft: Radius.elliptical(600, 300),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: wXD(22, context)),
                          height: wXD(500, context),
                          width: maxWidth,
                          child: SvgPicture.asset(
                            'assets/svg/comunication.svg',
                            semanticsLabel: 'Acme Logo',
                            height: wXD(409, context),
                            width: wXD(314, context),
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
              'Receba respostas em tempo real',
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
                'Converse com seu especialista por chat, como você faz com um membro da família.',
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
              'A saúde em primeiro Lugar!',
              style: TextStyle(
                color: Color(0xff707070),
                fontSize: maxWidth * .038,
                fontWeight: FontWeight.w400,
              ),
            ),
            Spacer(
              flex: 2,
            ),
            Carrousel(
              length: 4,
              index: 2,
            ),
            Spacer(
              flex: 1,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => OnBoarding4()));
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
