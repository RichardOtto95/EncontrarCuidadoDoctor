import 'package:encontrar_cuidadodoctor/app/core/models/card_model.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/load_circular_overlay.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/title_widget.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/white_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../shared/widgets/encontrar_cuidado._app_bar.dart';
import '../signature_store.dart';
import 'confirm_card.dart';

class CardData extends StatefulWidget {
  final CardModel cardModel;

  const CardData({
    Key key,
    this.cardModel,
  }) : super(key: key);
  @override
  _CardDataState createState() => _CardDataState();
}

class _CardDataState extends State<CardData> {
  final SignatureStore store = Modular.get();
  bool main = false;

  @override
  void initState() {
    main = widget.cardModel.main;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    bool loadCircular = false;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EncontrarCuidadoAppBar(
                  title: 'Dados do cartão',
                  onTap: () => Modular.to.pop(),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TitleWidget(
                      title: 'Dados do cartão',
                      bottom: 0,
                      style: TextStyle(
                        color: Color(0xff41c3b3),
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (await store.isSingleCard()) {
                          setState(() {
                            main = !main;
                          });
                          store.changedMain(widget.cardModel.id, main);
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: wXD(20, context)),
                        padding:
                            EdgeInsets.symmetric(horizontal: wXD(15, context)),
                        height: wXD(21, context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          border: Border.all(
                            color: Color(0xff2185D0),
                            width: wXD(1, context),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          main ? 'Principal' : 'Definir como principal',
                          style: TextStyle(
                            fontSize: wXD(10, context),
                            fontWeight: FontWeight.w800,
                            color: Color(0xfa2185D0),
                          ),
                        ),
                      ),
                    )
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
                      child: CardPaymentData(
                    colors: widget.cardModel.colors,
                    finalNumber: widget.cardModel.finalNumber,
                  )),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: wXD(25, context),
                          ),
                          CardTileData(
                            title: 'Número do cartão',
                            initialValue:
                                'XXXX XXXX XXXX ${widget.cardModel.finalNumber}',
                          ),
                          TitleWidget(
                            top: 20,
                            bottom: 10,
                            title: 'Endereço de cobrança',
                            style: TextStyle(
                              color: Color(0xff41c3b3),
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          CardTileData(
                            title: 'Endereço',
                            initialValue: widget.cardModel.billingAddress,
                          ),
                          CardTileData(
                            title: 'Distrito/Bairro',
                            initialValue: widget.cardModel.billingDistrict,
                          ),
                          CardTileData(
                            title: 'Cidade',
                            initialValue: widget.cardModel.city,
                          ),
                          CardTileData(
                            title: 'Estado',
                            initialValue: widget.cardModel.billingState,
                          ),
                          CardTileData(
                            title: 'CEP',
                            initialValue:
                                widget.cardModel.billingCep.substring(0, 5) +
                                    '-' +
                                    widget.cardModel.billingCep.substring(5, 8),
                          ),
                          // AddressFields(),
                          WhiteButton(
                            onTap: () {
                              // store.removingCard = true;
                              OverlayEntry addCardOverlay;
                              addCardOverlay = OverlayEntry(
                                builder: (context) => ConfirmCard(
                                  svgWay: 'assets/svg/confirmremovecard.svg',
                                  text:
                                      'Tem certeza que deseja remover \nesse cartão?',
                                  onBack: () {
                                    addCardOverlay.remove();
                                  },
                                  onConfirm: () async {
                                    OverlayEntry loadOverlay;
                                    loadOverlay = OverlayEntry(
                                        builder: (context) =>
                                            LoadCircularOverlay());
                                    Overlay.of(context).insert(loadOverlay);
                                    await store.removeCard(widget.cardModel.id);
                                    loadOverlay.remove();
                                    addCardOverlay.remove();
                                  },
                                ),
                              );
                              Overlay.of(context).insert(addCardOverlay);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Observer(builder: (context) {
              return Visibility(
                visible: store.removingCard,
                child: AnimatedContainer(
                  height: maxHeight,
                  width: maxWidth,
                  color: !store.removingCard
                      ? Colors.transparent
                      : Color(0x50000000),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.decelerate,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top: wXD(5, context)),
                      height: wXD(160, context),
                      width: wXD(324, context),
                      decoration: BoxDecoration(
                          color: Color(0xfffafafa),
                          borderRadius: BorderRadius.all(Radius.circular(38))),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: wXD(15, context)),
                            child: Text(
                              'Tem certeza que deseja remover \n esse cartão?',
                              style: TextStyle(
                                fontSize: wXD(15, context),
                                fontWeight: FontWeight.w600,
                                color: Color(0xfa707070),
                              ),
                            ),
                          ),
                          StatefulBuilder(
                            builder: (context, stateSet) {
                              if (loadCircular) {
                                return Row(
                                  children: [
                                    Spacer(),
                                    CircularProgressIndicator(),
                                    Spacer()
                                  ],
                                );
                              } else {
                                return Row(
                                  children: [
                                    Spacer(),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        store.removingCard = false;
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22)),
                                            border: Border.all(
                                                color: Color(0x80707070)),
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
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        stateSet(() {
                                          loadCircular = true;
                                        });
                                        store.removeCard(widget.cardModel.id);
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(22)),
                                            border: Border.all(
                                                color: Color(0x80707070)),
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
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

class CardPaymentData extends StatelessWidget {
  final List colors;
  final String finalNumber;

  const CardPaymentData({
    Key key,
    this.colors,
    this.finalNumber = 'XXXX',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                  Color(colors.first).withOpacity(1),
                  Color(colors.last).withOpacity(1)
                ]),
            borderRadius: BorderRadius.all(
              Radius.circular(18),
            ),
            boxShadow: [
              BoxShadow(
                  color: Color(0x30000000), offset: Offset.zero, blurRadius: 6),
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
                  'XXXX  XXXX  XXXX  $finalNumber',
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
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xfffafafa)),
                    ),
                    Spacer(),
                    Container(
                      height: wXD(15, context),
                      width: wXD(30, context),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: Color(0xfffafafa)),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class CardTileData extends StatelessWidget {
  final String title, initialValue;

  const CardTileData({
    Key key,
    this.title,
    this.initialValue,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        wXD(44, context),
        wXD(0, context),
        wXD(44, context),
        wXD(17, context),
      ),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0x50707070)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xff707070)),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: wXD(291, context),
            child: TextFormField(
              initialValue: initialValue,
              enabled: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorColor: Color(0xff707070),
              decoration: InputDecoration.collapsed(hintText: null),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xff707070),
              ),
            ),
          )
        ],
      ),
    );
  }
}
