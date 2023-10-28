import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/settings/settings_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class PreferencesPage extends StatefulWidget {
  final List<num> listInitialValues;

  const PreferencesPage({Key key, this.listInitialValues}) : super(key: key);
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState
    extends ModularState<PreferencesPage, SettingsStore> {
  final MainStore mainStore = Modular.get();
  var controllerPrice;

  @override
  void initState() {
    controllerPrice = new MoneyMaskedTextController(
        decimalSeparator: ',',
        thousandSeparator: '.',
        leftSymbol: 'R\$',
        initialValue: widget.listInitialValues.isNotEmpty
            ? widget.listInitialValues.last.toDouble()
            : 0.0);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    bool hasPermission = false;

    return WillPopScope(
      onWillPop: () async {
        return await store.canBack(context);
      },
      child: Listener(
        onPointerDown: (event) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: StreamBuilder<Object>(
                stream: FirebaseFirestore.instance
                    .collection('doctors')
                    .doc(mainStore.authStore.user != null
                        ? mainStore.authStore.user.uid
                        : '')
                    .snapshots(),
                builder: (context, snapuser) {
                  DocumentSnapshot user;
                  bool notifications = false;

                  if (snapuser.hasData) {
                    user = snapuser.data;
                    notifications = user.get('notification_disabled');
                  }

                  return StreamBuilder<Object>(
                      stream: FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(mainStore.authStore.user != null
                              ? mainStore.authStore.user.uid
                              : '')
                          .collection('permissions')
                          .where('label', isEqualTo: 'PREFERENCES')
                          .snapshots(),
                      builder: (context, snapermissions) {
                        QuerySnapshot permissions;

                        if (mainStore.authStore.type == 'SECRETARY') {
                          if (snapermissions.hasData) {
                            permissions = snapermissions.data;
                            store.allowed = permissions.docs.first.get('value');
                          }
                        }

                        if (mainStore.authStore.type == 'DOCTOR' ||
                            (mainStore.authStore.type == 'SECRETARY' &&
                                mainStore.authStore.viewDoctorId != null &&
                                store.allowed == true)) {
                          hasPermission = true;
                        }

                        return Column(
                          children: [
                            EncontrarCuidadoNavBar(
                              leading: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: wXD(11, context),
                                        right: wXD(11, context)),
                                    child: InkWell(
                                      onTap: () async {
                                        bool canBack =
                                            await store.canBack(context);
                                        if (canBack) {
                                          Modular.to.pop();
                                        }
                                      },
                                      child: Icon(
                                        Icons.arrow_back_ios_outlined,
                                        size: wXD(26, context),
                                        color: Color(0xff707070),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Preferências',
                                    style: TextStyle(
                                      color: Color(0xff707070),
                                      fontSize: wXD(20, context),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: wXD(20, context),
                                vertical: wXD(10, context),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: wXD(20, context),
                                    ),
                                    child: Text(
                                      'Gerenciar notificações',
                                      style: TextStyle(
                                          color: Color(0xff41C3B3),
                                          fontSize: wXD(19, context),
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Silenciar Notificações',
                                        style: TextStyle(
                                            color: Color(0xff707070),
                                            fontSize: wXD(19, context),
                                            fontWeight: FontWeight.w700),
                                      ),
                                      Spacer(),
                                      Switch(
                                        value: notifications,
                                        onChanged: (value) async {
                                          await store.swiftNot(
                                              user, !notifications);
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  mainStore.authStore.type == 'SECRETARY' &&
                                          mainStore.authStore.viewDoctorId ==
                                              null
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: wXD(15, context),
                                              ),
                                              child: Text(
                                                'Prazo válido para retorno',
                                                style: TextStyle(
                                                    color: hasPermission
                                                        ? Color(0xff41C3B3)
                                                        : Color(0x50707070),
                                                    fontSize: wXD(19, context),
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Até     ',
                                                  style: TextStyle(
                                                    color: hasPermission
                                                        ? Color(0xff707070)
                                                        : Color(0x50707070),
                                                    fontSize: wXD(19, context),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Container(
                                                  height: wXD(30, context),
                                                  width: wXD(30, context),
                                                  child: TextFormField(
                                                    readOnly: hasPermission
                                                        ? false
                                                        : true,
                                                    initialValue: widget
                                                                .listInitialValues
                                                                .first !=
                                                            null
                                                        ? widget
                                                            .listInitialValues
                                                            .first
                                                            .toString()
                                                        : null,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration
                                                        .collapsed(
                                                      hintText: '30',
                                                      hintStyle: TextStyle(
                                                          color: hasPermission
                                                              ? Color(
                                                                  0xff707070)
                                                              : Color(
                                                                  0x50707070),
                                                          fontSize:
                                                              wXD(19, context),
                                                          fontWeight:
                                                              FontWeight.w300),
                                                    ),
                                                    onChanged: (value) {
                                                      if (value != '') {
                                                        store.returnPeriod =
                                                            num.parse(value);
                                                      } else {
                                                        store.returnPeriod =
                                                            null;
                                                      }
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  '    dias após consulta',
                                                  style: TextStyle(
                                                      color: hasPermission
                                                          ? Color(0xff707070)
                                                          : Color(0x50707070),
                                                      fontSize:
                                                          wXD(19, context),
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: wXD(15, context),
                                              ),
                                              child: Text(
                                                'Valor da consulta',
                                                style: TextStyle(
                                                    color: hasPermission
                                                        ? Color(0xff41C3B3)
                                                        : Color(0x50707070),
                                                    fontSize: wXD(19, context),
                                                    fontWeight:
                                                        FontWeight.w900),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(
                                                top: wXD(4, context),
                                              ),
                                              height: wXD(30, context),
                                              width: wXD(150, context),
                                              child: TextFormField(
                                                readOnly: hasPermission
                                                    ? false
                                                    : true,
                                                controller: controllerPrice,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    InputDecoration.collapsed(
                                                  hintText: 'Valor',
                                                  hintStyle: TextStyle(
                                                    color: hasPermission
                                                        ? Color(0xff707070)
                                                        : Color(0x50707070),
                                                    fontSize: wXD(19, context),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  if (value != '') {
                                                    print(
                                                        'controllerPrice.numberValue ${controllerPrice.numberValue}');
                                                    store.price =
                                                        controllerPrice
                                                            .numberValue;
                                                  } else {
                                                    store.price = null;
                                                  }
                                                },
                                              ),
                                            ),
                                            StatefulBuilder(
                                                builder: (context, stateSet) {
                                              return Row(
                                                children: [
                                                  Spacer(),
                                                  store.loadCircular == true
                                                      ? CircularProgressIndicator()
                                                      : InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            if (store.price !=
                                                                    null ||
                                                                store.returnPeriod !=
                                                                    null) {
                                                              await store
                                                                  .canSave();
                                                            }
                                                          },
                                                          child: Observer(
                                                              builder:
                                                                  (context) {
                                                            return AnimatedContainer(
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      500),
                                                              margin: EdgeInsets
                                                                  .only(
                                                                top: maxWidth *
                                                                    .025,
                                                                bottom:
                                                                    maxWidth *
                                                                        .07,
                                                              ),
                                                              height: maxWidth *
                                                                  .1493,
                                                              width: maxWidth *
                                                                  .1493,
                                                              decoration:
                                                                  BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              90),
                                                                      gradient:
                                                                          LinearGradient(
                                                                        begin: Alignment
                                                                            .topCenter,
                                                                        end: Alignment
                                                                            .bottomCenter,
                                                                        colors: store.price != null ||
                                                                                store.returnPeriod !=
                                                                                    null
                                                                            ? [
                                                                                Color(0xff41C3B3),
                                                                                Color(0xff21BCCE),
                                                                              ]
                                                                            : [
                                                                                Colors.grey[200],
                                                                                Colors.grey[600]
                                                                              ],
                                                                      ),
                                                                      boxShadow: [
                                                                    BoxShadow(
                                                                      blurRadius:
                                                                          6,
                                                                      offset:
                                                                          Offset(
                                                                              0,
                                                                              3),
                                                                      color: Color(
                                                                          0x30000000),
                                                                    )
                                                                  ]),
                                                              child: Icon(
                                                                Icons.check,
                                                                color: Color(
                                                                    0xfffafafa),
                                                                size: maxWidth *
                                                                    .1,
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                  Spacer(),
                                                ],
                                              );
                                            }),
                                          ],
                                        )
                                ],
                              ),
                            )
                          ],
                        );
                      });
                }),
          ),
        ),
      ),
    );
  }
}
