import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/confirm_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ChooseType extends StatefulWidget {
  const ChooseType({Key key}) : super(key: key);

  @override
  _ChooseTypeState createState() => _ChooseTypeState();
}

class _ChooseTypeState extends State<ChooseType> {
  MainStore mainStore = Modular.get();
  AuthStore authStore = Modular.get();

  String userType;
  bool doctorSelected = false;
  bool patientSelected = false;
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
    if (doctorSelected || patientSelected) {
      return true;
    } else {
      return false;
    }
  }

  confirmType() async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();

    _user.reference.update({'type': userType});

    print('xxxxxxxxxxxxx confirmType $userType xxxxxxxxxxxxxxx');

    if (userType == 'SECRETARY') {
      QuerySnapshot havePermissions =
          await _user.reference.collection('permissions').get();

      print(
          'xxxxxxxxxxxxx confirmType if ${havePermissions.docs.isEmpty} xxxxxxxxxxxxxxx');

      if (havePermissions.docs.isEmpty) {
        List permissions = [
          'PROFILE',
          'FEED',
          'SCHEDULINGS',
          'CARE',
          'MESSAGES',
          'PAYMENTS',
          'SECRETARIES',
          'PREFERENCES',
        ];

        for (int i = 0; i < permissions.length; ++i) {
          print('xxxxxxxxxxxxx for $i ${permissions[i]} xxxxxxxxxxxxxxx');

          _user.reference.collection('permissions').add({
            'label': '${permissions[i]}',
            'value': false,
          });
        }
      }
    }
    authStore.type = userType;
    // authStore.getUserType();
    // Modular.to.pop();
    Modular.to.pushNamed('/main');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {},
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
                          'Bem Vindo!',
                          style: TextStyle(
                            color: Color(0xff41c3b3),
                            fontSize: 27,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                      Text(
                        'Você é um médico(a) ou secretário(a)?',
                        style: TextStyle(
                          color: Color(0xff444444),
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(flex: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TypeWidget(
                            icon: Icons.local_hospital_outlined,
                            selected: doctorSelected,
                            type: 'Médico (a)',
                            onTap: () {
                              userType = 'DOCTOR';
                              setState(() {
                                doctorSelected = !doctorSelected;
                                if (patientSelected && doctorSelected) {
                                  patientSelected = false;
                                }
                              });
                            },
                          ),
                          TypeWidget(
                            icon: Icons.person_outline,
                            selected: patientSelected,
                            type: 'Secretário (a)',
                            onTap: () {
                              userType = 'SECRETARY';
                              setState(() {
                                patientSelected = !patientSelected;
                                if (doctorSelected && patientSelected) {
                                  doctorSelected = false;
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
                  type: doctorSelected ? 'médico(a)' : 'secretário(a)',
                  onCancel: () {
                    setState(() {
                      observation = false;
                    });
                  },
                  onConfirm: () {
                    confirmType();

                    // setState(() {
                    //   observation = false;
                    // });
                  },
                )
              ],
            ),
          ),
        ));
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

class ChooseObservation extends StatelessWidget {
  final Function onCancel, onConfirm;
  final bool visible;
  final String type;
  const ChooseObservation({
    Key key,
    this.onCancel,
    this.onConfirm,
    this.visible = false,
    this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;

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
                StatefulBuilder(builder: (context, stateSet) {
                  return Row(
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
                  );
                }),
                Container(
                  width: wXD(279, context),
                  child: Text(
                    ' Caso prossiga com a opção incorreta, será necessário excluir sua conta em Perfil > Excluir perfil para corrigir seu cadastro.',
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
                    'Tem certeza de que é mesmo um(a) $type?',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff484D54),
                    ),
                  ),
                ),
                StatefulBuilder(builder: (context, stateSet) {
                  return loadCircular
                      ? CircularProgressIndicator()
                      : Row(
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
                                    border:
                                        Border.all(color: Color(0x80707070)),
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
                                stateSet(() {
                                  loadCircular = true;
                                });
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
                                    border:
                                        Border.all(color: Color(0x80707070)),
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
