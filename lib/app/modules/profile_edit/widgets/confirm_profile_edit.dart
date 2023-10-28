import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ConfirmProfileEdit extends StatelessWidget {
  final void Function() onConfirm;
  final void Function() onBack;
  final String text;

  ConfirmProfileEdit({
    this.onConfirm,
    this.onBack,
    this.text,
  });

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
            padding: EdgeInsets.only(top: wXD(123, context)),
            alignment: Alignment.topCenter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: wXD(324, context),
                  height: wXD(290, context),
                  decoration: BoxDecoration(
                    color: ColorTheme.white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                ),
                Positioned(
                  top: wXD(-32, context),
                  child: Column(
                    children: [
                      Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(90)),
                          child: Container(
                              height: wXD(196, context),
                              width: wXD(196, context),
                              margin: EdgeInsets.symmetric(
                                  horizontal: wXD(22, context)),
                              child: SvgPicture.asset(
                                'assets/svg/editprofile.svg',
                                semanticsLabel: 'Acme Logo',
                                height: wXD(409, context),
                                width: wXD(314, context),
                                fit: BoxFit.cover,
                                alignment: Alignment.topCenter,
                              )),
                        ),
                      ),
                      Container(
                        width: wXD(250, context),
                        padding: EdgeInsets.only(
                            top: wXD(15, context), bottom: wXD(15, context)),
                        alignment: Alignment.center,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Color(0xff676B71),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          onBack();
                        },
                        child: Container(
                          height: wXD(47, context),
                          width: wXD(98, context),
                          // margin: EdgeInsets.only(bottom: 120),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 3),
                                    blurRadius: 3,
                                    color: Color(0x28000000))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(17)),
                              border: Border.all(color: Color(0x80707070)),
                              color: Color(0xfffafafa)),
                          alignment: Alignment.center,
                          child: Text(
                            'OK',
                            style: TextStyle(
                              color: Color(0xff2185D0),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
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
