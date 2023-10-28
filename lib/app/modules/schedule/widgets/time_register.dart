import 'package:encontrar_cuidadodoctor/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/finances/title_widget.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/widgets/schedule_type.dart';
import 'package:encontrar_cuidadodoctor/app/modules/sign/widgets/masktextinputformatter.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/dialog_notification.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/white_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class TimeRegister extends StatefulWidget {
  TimeRegister({Key key}) : super(key: key);

  @override
  _TimeRegisterState createState() => _TimeRegisterState();
}

class _TimeRegisterState extends State<TimeRegister> {
  final ScheduleStore store = Modular.get();

  bool enabled = false;
  TextStyle textStyle = TextStyle(
    color: Color(0xff4C4C4C),
    fontSize: 19,
    fontWeight: FontWeight.w600,
  );
  int totalVacancies = 1;
  MaskTextInputFormatter maskFormatterNumber =
      new MaskTextInputFormatter(mask: '###', filter: {"#": RegExp(r'[0-9]')});

  @override
  void initState() {
    store.textEditingController.text = store.appointmentType == 'Hora marcada'
        ? '1'
        : totalVacancies.toString();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = store.dateSelected;
    return WillPopScope(
      onWillPop: () {
        Modular.to.pop();
        return Future(() => true);
      },
      child: Listener(
        onPointerDown: (evente) {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      height: maxHeight(context) - wXD(30, context),
                      width: maxWidth(context),
                      child: Observer(
                        builder: (context) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EncontrarCuidadoAppBar(
                              title: 'Cadastro de horários',
                              onTap: () {
                                Modular.to.pop();
                              },
                            ),
                            TitleWidget(
                              left: 21,
                              title: 'Selecione os horários para atender',
                            ),
                            Separator(horizontal: 21),
                            InkWell(
                              hoverColor: Color(0xff707070).withOpacity(.1),
                              splashColor: Color(0xff707070).withOpacity(.3),
                              onTap: () => store.pickTime(context, false),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TitleWidget(
                                      top: 20,
                                      left: 21,
                                      bottom: 15,
                                      title: 'Início'),
                                  TitleWidget(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    right: 21,
                                    title:
                                        '${DateFormat('EEEE').format(date).substring(0, 1).toUpperCase()}${DateFormat('EEEE').format(date).substring(1, 3)}, ${DateFormat('d').format(date)} de ${DateFormat('MMMM').format(date).substring(0, 3)} • ${store.timeBegin.hour.toString().padLeft(2, '0')}:${store.timeBegin.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: Color(0xff484D54),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              hoverColor: Color(0xff707070).withOpacity(.1),
                              splashColor: Color(0xff707070).withOpacity(.3),
                              onTap: () => store.pickTime(context, true),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TitleWidget(
                                      left: 21,
                                      top: 15,
                                      bottom: 20,
                                      title: 'Até'),
                                  TitleWidget(
                                    left: 0,
                                    top: 0,
                                    bottom: 0,
                                    right: 21,
                                    title:
                                        '${store.timeEnd.hour.toString().padLeft(2, '0')}:${store.timeEnd.minute.toString().toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: Color(0xff484D54),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Separator(horizontal: 21),
                            SizedBox(height: wXD(14, context)),
                            Row(
                              children: [
                                TitleWidget(left: 21, title: 'Tipo:'),
                                SizedBox(width: wXD(20, context)),
                                AppointmentType(
                                  tap: () {
                                    setState(() {
                                      enabled = false;
                                      totalVacancies = 1;
                                    });
                                  },
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Container(
                                  padding:
                                      EdgeInsets.only(right: wXD(30, context)),
                                  width: wXD(370, context),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: wXD(30, context)),
                                        child: Row(
                                          children: [
                                            TitleWidget(
                                              title: 'Qtde de vagas total:',
                                              style: textStyle,
                                            ),
                                            Spacer(),
                                            Container(
                                              width: wXD(52, context),
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: enabled
                                                              ? Color(
                                                                  0xff4c4c4c)
                                                              : Color(
                                                                  0x70707070)))),
                                              child: TextFormField(
                                                controller:
                                                    store.textEditingController,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  maskFormatterNumber
                                                ],
                                                enabled:
                                                    store.appointmentType ==
                                                            'Hora marcada'
                                                        ? false
                                                        : enabled,
                                                textAlign: TextAlign.center,
                                                onChanged: (val) {
                                                  if (val == '' ||
                                                      store.appointmentType ==
                                                          'Hora marcada') {
                                                    totalVacancies = 1;
                                                  } else {
                                                    totalVacancies =
                                                        int.parse(val);
                                                  }
                                                },
                                                style: TextStyle(
                                                    color: enabled
                                                        ? Color(0xff4c4c4c)
                                                        : Color(0x70707070),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                decoration:
                                                    InputDecoration.collapsed(
                                                        hintText: ''),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          TitleWidget(
                                            title: 'Qtde de vagas disponíveis:',
                                            style: textStyle,
                                          ),
                                          Spacer(),
                                          Container(
                                            width: wXD(52, context),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0x70707070)))),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                maskFormatterNumber
                                              ],
                                              enabled: false,
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText:
                                                    totalVacancies.toString(),
                                                hintStyle: TextStyle(
                                                  color: Color(0x70707070),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          TitleWidget(
                                            title: 'Qtde de vagas ocupadas:',
                                            style: textStyle,
                                          ),
                                          Spacer(),
                                          Container(
                                            width: wXD(52, context),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Color(
                                                            0x70707070)))),
                                            child: TextFormField(
                                              enabled: false,
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText: '0',
                                                hintStyle: TextStyle(
                                                  color: Color(0x70707070),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                store.appointmentType != 'Hora marcada'
                                    ? Positioned(
                                        top: wXD(15, context),
                                        right: -2,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.edit,
                                            color: Color(0x80707070),
                                            size: wXD(20, context),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              totalVacancies = 1;
                                              enabled = !enabled;
                                            });
                                          },
                                        ))
                                    : Container()
                              ],
                            ),
                            Spacer(flex: 5),
                            Container(
                              width: maxWidth(context),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  WhiteButton(
                                    onTap: () => Modular.to.pop(),
                                    width: 140,
                                    height: 47,
                                    text: 'Cancelar',
                                  ),
                                  WhiteButton(
                                    circularIndicator: store.circularIndicator,
                                    onTap: () {
                                      if (store.appointmentType == '') {
                                        showDialog(
                                          useRootNavigator: true,
                                          barrierColor: Colors.transparent,
                                          useSafeArea: true,
                                          context: context,
                                          builder: (context) =>
                                              DialogNotification(
                                            onClose: () => Modular.to.pop(),
                                            text: 'Selecione o tipo!',
                                            bottom: 42,
                                          ),
                                        );
                                      } else if (totalVacancies == 0) {
                                        Fluttertoast.showToast(
                                            msg:
                                                'A quantidade de vagas disponíveis não pode ser zero!',
                                            backgroundColor: Colors.red[400]);
                                      } else {
                                        store.saveSchedule(
                                          context: context,
                                          totalVacancies: totalVacancies,
                                          availableVacancies: totalVacancies,
                                          occupiedVacancies: 0,
                                        );
                                      }
                                    },
                                    width: 140,
                                    height: 47,
                                    text: 'Salvar',
                                    color: Color(0xff2185D0),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(flex: 1),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
