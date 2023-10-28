import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'carrousel.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController(initialPage: 0);
  int page = 0;
  @override
  void initState() {
    pageController.addListener(() {
      print("pageController: ${pageController.page}");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: hXD(500, context),
                    child: PageView(
                      allowImplicitScrolling: true,
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      onPageChanged: (inte) => setState(() {
                        print("inte: $inte");
                        page = inte;
                      }),
                      children: [
                        BoardView1(),
                        BoardView2(),
                        BoardView3(),
                        BoardView4(),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Modular.to.pushNamed('/main'),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: hXD(15, context),
                        right: hXD(10, context),
                        bottom: hXD(15, context),
                      ),
                      child: Text(
                        page == 3 ? '' : 'Pular',
                        style: TextStyle(
                          color: Color(0xff707070),
                          fontSize: maxWidth(context) * .05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(flex: 2),
              Carrousel(length: 4, index: page),
              Spacer(flex: 1),
              InkWell(
                onTap: () async {
                  if (page == 3) {
                    await Modular.to.pushNamed("/main");
                  } else {
                    await pageController.animateToPage(page + 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                  }
                },
                child: Container(
                  height: maxWidth(context) * .1493,
                  width: maxWidth(context) * .1493,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                    color: Color(0xff41C3B3),
                  ),
                  child: Icon(
                    page == 3 ? Icons.check : Icons.arrow_forward,
                    color: Color(0xfffafafa),
                    size: maxWidth(context) * .1,
                  ),
                ),
              ),
              Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class BoardView1 extends StatelessWidget {
  const BoardView1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: wXD(360, context),
          width: maxWidth(context),
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
              Spacer(),
              Center(
                child: Container(
                  height: wXD(290, context),
                  width: maxWidth(context),
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(600, 300),
                      bottomLeft: Radius.elliptical(600, 300),
                    ),
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: wXD(22, context)),
                        width: maxWidth(context),
                        child: SvgPicture.asset(
                          'assets/svg/doctorread.svg',
                          semanticsLabel: 'Acme Logo',
                          height: wXD(409, context),
                          width: wXD(314, context),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        Spacer(flex: 2),
        Text(
          'Seu assistente de saúde',
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: maxWidth(context) * .05,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(flex: 1),
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: wXD(37, context),
          ),
          child: Text(
            'Agende uma consulta, receba um lembrete e entre em contato com seu especialista.',
            style: TextStyle(
              color: Color(0xff707070),
              fontSize: maxWidth(context) * .038,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Spacer(flex: 1),
        Text(
          'Estamos aqui para ajudar!',
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: maxWidth(context) * .038,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class BoardView2 extends StatelessWidget {
  const BoardView2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: wXD(360, context),
          width: maxWidth(context),
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
              Spacer(),
              Center(
                child: Container(
                  height: wXD(290, context),
                  width: maxWidth(context),
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(600, 300),
                      bottomLeft: Radius.elliptical(600, 300),
                    ),
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: wXD(22, context)),
                        width: maxWidth(context),
                        child: SvgPicture.asset(
                          'assets/svg/notebook.svg',
                          semanticsLabel: 'Acme Logo',
                          height: wXD(409, context),
                          width: wXD(314, context),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
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
          'A Consulta que você precisa',
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: maxWidth(context) * .05,
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
            'Pesquise pelo especialista perfeito para você e agende sua consulta.',
            style: TextStyle(
              color: Color(0xff707070),
              fontSize: maxWidth(context) * .038,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Spacer(
          flex: 1,
        ),
        Text(
          '',
          style: TextStyle(
            color: Color(0xff707070),
            fontSize: maxWidth(context) * .038,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class BoardView3 extends StatelessWidget {
  const BoardView3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: wXD(360, context),
          width: maxWidth(context),
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
              Spacer(),
              Center(
                child: Container(
                  height: wXD(290, context),
                  width: maxWidth(context),
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(600, 300),
                      bottomLeft: Radius.elliptical(600, 300),
                    ),
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: wXD(22, context)),
                        height: wXD(500, context),
                        width: maxWidth(context),
                        child: Transform.rotate(
                          angle: .2,
                          child: SvgPicture.asset(
                            'assets/svg/comunication.svg',
                            semanticsLabel: 'Acme Logo',
                            height: wXD(409, context),
                            width: wXD(314, context),
                            fit: BoxFit.cover,
                            alignment: Alignment.topCenter,
                          ),
                        )),
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
            fontSize: maxWidth(context) * .05,
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
              fontSize: maxWidth(context) * .038,
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
            fontSize: maxWidth(context) * .038,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class BoardView4 extends StatelessWidget {
  const BoardView4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: wXD(360, context),
          width: maxWidth(context),
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
              Spacer(),
              Center(
                child: Container(
                  height: wXD(290, context),
                  width: maxWidth(context),
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.elliptical(600, 300),
                      bottomLeft: Radius.elliptical(600, 300),
                    ),
                    child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: wXD(22, context)),
                        height: wXD(500, context),
                        width: maxWidth(context),
                        child: SvgPicture.asset(
                          'assets/svg/personclock.svg',
                          semanticsLabel: 'Acme Logo',
                          height: wXD(409, context),
                          width: wXD(314, context),
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        )),
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
            fontSize: maxWidth(context) * .05,
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
              fontSize: maxWidth(context) * .038,
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
            fontSize: maxWidth(context) * .038,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
