import 'package:encontrar_cuidadodoctor/app/modules/finances/transaction_detail.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/empty_state.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'account_balance.dart';
import 'finances_store.dart';
import 'financial_tile.dart';

class FinancesPage extends StatefulWidget {
  final String title;
  const FinancesPage({Key key, this.title = 'FinancesPage'}) : super(key: key);
  @override
  FinancesPageState createState() => FinancesPageState();
}

class FinancesPageState extends ModularState<FinancesPage, FinancesStore> {
  final MainStore mainStore = Modular.get();
  ScrollController scrollController = ScrollController();
  bool isScrollingDown = false;
  bool dropDown = false;
  bool showMenu = false;

  @override
  void initState() {
    showMenu = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainStore.setFilter('all');
    });
    handleScroll();
    super.initState();
  }

  void handleScroll() async {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          mainStore.setShowNav(false);
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!isScrollingDown) {
          mainStore.setShowNav(true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xfffafafa),
      body: SafeArea(
        child: Observer(builder: (_) {
          return Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  setState(() {
                    showMenu = false;
                  });
                },
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.direction < 0) {
                      mainStore.setShowNav(false);
                    }
                    if (details.delta.direction > 0) {
                      mainStore.setShowNav(true);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onDoubleTap: () {
                          // store.createTransactions();
                        },
                        child: EncontrarCuidadoAppBar(
                          title: 'Financeiro',
                        ),
                      ),
                      AccountBalance(
                        value:
                            mainStore.formatedCurrency(mainStore.totalAmount),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(21, 10, 21, 7),
                        child: Row(
                          children: [
                            Text(
                              'Histórico de transações',
                              style: TextStyle(
                                color: Color(0xff4C4C4C),
                                fontSize: wXD(19, context),
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  showMenu = !showMenu;
                                });
                              },
                              child: Icon(
                                Icons.filter_list_outlined,
                                size: wXD(25, context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Color(0xff707070),
                        indent: 20,
                        endIndent: 20,
                      ),
                      mainStore.transactions.isEmpty
                          ? Expanded(
                              child: GestureDetector(
                                onVerticalDragUpdate: (details) {
                                  if (details.delta.direction < 0) {
                                    mainStore.setShowNav(false);
                                  }
                                  if (details.delta.direction > 0) {
                                    mainStore.setShowNav(true);
                                  }
                                },
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      InkWell(
                                        child: EmptyStateList(
                                          image:
                                              'assets/img/pacient_communication.png',
                                          title: 'Sem transações',
                                          description:
                                              'Não há transações para serem exibidas',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                child: Column(
                                  children: mainStore.transactions.map((tr) {
                                    if (tr['id'] != null) {
                                      String shortId;
                                      if (tr['appointment_id'] != null) {
                                        shortId = tr['appointment_id']
                                            .substring(
                                                tr['appointment_id'].length - 4,
                                                tr['appointment_id'].length)
                                            .toUpperCase();
                                      }
                                      print(
                                          '%%%%%% FinancialTileFinancialTile ${tr.get('status')} %%%%%%');

                                      return FinancialTile(
                                        onTap: () {
                                          store.setTransaction(tr);

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  TransactionDetail(
                                                note: tr.get("note"),
                                                id: tr.get('id'),
                                                txt: getTxt2(tr, shortId),
                                                date: tr.get('updated_at'),
                                                revertedReuqest: tr
                                                            .get('status') ==
                                                        'REFUND_REQUESTED_INCOME'
                                                    ? true
                                                    : false,
                                                amount: formatedCurrency(
                                                    tr.get('value'),
                                                    tr.get('status'),
                                                    tr.get('type')),
                                              ),
                                            ),
                                          );
                                        },
                                        value: formatedCurrency(tr.get('value'),
                                            tr.get('status'), tr.get('type')),
                                        text: getTxt(tr, shortId),
                                        info: tr.get('status') ==
                                            'REFUND_REQUESTED_INCOME',
                                        date:
                                            store.getDate(tr.get('updated_at')),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }).toList(),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: showMenu,
                child: Container(
                  height: maxHeight,
                  width: maxWidth,
                  alignment: Alignment.topRight,
                  padding: EdgeInsets.only(
                    right: wXD(45, context),
                    top: wXD(130, context),
                  ),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      vertical: wXD(10, context),
                      // horizontal: wXD(20, context)
                    ),
                    height: wXD(100, context),
                    width: wXD(140, context),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Color(0xff707070).withOpacity(.1)),
                      color: Color(0xfffafafa),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0x15000000),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await mainStore.setFilter('all');
                            await mainStore.getTansactions();
                            setState(() {
                              showMenu = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: wXD(20, context)),
                            width: wXD(140, context),
                            height: wXD(25, context),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: mainStore.trFilter == 'all'
                                    ? Color(0xff41C3B3).withOpacity(.25)
                                    : Color(0xfffafafa)),
                            child: Text(
                              'Todos',
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await mainStore.setFilter('credits');
                            await mainStore.getTansactions();
                            setState(() {
                              showMenu = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: wXD(20, context)),
                            width: wXD(140, context),
                            height: wXD(25, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: mainStore.trFilter == 'credits'
                                  ? Color(0xff41C3B3).withOpacity(.25)
                                  : Color(0xfffafafa),
                            ),
                            child: Text(
                              'Entradas',
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await mainStore.setFilter('debits');
                            await mainStore.getTansactions();
                            setState(() {
                              showMenu = false;
                            });
                          },
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: wXD(20, context)),
                            width: wXD(140, context),
                            height: wXD(25, context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: mainStore.trFilter == 'debits'
                                  ? Color(0xff41C3B3).withOpacity(.25)
                                  : Color(0xfffafafa),
                            ),
                            child: Text(
                              'Saídas',
                              style: TextStyle(
                                color: Color(0xff707070),
                                fontSize: wXD(15, context),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  String formatedCurrency(var value, String status, String type) {
    num val = value;
    if (status == 'REFUND' ||
        status == 'PENDING_REFUND' ||
        status == 'OUTCOME' ||
        status == 'PENDING_CANCELED' ||
        status == 'CANCELED') {
      val = value * -1;
    }

    var numberFormat = new NumberFormat("#,##0.00", "pt_BR");
    return numberFormat.format(val);
  }

  String getTxt(tr, shortId) {
    if (tr.get('status') == 'INCOME' && tr.get('type') == 'PAYOUT') {
      return 'Saque';
    }

    if (tr.get('status') == 'INCOME' || tr.get('status') == 'PENDING_INCOME') {
      if (tr.get('type') == 'GUARANTEE') {
        return 'Pagamento da caução($shortId)';
      } else {
        return 'Pagamento remanescente($shortId)';
      }
    } else {
      switch (tr.get('status')) {
        case 'REFUND_REQUESTED_INCOME':
          return 'Reembolso solicitado($shortId)';
          break;

        case 'REFUND':
          if (tr.get('type') == 'GUARANTEE_REFUND') {
            return 'Reembolso da caução($shortId)';
          }
          if (tr.get('type') == 'REMAINING_REFUND') {
            return 'Reembolso remanescente($shortId)';
          }
          return 'Tipo não identificado';
          break;

        case 'PENDING_REFUND':
          return 'Reembolso pendente($shortId)';
          break;

        case 'OUTCOME':
          return 'Mensalidade';
          break;

        // case 'PENDING_CANCELED':
        //   return 'Mensalidade';
        //   break;

        // case 'CANCELED':
        //   return 'Mensalidade cancelada';
        //   break;

        default:
          return 'Pagamento';
          break;
      }
    }
  }

  String getTxt2(tr, shortId) {
    if (tr.get('status') == 'INCOME' && tr.get('type') == 'PAYOUT') {
      return 'Saque do seu saldo em conta.';
    }

    if (tr.get('status') == 'INCOME' || tr.get('status') == 'PENDING_INCOME') {
      if (tr.get('type') == 'GUARANTEE') {
        return 'Pagamento da caução referente à consulta ($shortId).';
      } else {
        return 'Pagamento referente à consulta ($shortId).';
      }
    } else {
      switch (tr.get('status')) {
        case 'REFUND_REQUESTED_INCOME':
          return 'Reembolso solicitado referente à consulta ($shortId).';
          break;

        case 'REFUND':
          if (tr.get('type') == 'GUARANTEE_REFUND') {
            return 'Reembolso da caução referente à consulta ($shortId) realizado.';
          }
          if (tr.get('type') == 'REMAINING_REFUND') {
            return 'Reembolso do valor remanescente referente à consulta ($shortId) realizado.';
          }
          return 'Tipo não identificado';
          break;

        case 'PENDING_REFUND':
          return 'Reembolso pendente referente à consulta ($shortId).';
          break;

        case 'OUTCOME':
          return 'Pagamento mensal referente ao plano EncontrarCuidado.';

          break;

        // case 'PENDING_CANCELED':
        //   return 'Pagamento mensal referente ao plano EncontrarCuidado.';
        //   break;

        // case 'CANCELED':
        //   return 'Pagamento mensal referente ao plano EncontrarCuidado cancelado.';
        //   break;

        default:
          return 'Pagamento';
          break;
      }
    }
  }
}
