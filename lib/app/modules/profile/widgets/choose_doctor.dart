import 'package:encontrar_cuidadodoctor/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/confirm_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../profile_store.dart';

class ChooseDoctor extends StatefulWidget {
  final String doctorId;
  const ChooseDoctor({Key key, this.doctorId}) : super(key: key);

  @override
  _ChooseDoctorState createState() => _ChooseDoctorState();
}

class _ChooseDoctorState extends State<ChooseDoctor> {
  final ProfileStore store = Modular.get();

  bool noSelected = false;
  bool yesSelected = false;
  bool accept = false;
  bool observation = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  bool getEnabled() {
    if (noSelected || yesSelected) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                color: Color(0xfffafafa),
                height: maxHeight(context),
                width: maxWidth(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: maxWidth(context),
                      padding: EdgeInsets.only(
                          left: wXD(20, context), top: wXD(14, context)),
                      alignment: Alignment.centerLeft,
                      child: Image.asset(
                        'assets/img/logo-icone.png',
                        height: wXD(47, context),
                      ),
                    ),
                    Spacer(flex: 1),
                    Container(
                      width: maxWidth(context),
                      padding: EdgeInsets.only(left: wXD(17, context)),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Convite recebido!',
                        style: TextStyle(
                          color: Color(0xff41c3b3),
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Container(
                      width: MediaQuery.of(context).size.width * .9,
                      child: Text(
                        'Dr(a). ${store.doctorName} convidou você para fazer parte da equipe dele(a), você aceita?',
                        style: TextStyle(
                          color: Color(0xff444444),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TypeWidget(
                          icon: Icons.no_accounts,
                          selected: noSelected,
                          type: 'Não',
                          onTap: () {
                            setState(() {
                              accept = false;

                              noSelected = !noSelected;
                              if (yesSelected && noSelected) {
                                yesSelected = false;
                              }
                            });
                          },
                        ),
                        TypeWidget(
                          icon: Icons.account_circle_sharp,
                          selected: yesSelected,
                          type: 'Sim',
                          onTap: () {
                            setState(() {
                              accept = true;

                              yesSelected = !yesSelected;
                              if (noSelected && yesSelected) {
                                noSelected = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Spacer(flex: 4),
                    ConfirmButton(
                        enabled: getEnabled(),
                        onTap: () {
                          setState(() {
                            observation = true;
                          });
                        }),
                    Spacer(flex: 1),
                  ],
                ),
              ),
              ChooseObservation(
                visible: observation,
                onCancel: () {
                  setState(() {
                    observation = false;
                  });
                },
                onConfirm: () async {
                  setState(() {
                    loadCircular = true;
                  });
                  await store.confirmDoctor(
                      accept: accept, doctorId: widget.doctorId);
                  await mainStore.getInfo();
                  loadCircular = false;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TypeWidget extends StatelessWidget {
  final bool selected;
  final String type;
  final IconData icon;
  final Function onTap;

  const TypeWidget({
    Key key,
    this.selected = false,
    this.type = '',
    this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: onTap,
          child: Container(
            height: wXD(115, context),
            width: wXD(115, context),
            alignment: Alignment.center,
            margin: EdgeInsets.only(bottom: wXD(6, context)),
            decoration: BoxDecoration(
              color: Color(0xfffafafa),
              borderRadius: BorderRadius.circular(90),
              border: Border.all(
                color: selected
                    ? Color(0xff41c3b3)
                    : Color(0xff707070).withOpacity(.3),
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 3,
                  offset: Offset(0, 0),
                  color: Color(0x30000000),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: wXD(70, context),
              color: Color(0xff41c3b3),
            ),
          ),
        ),
        Text(
          type,
          style: TextStyle(
            color: Color(0xff41c3b3),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

bool loadCircular = false;

class ChooseObservation extends StatelessWidget {
  final Function onCancel, onConfirm;
  final bool visible;
  const ChooseObservation({
    Key key,
    this.onCancel,
    this.onConfirm,
    this.visible = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onCancel,
        child: Container(
          height: maxHeight(context),
          width: maxWidth(context),
          color: Color(0x30000000),
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
                    'Caso prossiga com a opção incorreta, será necessário remover ou adicionar a sua conta, através do perfil do médico "Perfil do Médico > Meus Secretários", para corrigir seu cadastro.',
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
                    'Tem certeza disso?',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff484D54),
                    ),
                  ),
                ),
                loadCircular
                    ? CircularProgressIndicator()
                    :
                    // StatefulBuilder(builder: (context, setState) {
                    //     return
                    Row(
                        children: [
                          Spacer(),
                          InkWell(
                            onTap: onCancel,
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
                                  border: Border.all(color: Color(0x80707070)),
                                  color: Color(0xfffafafa)),
                              alignment: Alignment.center,
                              child: Text(
                                'Não',
                                style: TextStyle(
                                    color: Color(0xff2185D0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              onConfirm();
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
                                  border: Border.all(color: Color(0x80707070)),
                                  color: Color(0xfffafafa)),
                              alignment: Alignment.center,
                              child: Text(
                                'Sim',
                                style: TextStyle(
                                    color: Color(0xff2185D0),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                // }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
