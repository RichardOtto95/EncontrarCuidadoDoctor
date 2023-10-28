import 'dart:async';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/modules/signature/widgets/card_fields.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._button.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../signature_store.dart';

class AddCard extends StatefulWidget {
  final bool hasCard;

  const AddCard({Key key, this.hasCard}) : super(key: key);

  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends ModularState<AddCard, SignatureStore> {
  FocusNode focusNodeCardNumber;
  FocusNode focusNodeNameCardHolder;
  FocusNode focusNodeDueDate;
  FocusNode focusNodeSecurityCode;
  FocusNode focusNodeCpf;
  FocusNode focusNodeBillingAddress;
  FocusNode focusNodeBillingDistrict;
  FocusNode focusNodeBillingCity;
  FocusNode focusNodeBillingState;
  FocusNode focusNodeBillingCep;
  ScrollController scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  String setMain = 'Definir como principal';

  @override
  void initState() {
    handleScroll();
    focusNodeCardNumber = FocusNode();
    focusNodeNameCardHolder = FocusNode();
    focusNodeDueDate = FocusNode();
    focusNodeSecurityCode = FocusNode();
    focusNodeCpf = FocusNode();
    focusNodeBillingAddress = FocusNode();
    focusNodeBillingDistrict = FocusNode();
    focusNodeBillingCity = FocusNode();
    focusNodeBillingState = FocusNode();
    focusNodeBillingCep = FocusNode();

    store.focusNodeMap.addAll({
      'card_number': focusNodeCardNumber,
      'name_card_holder': focusNodeNameCardHolder,
      'due_date': focusNodeDueDate,
      'security_code': focusNodeSecurityCode,
      'cpf': focusNodeCpf,
      'billing_address': focusNodeBillingAddress,
      'billing_district': focusNodeBillingDistrict,
      'billing_city': focusNodeBillingCity,
      'billing_state': focusNodeBillingState,
      'billing_cep': focusNodeBillingCep,
    });
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    focusNodeCardNumber.dispose();
    focusNodeNameCardHolder.dispose();
    focusNodeDueDate.dispose();
    focusNodeSecurityCode.dispose();
    focusNodeCpf.dispose();
    focusNodeBillingAddress.dispose();
    focusNodeBillingDistrict.dispose();
    focusNodeBillingCity.dispose();
    focusNodeBillingState.dispose();
    focusNodeBillingCep.dispose();

    if (store.addCardOverlay != null && store.addCardOverlay.mounted) {
      store.addCardOverlay.remove();
    }
    if (store.emailOverlay != null && store.emailOverlay.mounted) {
      store.emailOverlay.remove();
    }
    super.dispose();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        store.input = false;
      } else {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.addCardOverlay != null && store.addCardOverlay.mounted) {
          store.addCardOverlay.remove();
        }
        if (store.emailOverlay != null && store.emailOverlay.mounted) {
          store.emailOverlay.remove();
        }
        return true;
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Listener(
            onPointerDown: (event) {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      EncontrarCuidadoAppBar(
                        title: 'Adicionar cartão',
                        onTap: () {
                          if (store.addCardOverlay != null &&
                              store.addCardOverlay.mounted) {
                            store.addCardOverlay.remove();
                          }
                          if (store.emailOverlay != null &&
                              store.emailOverlay.mounted) {
                            store.emailOverlay.remove();
                          }
                          Modular.to.pop();
                        },
                      ),
                      Observer(builder: (context) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.decelerate,
                          height: store.input ? 0 : wXD(225, context),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    TitleWidget(
                                        title: 'Novo cartão', bottom: 0),
                                    Spacer(),
                                    widget.hasCard
                                        ? StatefulBuilder(
                                            builder: (context, stateSet) {
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () {
                                                stateSet(() {
                                                  if (setMain !=
                                                      'Definir como principal') {
                                                    setMain =
                                                        'Definir como principal';
                                                    store.cardMap['main'] =
                                                        false;
                                                  } else {
                                                    setMain = 'Principal';
                                                    store.cardMap['main'] =
                                                        true;
                                                  }
                                                });
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: wXD(20, context)),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        wXD(6, context)),
                                                height: wXD(21, context),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                  border: Border.all(
                                                    color: Color(0xff2185D0),
                                                    width: wXD(1, context),
                                                  ),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  setMain,
                                                  style: TextStyle(
                                                    fontSize: wXD(10, context),
                                                    fontWeight: FontWeight.w800,
                                                    color: Color(0xfa2185D0),
                                                  ),
                                                ),
                                              ),
                                            );
                                          })
                                        : Container(),
                                  ],
                                ),
                                Container(
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
                                      bottom: Radius.circular(45),
                                    ),
                                  ),
                                  height: wXD(190, context),
                                  child: Center(
                                    child: CardPaymentAddCard(
                                      store: store,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardFields(
                                  store: store,
                                ),
                                SizedBox(height: wXD(15, context)),
                                Observer(builder: (context) {
                                  return EncontrarCuidadoButton(
                                    loadCircular: store.loadCircularButton,
                                    title: 'Salvar',
                                    onTap: () async {
                                      if (!store.loadCircularButton) {
                                        if (_formKey.currentState.validate()) {
                                          await store.saveCard(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Preencha os campos corretamente.",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red[700],
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      }
                                    },
                                  );
                                }),
                                Observer(builder: (context) {
                                  if (store.inputState || store.inputCity) {
                                    Timer(Duration(milliseconds: 400), () {
                                      scrollController.animateTo(
                                          scrollController
                                              .position.maxScrollExtent,
                                          duration: Duration(milliseconds: 800),
                                          curve: Curves.ease);
                                    });
                                  }

                                  return Container();
                                }),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardPaymentAddCard extends StatelessWidget {
  final SignatureStore store;
  const CardPaymentAddCard({
    Key key,
    this.store,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      store.cardMap['colors'] = [store.hexDec, store.hexDec2];

      return InkWell(
        onTap: () {
          store.getColors();
          store.cardMap['colors'] = [store.hexDec, store.hexDec2];
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(wXD(15, context)),
              height: wXD(155, context),
              width: wXD(270, context),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(store.hexDec).withOpacity(1),
                      Color(store.hexDec2).withOpacity(1),
                    ]),
                borderRadius: BorderRadius.all(
                  Radius.circular(18),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x30000000),
                      offset: Offset.zero,
                      blurRadius: 6),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                            right: wXD(20, context),
                            top: wXD(10, context),
                            bottom: wXD(10, context)),
                        child: Image.asset(
                          'assets/img/MasterCard.png',
                          height: 48,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      wXD(15, context),
                      wXD(20, context),
                      0,
                      wXD(10, context),
                    ),
                    child: Text(
                      'XXXX  XXXX  XXXX XXXX',
                      style: TextStyle(
                        color: Color(0xfffafafa),
                        fontSize: wXD(15, context),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      wXD(15, context),
                      wXD(5, context),
                      wXD(15, context),
                      wXD(15, context),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: wXD(14, context),
                          width: wXD(90, context),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xfffafafa)),
                        ),
                        Spacer(),
                        Container(
                          height: wXD(15, context),
                          width: wXD(30, context),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              color: Color(0xfffafafa)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
