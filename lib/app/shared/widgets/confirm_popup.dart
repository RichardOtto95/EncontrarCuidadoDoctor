import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class ConfirmPopUp extends StatelessWidget {
  final String text;
  final String textConfirm;
  final String textCancel;
  final Function onConfirm;
  final Function onCancel;
  final bool visible;
  final Color offColor;

  const ConfirmPopUp({
    Key key,
    this.text = '',
    this.onConfirm,
    this.onCancel,
    this.visible = false,
    this.textConfirm = 'Sim',
    this.textCancel = 'Não',
    this.offColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;

    return Visibility(
      visible: visible,
      child: InkWell(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: onCancel,
        child: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          color: Color(0xff000000).withOpacity(.3),
          alignment: Alignment.center,
          child: Container(
            width: wXD(325, context),
            height: wXD(153, context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32)),
              color: Color(0xfffafafa),
            ),
            child: Column(
              children: [
                Spacer(flex: 2),
                Container(
                  width: wXD(273, context),
                  child: Text(
                    '$text',
                    style: TextStyle(
                      color: Color(0xff484D54),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Spacer(flex: 2),
                StatefulBuilder(
                  builder: (context, setState) {
                    return loadCircular
                        ? CircularProgressIndicator()
                        : Row(
                            children: [
                              Spacer(),
                              PopButton(
                                textCancel,
                                onTap: onCancel,
                              ),
                              Spacer(),
                              PopButton(
                                textConfirm,
                                onTap: () {
                                  setState(() {
                                    loadCircular = true;
                                  });
                                  onConfirm();
                                },
                              ),
                              Spacer(),
                            ],
                          );
                  },
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PopButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color offColor;

  const PopButton(
    this.text, {
    Key key,
    this.onTap,
    this.offColor = Colors.blue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        width: wXD(97, context),
        height: wXD(47, context),
        decoration: BoxDecoration(
          color: Color(0xfffafafa),
          border: Border.all(color: Color(0xff707070).withOpacity(.6)),
          borderRadius: BorderRadius.all(Radius.circular(18)),
          boxShadow: [
            BoxShadow(
                blurRadius: 4, offset: Offset(0, 3), color: Color(0x30000000)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          '$text',
          style: TextStyle(
              color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
