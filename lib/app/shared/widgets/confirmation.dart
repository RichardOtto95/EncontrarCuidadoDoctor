import 'package:encontrar_cuidadodoctor/app/modules/finances/finances_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/profile/widgets/card_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utilities.dart';

class Confirmation extends StatefulWidget {
  final String title;
  final String subTitle;
  final Function onBack;
  const Confirmation({
    Key key,
    this.title,
    this.subTitle,
    this.onBack,
  }) : super(key: key);
  @override
  _ConfirmationState createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  final FinancesStore store = Modular.get();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Modular.to.pop();
        Modular.to.pop();

        widget.onBack();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: wXD(10, context),
                  left: wXD(17, context),
                  right: wXD(7, context),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/img/logo-icone.png',
                      height: wXD(47, context),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Modular.to.pop();
                        Modular.to.pop();

                        widget.onBack();
                      },
                      child: Icon(
                        Icons.close,
                        size: wXD(33, context),
                        color: Color(0xff707070),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: wXD(3, context)),
                    child:
                        // CachedNetworkImage(
                        //   imageUrl: widget.avatar,
                        //   height: wXD(53, context),
                        //   width: wXD(53, context),
                        // )
                        CardProfile(
                      size: wXD(53, context),
                      photo: store.avatar,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      height: wXD(36, context),
                      width: wXD(36, context),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.white, width: wXD(3, context)),
                        borderRadius: BorderRadius.circular(90),
                        color: Color(0xff41C3B3),
                      ),
                      child: Icon(
                        Icons.check,
                        color: Color(0xfffafafa),
                        size: wXD(22, context),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                width: wXD(280, context),
                alignment: Alignment.center,
                child: Text(
                  '${widget.title}',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontSize: wXD(20, context),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: wXD(300, context),
                child: Center(
                  child: Text(
                    '${widget.subTitle}',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Spacer(),
              Center(
                  child: Container(
                alignment: Alignment.bottomRight,
                height: wXD(300, context),
                child: SingleChildScrollView(
                  child: SvgPicture.asset(
                    "./assets/svg/personmoney.svg",
                    height: wXD(480, context),
                    width: wXD(345.6, context),
                  ),
                ),
              )
                  //  Image.asset(
                  //     'assets/img/Business, Technology, startup _ account, preferences, user, profile, settings, woman, graph, analysis.png',
                  //     height: maxHeight(context) * .4),
                  ),
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
