import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/card_model.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CardPayment extends StatelessWidget {
  final List colors;
  final String finalNumber;
  final DocumentSnapshot docCard;

  const CardPayment({
    Key key,
    this.colors,
    this.finalNumber,
    this.docCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CardModel cardModel = CardModel.fromDocument(docCard);
        Modular.to.pushNamed('/signature/card-data', arguments: cardModel);
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
                    Color(colors.first).withOpacity(1),
                    Color(colors.last).withOpacity(1)
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
      ),
    );
  }
}
