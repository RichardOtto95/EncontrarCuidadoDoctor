import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:flutter/material.dart';

class SignatureTile extends StatelessWidget {
  final Function onTap;

  const SignatureTile({
    Key key,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: wXD(25, context)),
        padding: EdgeInsets.fromLTRB(
          wXD(28, context),
          wXD(20, context),
          wXD(28, context),
          wXD(25, context),
        ),
        height: wXD(209, context),
        width: wXD(274, context),
        decoration: BoxDecoration(
            color: Color(0xfffafafa),
            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 0),
                color: Color(0x30000000),
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(40)),
            border: Border.all(
                color: Color(0xff707070).withOpacity(.07), width: 1)),
        alignment: Alignment.topCenter,
        child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('info').snapshots(),
            builder: (context, snapshotInfo) {
              // if (snapshotInfo.connectionState == ConnectionState.waiting) {
              //   return Column(
              //     children: [
              //       Spacer(),
              //       CircularProgressIndicator(),
              //       Spacer(),
              //     ],
              //   );
              // }
              if (snapshotInfo.hasData) {
                DocumentSnapshot infoDoc = snapshotInfo.data.docs.first;
                return Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Color(0xff999999),
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                        children: [
                          TextSpan(text: 'De '),
                          TextSpan(
                              text:
                                  'R\$ ${formatedCurrency(infoDoc['old_monthly_price'])}/mês',
                              style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                decorationStyle: TextDecorationStyle.solid,
                              )),
                          TextSpan(text: ' por'),
                        ],
                      ),
                    ),
                    Spacer(),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: Color(0xff999999),
                            fontWeight: FontWeight.w600,
                            fontSize: 33),
                        children: [
                          TextSpan(text: 'R\$ '),
                          TextSpan(
                              text: formatedCurrency(
                                  infoDoc['current_monthly_price']),
                              style: TextStyle(
                                color: Color(0xff41c3b3),
                              )),
                          TextSpan(text: '/mês'),
                        ],
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: onTap,
                      child: Container(
                        height: wXD(35, context),
                        width: wXD(167, context),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xff41c3b3),
                                  Color(0xff21bcce),
                                ]),
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            border: Border.all(
                                color: Color(0xff707070).withOpacity(.07),
                                width: 1)),
                        alignment: Alignment.center,
                        child: Text(
                          'Assinar com o cartão',
                          style: TextStyle(
                            color: Color(0xfffafafa),
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      'Experimente ${infoDoc['free_days']} dias grátis',
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
