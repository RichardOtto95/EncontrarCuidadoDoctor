import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../signature_store.dart';

class EmailDialog extends StatelessWidget {
  final Function onCancel;
  final String title;

  EmailDialog({
    Key key,
    this.onCancel,
    this.title,
  });

  final SignatureStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onCancel,
        child: AnimatedContainer(
          height: maxHeight(context),
          width: maxWidth(context),
          color: Color(0x50000000),
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          alignment: Alignment.center,
          child: Container(
            height: wXD(store.hasValidEmail ? 250 : 300, context),
            width: wXD(324, context),
            decoration: BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.all(Radius.circular(28))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: wXD(17, context)),
                  alignment: Alignment.center,
                  child: Text(
                    'Atenção',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff484D54),
                    ),
                  ),
                ),
                Container(
                  width: wXD(290, context),
                  margin: EdgeInsets.only(top: wXD(15, context)),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color(0xff484D54),
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
                Container(
                  width: wXD(253, context),
                  margin: EdgeInsets.only(top: wXD(15, context)),
                  child: Text(
                    store.hasValidEmail
                        ? 'Você ainda não possui um e-mail válido, deseja atualizá-lo no perfil ou reenviar o link mágico?'
                        : 'Antes de criar um cartão você precisará adicionar um email válido ao seu Perfil. Ao concluir, um link mágico de verificação será enviado para sua caixa de entrada. Quer ser redirecionado para a tela do Perfil para iniciar este processo?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff484D54),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Observer(
                  builder: (context) {
                    return store.loadCircularEmailDialog
                        ? Row(
                            children: [
                              Spacer(),
                              CircularProgressIndicator(),
                              Spacer()
                            ],
                          )
                        : Row(
                            children: [
                              Spacer(),
                              InkWell(
                                onTap: () async {
                                  print(
                                      'zzzzzzzzzzz onTap ${store.hasValidEmail}');
                                  if (store.hasValidEmail) {
                                    store.loadCircularEmailDialog = true;
                                    await store.pushProfile();
                                    store.loadCircularEmailDialog = false;
                                  }
                                  // if (store.emailOverlay != null &&
                                  //     store.emailOverlay.mounted) {
                                  //   store.emailOverlay.remove();
                                  // }
                                },
                                child: Container(
                                  height: wXD(47, context),
                                  width: wXD(98, context),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 3,
                                            color: Color(0x28000000))
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(17)),
                                      border:
                                          Border.all(color: Color(0x80707070)),
                                      color: Color(0xfffafafa)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    store.hasValidEmail ? 'Atualizar' : 'Não',
                                    style: TextStyle(
                                      color: Color(0xff2185D0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {
                                  print(
                                      'zzzzzzzzzzz onTap ${store.hasValidEmail}');
                                  store.loadCircularEmailDialog = true;
                                  if (store.hasValidEmail) {
                                    store.validateEmail();
                                  } else {
                                    store.pushProfile();
                                  }
                                },
                                child: Container(
                                  height: wXD(47, context),
                                  width: wXD(98, context),
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(0, 3),
                                            blurRadius: 3,
                                            color: Color(0x28000000))
                                      ],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(17)),
                                      border:
                                          Border.all(color: Color(0x80707070)),
                                      color: Color(0xfffafafa)),
                                  alignment: Alignment.center,
                                  child: Text(
                                    store.hasValidEmail ? 'Reenviar' : 'Sim',
                                    style: TextStyle(
                                      color: Color(0xff2185D0),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          );
                  },
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
