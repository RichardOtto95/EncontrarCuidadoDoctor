import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/confirmation.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/title_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'finances_store.dart';

class TransactionDetail extends StatefulWidget {
  final String id;
  final String txt;
  final String amount;
  final String note;
  final Timestamp date;
  final bool revertedReuqest;

  const TransactionDetail(
      {Key key,
      this.note,
      this.id,
      this.date,
      this.txt,
      this.revertedReuqest,
      this.amount})
      : super(key: key);

  @override
  _TransactionDetailState createState() => _TransactionDetailState();
}

class _TransactionDetailState extends State<TransactionDetail> {
  final MainStore mainStore = Modular.get();
  final FinancesStore store = Modular.get();
  bool loadCircular = false;
  bool alertDialog = false;

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: wXD(50, context)),
                      width: maxWidth,
                      height: wXD(150, context),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 5,
                              color: Color(0x40000000),
                              offset: Offset(0, 3))
                        ],
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff41C3B3),
                            Color(0xff21BCCE),
                          ],
                        ),
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(28)),
                      ),
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              wXD(0, context),
                              wXD(18, context),
                              wXD(18, context),
                              wXD(15, context),
                            ),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () => Navigator.pop(context),
                              child: Icon(
                                Icons.close,
                                size: wXD(35, context),
                                color: Color(0xfffafafa),
                              ),
                            ),
                          ),
                          Center(
                            child: TitleWidget(
                              title: 'Detalhes da transação',
                              left: 0,
                              top: 0,
                              style: TextStyle(
                                color: Color(0xfffafafa),
                                fontSize: wXD(25, context),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        margin: EdgeInsets.only(right: wXD(8, context)),
                        padding: EdgeInsets.all(wXD(5, context)),
                        height: wXD(80, context),
                        width: wXD(80, context),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90),
                            color: Color(0xfffafafa)),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Color(0xff707070), width: 1),
                            // color: Color(0xff707070),
                            borderRadius: BorderRadius.circular(90),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.monetization_on,
                              color: Color(0xff707070),
                              size: wXD(45, context),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: wXD(190, context),
                  child: Text(
                    'Operação realizada em ${DateFormat("${'dd'} '\de' ${'MMMM'} '-' ${'HH:mm'}", "pt_BR").format(DateTime.fromMillisecondsSinceEpoch(widget.date.millisecondsSinceEpoch))}',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Color(0xff787C81).withOpacity(.7),
                      fontSize: wXD(17, context),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Container(
                  width: wXD(300, context),
                  child: Center(
                    child: Text(
                      '${widget.txt}',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color(0xff707070),
                        fontWeight: FontWeight.bold,
                        fontSize: wXD(20, context),
                      ),
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Text(
                  'R\$ ${widget.amount}',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0xff707070),
                    fontWeight: FontWeight.bold,
                    fontSize: wXD(25, context),
                  ),
                ),
                Visibility(
                  visible: widget.revertedReuqest,
                  child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: wXD(10, context),
                        ),
                        Stack(
                          alignment: Alignment.topLeft,
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: wXD(15, context),
                              color: Color(0xffFBBD08),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: wXD(20, context)),
                              width: wXD(135, context),
                              alignment: Alignment.center,
                              child: Text(
                                'Reembolso solicitado pelo paciente',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color(0xff787C81).withOpacity(.7),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                        widget.note == '' ||
                                widget.note == ' ' ||
                                widget.note == null
                            ? Container()
                            : Container(
                                margin: EdgeInsets.only(top: wXD(10, context)),
                                width: wXD(250, context),
                                alignment: Alignment.center,
                                child: Text(
                                  'Motivo: ${widget.note}',
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  maxLines: 4,
                                  style: TextStyle(
                                    color: Color(0xff787C81).withOpacity(.7),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: widget.revertedReuqest,
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      setState(() {
                        alertDialog = !alertDialog;
                      });
                    },
                    child: Container(
                      width: wXD(240, context),
                      height: wXD(39, context),
                      margin: EdgeInsets.only(top: maxWidth * .03),
                      alignment: Alignment.center,
                      child: Text(
                        'Estornar pagamento',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 4),
                              blurRadius: 6,
                              color: Color(0x50000000))
                        ],
                        borderRadius: BorderRadius.all(Radius.circular(23)),
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
                ),
                SizedBox(
                  height: wXD(30, context),
                ),
                Row(
                  children: [
                    Spacer(),
                    Text(
                      '''Precisa de ajuda? Solicite ao
suporte.''',
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Color(0xff787C81).withOpacity(.7),
                        fontSize: wXD(17, context),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        await mainStore.setSupportChat();
                        Modular.to.pushNamed('/suport/');
                      },
                      child: Container(
                        height: maxWidth * 58 / 375,
                        width: maxWidth * 58 / 375,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xff41C3B3),
                              Color(0xff21BCCE),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 3,
                              color: Color(0x20000000),
                            )
                          ],
                          borderRadius: BorderRadius.circular(90),
                          border: Border.all(
                            width: 2,
                            color: Color(0xfffafafa),
                          ),
                        ),
                        child: Icon(
                          Icons.headset_mic,
                          color: Color(0xfffafafa),
                          size: maxWidth * .08,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                SizedBox(
                  height: wXD(30, context),
                ),
              ],
            ),
            Visibility(
              visible: alertDialog,
              child: AnimatedContainer(
                height: maxHeight,
                width: maxWidth,
                color: !alertDialog ? Colors.transparent : Color(0x50000000),
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
                            '''Tem certeza que deseja estornar este pagamento?''',
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
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        print(
                                            '\nstore.transaction.id: ${store.transaction.id} \nstore.transaction.senderId: ${store.transaction.senderId} \nstore.transaction.receiverId: ${store.transaction.receiverId}\n');
                                        setState(() {
                                          alertDialog = !alertDialog;
                                        });
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
                                                Radius.circular(17)),
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
                                        print(
                                            '%%%%%% onTap ${store.transaction} %%%%%%');
                                        await store.approveReversal(
                                          transactionId: store.transaction.id,
                                          doctorId:
                                              mainStore.authStore.viewDoctorId,
                                          patientId: store.transaction.senderId,
                                        );

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Confirmation(
                                              onBack: () {},
                                              title:
                                                  'Reembolso enviado\ncom sucesso!',
                                              subTitle:
                                                  'Pagamento estornado para o cliente',
                                            ),
                                          ),
                                        );
                                        setState(() {
                                          alertDialog = !alertDialog;
                                        });
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
                                                Radius.circular(17)),
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
                        }),
                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
