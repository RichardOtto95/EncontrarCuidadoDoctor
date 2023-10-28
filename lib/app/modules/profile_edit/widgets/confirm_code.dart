import 'package:encontrar_cuidadodoctor/app/modules/consultations/consultations_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../profileEdit_store.dart';

class ConfirmCode extends StatelessWidget {
  final void Function() cancel;
  final void Function() resend;
  final void Function() confirm;

  ConfirmCode({
    this.cancel,
    this.resend,
    this.confirm,
  });

  final ProfileEditStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          store.confirmCodeOverlay.remove();
        },
        child: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          color: ColorTheme.totalBlack.withOpacity(.5),
          padding: EdgeInsets.symmetric(
              vertical: hXD(165, context), horizontal: wXD(25, context)),
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.all(Radius.circular(28))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: wXD(20, context),
                    ),
                    SizedBox(width: wXD(10, context)),
                    Center(
                      child: Text(
                        'Observação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff484D54),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: wXD(279, context),
                  child: Text(
                    'Por questões de segurança, ao atualizar o e-mail, precisamos de uma autenticação recente. Por isso será enviado outro código via sms para o seu número.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff484D54),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  width: wXD(279, context),
                  child: Text(
                    'Digite o código enviado.',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff484D54),
                    ),
                  ),
                ),
                Container(
                  width: wXD(279, context),
                  child: PinCodeTextField(
                    keyboardType: TextInputType.number,
                    length: 6,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        fieldHeight: 50,
                        fieldWidth: 40,
                        inactiveColor: Colors.grey[400], //
                        activeColor: Color(0xFF41c3b3),
                        selectedColor: Color(0xff21bcce)),
                    backgroundColor: ColorTheme.white,
                    animationDuration: Duration(milliseconds: 300),
                    onCompleted: (value) async {
                      print('xxxxxxxx onCompleted $value xxxxxxxxxxx');

                      store.loadCircularCode = true;

                      confirm();
                    },
                    onChanged: (value) {
                      store.code = value;
                    },
                    beforeTextPaste: (text) {
                      return true;
                    },
                    appContext: context,
                  ),
                ),
                Observer(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: store.loadCircularCode
                        ? [
                            CircularProgressIndicator(),
                          ]
                        : [
                            Button(
                              text: 'Cancelar',
                              onTap: cancel,
                            ),
                            Button(
                              text: store.timerSeconds == null
                                  ? 'Reenviar'
                                  : store.timerSeconds.toString(),
                              onTap: store.timerSeconds == null
                                  ? resend
                                  : () {
                                      flutterToast(
                                          'Espere ${store.timerSeconds} segundo(s) para enviar outro código.');
                                    },
                            ),
                          ],
                  );
                }),
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
