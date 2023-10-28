import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/consultations/consultations_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/signature_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/widgets/signature_tile.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/dialog_notification.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/separator.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'widgets/card_payment.dart';

class SignaturePage extends StatefulWidget {
  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final MainStore mainStore = Modular.get();
  final SignatureStore store = Modular.get();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.getDate();
    });
    super.initState();
  }

  @override
  void dispose() {
    //  mainStore.getQueries();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasCard = false;
    return WillPopScope(
      onWillPop: () async {
        print('onTap');
        bool heCanBack = false;

        heCanBack = await store.removeType();

        mainStore.signaturePage = false;
        if (heCanBack) {
          return true;
        } else {
          return false;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EncontrarCuidadoAppBar(
                      title: 'Assinatura',
                      onTap: () async {
                        print('onTap');
                        bool heCanBack = false;

                        heCanBack = await store.removeType();

                        mainStore.signaturePage = false;
                        if (heCanBack) {
                          Modular.to.pop();
                        }
                      }),
                  TitleWidget(title: 'Meus cartões', bottom: 0),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(store.authStore.user.uid)
                          .collection('cards')
                          .where('status', isEqualTo: 'ACTIVE')
                          .orderBy('created_at', descending: false)
                          .snapshots(),
                      builder: (context, snapshotCards) {
                        if (snapshotCards.hasData) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            hasCard = snapshotCards.data.docs.isNotEmpty;

                            store.getCards(snapshotCards.data);
                          });
                        }

                        return Container(
                            margin: EdgeInsets.only(bottom: wXD(2, context)),
                            decoration: BoxDecoration(
                              color: Color(0xfffafafa),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0x29000000),
                                  offset: Offset(0, 3),
                                  blurRadius: 3,
                                ),
                              ],
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(22),
                              ),
                            ),
                            width: maxWidth(context),
                            height: wXD(250, context),
                            child: Center(
                              child: Column(
                                children: [
                                  Observer(builder: (context) {
                                    if (store.cardsList == null) {
                                      return Expanded(
                                          child: Row(
                                        children: [
                                          Spacer(),
                                          CircularProgressIndicator(),
                                          Spacer(),
                                        ],
                                      ));
                                    }

                                    if (store.cardsList.isEmpty) {
                                      return Container(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: wXD(53, context),
                                              bottom: wXD(44, context)),
                                          child: Image.asset(
                                              'assets/img/Imagemsemcartão.jpeg'),
                                        ),
                                      );
                                    }

                                    return Expanded(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: wXD(10, context)),
                                        child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                              store.cardsList.length,
                                              (i) {
                                                DocumentSnapshot docCard =
                                                    store.cardsList[i];

                                                return CardPayment(
                                                    docCard: docCard,
                                                    finalNumber:
                                                        docCard['final_number'],
                                                    colors: docCard['colors']);
                                              },
                                            )),
                                      ),
                                    );
                                  }),
                                  InkWell(
                                    onTap: () {
                                      print(
                                          'xxxxxxxxxxxxxx onTap $hasCard xxxxxxxxxxx');
                                      Modular.to.pushNamed(
                                          '/signature/add-card',
                                          arguments: hasCard);
                                    },
                                    child: Container(
                                      width: wXD(182, context),
                                      height: wXD(33, context),
                                      margin: EdgeInsets.only(
                                          bottom: wXD(22, context)),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Adicionar cartão',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 6,
                                            color: Color(0x50000000),
                                          )
                                        ],
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(23)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Color(0xff41C3B3),
                                            Color(0xff21BCCE),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                      }),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('doctors')
                        .doc(store.mainStore.userSnap.id)
                        .snapshots(),
                    builder: (context, snapshotDoctor) {
                      if (snapshotDoctor.hasData) {
                        DocumentSnapshot ds = snapshotDoctor.data;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          store.renew = ds['subscription_status'] ==
                                  'PENDING_CANCELLATION' ||
                              ds['subscription_status'] == 'FREE_DAYS_CANCELED';

                          store.haveSubscribe = ds['premium'];
                        });

                        return Observer(
                          builder: (context) {
                            if (store.cardsList == null ||
                                store.cardsList.isEmpty &&
                                    !store.haveSubscribe) {
                              return InkWell(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () {},
                                child: Center(
                                    child: Container(
                                  margin:
                                      EdgeInsets.only(top: wXD(40, context)),
                                  width: wXD(280, context),
                                  child: Text(
                                    'Adicionar um cartão antes de prosseguir com a assinatura!',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xff707070).withOpacity(.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                              );
                            } else {
                              if (!store.haveSubscribe) {
                                return Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: wXD(22, context),
                                                top: wXD(15, context),
                                                bottom: wXD(2, context)),
                                            child: Text('Plano Mensal',
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: Color(0xff4C4C4C),
                                                    fontSize:
                                                        wXD(19, context))),
                                          ),
                                          Separator(
                                              vertical: 10, horizontal: 20),
                                          SignatureTile(
                                            onTap: () {
                                              store.signing = true;
                                            },
                                          ),
                                        ]),
                                  ),
                                );
                              } else {
                                return Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.all(wXD(20, context)),
                                          child: Text(
                                            'Assinatura e cobrança',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Color(0xff000000),
                                              fontWeight: FontWeight.w600,
                                              fontSize: 19,
                                            ),
                                          ),
                                        ),
                                        Observer(builder: (context) {
                                          return SignatureInfoTile(
                                            renew: store.renew,
                                            date: store.futureInvoice,
                                            ontap: () {
                                              if (store.renew) {
                                                store.renewDialog = !false;
                                              } else {
                                                store.cancelDialog = !false;
                                              }
                                            },
                                          );
                                        })
                                      ],
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                        );
                      } else {
                        return LinearProgressIndicator();
                      }
                    },
                  ),
                ],
              ),
              Observer(builder: (context) {
                return SignatureObservation(
                  visible: store.signing,
                  onCancel: () {
                    store.signing = false;
                  },
                  onConfirm: () async {
                    String errorCode = await store.signat();

                    store.signing = false;

                    print('zzzzzzzzzz onConfirm $errorCode');

                    if (errorCode == null) {
                      store.getDate();

                      showDialog(
                        useRootNavigator: true,
                        barrierColor: Colors.transparent,
                        useSafeArea: true,
                        context: context,
                        builder: (context) => DialogNotification(
                          onClose: () {
                            Modular.to.pop();
                          },
                          text: 'Assinatura contratada',
                          bottom: 42,
                        ),
                      );
                    } else {
                      flutterToast(
                          'Não foi possível contratar o plano EncontrarCuidado.');
                    }
                  },
                );
              }),
              Observer(builder: (context) {
                return CancelDialog(
                  visible: store.cancelDialog,
                  onConfirm: () async {
                    await store.cancelSignature();

                    store.cancelDialog = false;

                    store.getDate();

                    showDialog(
                      barrierColor: Colors.transparent,
                      useSafeArea: true,
                      context: context,
                      builder: (context) => DialogNotification(
                        onClose: () {
                          Modular.to.pop();
                        },
                        text: 'Assinatura cancelada',
                        bottom: 42,
                      ),
                    );
                  },
                  onCancel: () {
                    store.cancelDialog = false;
                  },
                );
              }),
              Observer(
                builder: (context) {
                  return RenewDialog(
                    visible: store.renewDialog,
                    onConfirm: () async {
                      String errorCode = await store.signat();

                      store.renewDialog = false;

                      if (errorCode == null) {
                        store.getDate();

                        showDialog(
                          barrierColor: Colors.transparent,
                          useSafeArea: true,
                          context: context,
                          builder: (context) => DialogNotification(
                            onClose: () {
                              Modular.to.pop();
                            },
                            text: 'Assinatura renovada',
                            bottom: 42,
                          ),
                        );
                      } else {
                        flutterToast(
                            'Não foi possível renovar o plano EncontrarCuidado.');
                      }
                      print('zzzzzzzzzz onConfirm $errorCode');
                    },
                    onCancel: () {
                      store.renewDialog = false;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CancelDialog extends StatelessWidget {
  final bool visible;
  final Function onConfirm;
  final Function onCancel;

  const CancelDialog({
    Key key,
    this.visible,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return Visibility(
      visible: visible,
      child: AnimatedContainer(
        height: maxHeight(context),
        width: maxWidth(context),
        color: !visible ? Colors.transparent : Color(0x50000000),
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: wXD(5, context)),
            height: wXD(153, context),
            width: wXD(324, context),
            decoration: BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.all(Radius.circular(33))),
            child: Column(
              children: [
                Container(
                  width: wXD(240, context),
                  margin: EdgeInsets.only(top: wXD(15, context)),
                  child: Text(
                    '''Tem certeza que deseja cancelar a assinatura?''',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xfa707070),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                StatefulBuilder(builder: (context, stateSet) {
                  return loadCircular
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Spacer(),
                            CircularProgressIndicator(),
                            // Spacer(),
                          ],
                        )
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
                                      fontSize: wXD(16, context)),
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
                                      fontSize: wXD(16, context)),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        );
                }),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignatureObservation extends StatelessWidget {
  final bool visible;
  final Function onConfirm;
  final Function onCancel;

  const SignatureObservation(
      {Key key, this.visible, this.onConfirm, this.onCancel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return Visibility(
      visible: visible,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onCancel,
        child: AnimatedContainer(
          height: maxHeight(context),
          width: maxWidth(context),
          color: !visible ? Colors.transparent : Color(0x50000000),
          duration: Duration(milliseconds: 300),
          curve: Curves.decelerate,
          alignment: Alignment.center,
          child: Container(
            height: wXD(310, context),
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
                    'Observação',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff484D54),
                    ),
                  ),
                ),
                Container(
                  width: wXD(290, context),
                  margin: EdgeInsets.only(top: wXD(15, context)),
                  child: Text(
                    'Ao realizar esta assinatura, o valor será descontado automaticamente do cartão principal. Ao alterar o cartão principal, automaticamente a assinatura será transferida para o novo cartão principal.',
                    style: TextStyle(
                      fontSize: wXD(16, context),
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
                    'Tem certeza que deseja prosseguir com esta assinatura?',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xff484D54),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                StatefulBuilder(
                  builder: (context, stateSet) {
                    return loadCircular
                        ? Row(
                            children: [
                              Spacer(),
                              CircularProgressIndicator(),
                              Spacer(),
                            ],
                          )
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
                                        fontSize: wXD(16, context)),
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
                                        fontSize: wXD(16, context)),
                                  ),
                                ),
                              ),
                              Spacer(),
                            ],
                          );
                  },
                ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignatureInfoTile extends StatelessWidget {
  final String date;
  final Function ontap;
  final bool renew;

  const SignatureInfoTile({
    Key key,
    this.date,
    this.ontap,
    this.renew,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: wXD(25, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                  stream:
                      FirebaseFirestore.instance.collection('info').snapshots(),
                  builder: (context, snapshotPrice) {
                    String price;
                    if (snapshotPrice.hasData) {
                      DocumentSnapshot ds = snapshotPrice.data.docs.first;

                      price = formatedCurrency(ds['current_monthly_price']);
                    }
                    return Container(
                      width: wXD(300, context),
                      padding: EdgeInsets.symmetric(vertical: wXD(8, context)),
                      child: Text(
                        price == null
                            ? 'Valor mensal'
                            : 'Valor mensal: R\$ $price',
                        style: TextStyle(
                          color: Color(0xff484D54),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }),
              Container(
                width: wXD(322, context),
                padding: EdgeInsets.symmetric(vertical: wXD(8, context)),
                child: date == null
                    ? Container()
                    : Text(
                        date,
                        style: TextStyle(
                          color: Color(0xff484D54),
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                      ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: wXD(8, context)),
                    child: Text(
                      'Forma de pagamento: ',
                      style: TextStyle(
                        color: Color(0xff484D54),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: wXD(8, context)),
                    child: Text(
                      'Cartão principal',
                      style: TextStyle(
                        color: Color(0xff484D54),
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Center(
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: ontap,
            child: Container(
              margin: EdgeInsets.only(
                top: wXD(20, context),
                bottom: wXD(30, context),
              ),
              height: wXD(47, context),
              width: wXD(240, context),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                  border: Border.all(
                    color: Color(0xff707070).withOpacity(.40),
                  ),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 3),
                      blurRadius: 3,
                      color: Color(0x30000000),
                    )
                  ],
                  color: Color(0xfffafafa)),
              alignment: Alignment.center,
              child: Text(
                renew ? 'Renovar assinatura' : 'Cancelar assinatura',
                style: TextStyle(
                  color: renew ? Color(0xff2185D0) : Color(0xffDB2828),
                  fontWeight: FontWeight.w500,
                  fontSize: wXD(18, context),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class RenewDialog extends StatelessWidget {
  final bool visible;
  final Function onConfirm;
  final Function onCancel;

  const RenewDialog({
    Key key,
    this.visible,
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool loadCircular = false;
    return Visibility(
      visible: visible,
      child: AnimatedContainer(
        height: maxHeight(context),
        width: maxWidth(context),
        color: !visible ? Colors.transparent : Color(0x50000000),
        duration: Duration(milliseconds: 300),
        curve: Curves.decelerate,
        child: Center(
          child: Container(
            padding: EdgeInsets.only(top: wXD(5, context)),
            height: wXD(153, context),
            width: wXD(324, context),
            decoration: BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.all(Radius.circular(33))),
            child: Column(
              children: [
                Container(
                  width: wXD(240, context),
                  margin: EdgeInsets.only(top: wXD(15, context)),
                  child: Text(
                    '''Tem certeza que deseja renovar a assinatura?''',
                    style: TextStyle(
                      fontSize: wXD(15, context),
                      fontWeight: FontWeight.w600,
                      color: Color(0xfa707070),
                    ),
                  ),
                ),
                Spacer(
                  flex: 1,
                ),
                StatefulBuilder(builder: (context, stateSet) {
                  return loadCircular
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Spacer(),
                            CircularProgressIndicator(),
                            // Spacer(),
                          ],
                        )
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
                                      fontSize: wXD(16, context)),
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
                                      fontSize: wXD(16, context)),
                                ),
                              ),
                            ),
                            Spacer(),
                          ],
                        );
                }),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
