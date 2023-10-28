import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmAppointment extends StatelessWidget {
  final void Function() onConfirm;
  final void Function() onBack;
  final String text;
  final String svgWay;

  ConfirmAppointment({this.onConfirm, this.onBack, this.text, this.svgWay});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: onBack,
          child: Container(
            height: maxHeight(context),
            width: maxWidth(context),
            color: ColorTheme.totalBlack.withOpacity(.5),
            padding: EdgeInsets.only(top: wXD(112, context)),
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                    margin: EdgeInsets.only(top: wXD(32, context)),
                    width: wXD(324, context),
                    height: wXD(260, context),
                    decoration: BoxDecoration(
                      color: ColorTheme.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    )),
                Positioned(
                  top: 0,
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        svgWay,
                        semanticsLabel: 'Acme Logo',
                        height: wXD(136, context),
                        width: wXD(231, context),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: wXD(20, context), bottom: wXD(17, context)),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Color(0xff676B71),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Button(text: "Não", onTap: onBack),
                          SizedBox(width: wXD(37, context)),
                          Button(text: "Sim", onTap: onConfirm),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Button extends StatelessWidget {
  final String text;
  final void Function() onTap;
  const Button({Key key, this.text = "Sim", this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(47, context),
        width: wXD(98, context),
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 3), blurRadius: 3, color: Color(0x28000000))
            ],
            borderRadius: BorderRadius.all(Radius.circular(17)),
            border: Border.all(color: Color(0x80707070)),
            color: Color(0xfffafafa)),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              color: Color(0xff2185D0),
              fontWeight: FontWeight.bold,
              fontSize: wXD(16, context)),
        ),
      ),
    );
  }
}
