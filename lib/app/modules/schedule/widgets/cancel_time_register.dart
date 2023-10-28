import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/finances/title_widget.dart';
import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/separator.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/white_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../schedule_store.dart';
import 'schedule_type.dart';

class CancelTimeRegister extends StatefulWidget {
  @override
  _CancelTimeRegister createState() => _CancelTimeRegister();
}

class _CancelTimeRegister extends State<CancelTimeRegister> {
  final ScheduleStore store = Modular.get();
  final _formKey = GlobalKey<FormState>();
  bool enabled = false;
  bool hasFocus = false;
  DateTime date = DateTime.now();
  TimeOfDay timeOfDayBegin;
  TimeOfDay timeOfDayEnd;
  TextStyle textStyle = TextStyle(
    color: Color(0xff4C4C4C),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  TextStyle bigTextStyle = TextStyle(
    color: Color(0xff4C4C4C),
    fontSize: 19,
    fontWeight: FontWeight.w600,
  );

  String justification = '';
  double height = 118;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Listener(
        onPointerDown: (evente) {
          FocusScope.of(context).requestFocus(new FocusNode());
          hasFocus = false;
        },
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EncontrarCuidadoAppBar(
                          title: 'Excluir horários',
                          onTap: () {
                            Modular.to.pop();
                          },
                        ),
                        TitleWidget(
                            left: 21, title: 'Detalhes do horário agendados'),
                        Separator(horizontal: 21),
                        InkWell(
                          hoverColor: Color(0xff707070).withOpacity(.1),
                          splashColor: Color(0xff707070).withOpacity(.3),
                          // onTap: () => pickTime(context, false),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    '${DateFormat('EEEE').format(store.dateSelected).substring(0, 1).toUpperCase()}${DateFormat('EEEE').format(store.dateSelected).substring(1, 3)}, ${DateFormat('d').format(store.dateSelected)} de ${DateFormat('MMMM').format(store.dateSelected).substring(0, 3)} • ${store.timeBegin.hour.toString().padLeft(2, '0')}:${store.timeBegin.minute.toString().padLeft(2, '0')}',
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
                          // onTap: () => pickTime(context, true),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TitleWidget(
                                  left: 21, top: 15, bottom: 20, title: 'Até'),
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
                              enabled: false,
                              type: store.schedule['event_name'],
                            ),
                          ],
                        ),
                        Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(right: wXD(30, context)),
                              width: wXD(370, context),
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: wXD(30, context)),
                                    child: Row(
                                      children: [
                                        TitleWidget(
                                          title: 'Qtde de vagas total:',
                                          style: textStyle,
                                        ),
                                        Spacer(),
                                        Container(
                                          width: wXD(52, context),
                                          child: TextFormField(
                                            enabled: enabled,
                                            textAlign: TextAlign.center,
                                            decoration:
                                                InputDecoration.collapsed(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff707070),
                                                  width: 1,
                                                ),
                                              ),
                                              hintText: store
                                                  .schedule['total_vacancies']
                                                  .toString(),
                                              hintStyle: TextStyle(
                                                color: Color(0xff707070),
                                              ),
                                            ),
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
                                        child: TextFormField(
                                          enabled: enabled,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration.collapsed(
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff707070),
                                                width: 1,
                                              ),
                                            ),
                                            hintText: store
                                                .schedule['available_vacancies']
                                                .toString(),
                                            hintStyle: TextStyle(
                                              color: Color(0xff707070),
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
                                        child: TextFormField(
                                          enabled: enabled,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration.collapsed(
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color(0xff707070),
                                                width: 1,
                                              ),
                                            ),
                                            hintText: store
                                                .schedule['occupied_vacancies']
                                                .toString(),
                                            hintStyle: TextStyle(
                                              color: Color(0xff707070),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('appointments')
                              .where('schedule_id',
                                  isEqualTo: store.schedule['id'])
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              store.getNeedJustification(snapshot.data);
                            }
                            return Observer(
                              builder: (context) {
                                return !store.needJustification
                                    ? Container(
                                        padding: EdgeInsets.only(
                                            top: hXD(100, context)),
                                        width: maxWidth(context),
                                        child: store.loadCircular
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                ],
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  WhiteButton(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                    width: 140,
                                                    height: 47,
                                                    text: 'Cancelar',
                                                  ),
                                                  WhiteButton(
                                                    borderColorBlue: true,
                                                    onTap: () {
                                                      store.loadCircular = true;
                                                      store.deleteSchedule(
                                                          justification);
                                                    },
                                                    width: 140,
                                                    height: 47,
                                                    text: 'Excluir',
                                                    // color: Color(0xff2185D0),
                                                  ),
                                                ],
                                              ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Separator(vertical: wXD(10, context)),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: wXD(15, context),
                                                      top: wXD(15, context)),
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    color: ColorTheme.textGrey,
                                                  )),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: wXD(13, context),
                                                  vertical: wXD(16, context),
                                                ),
                                                height: wXD(100, context),
                                                width: wXD(334, context),
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                    'Já existem agendamentos realizados neste horário. Confirmando esta exclusão, você também estará desmarcando todos estes agendamentos.'),
                                              )
                                            ],
                                          ),
                                          TitleWidget(
                                              left: 21,
                                              style: bigTextStyle,
                                              title:
                                                  'Justificativa pelo cancelamento*'),
                                          // Separator(horizontal: 21),
                                          Center(
                                            child: Form(
                                              key: _formKey,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(
                                                    vertical: wXD(16, context)),
                                                height: wXD(height, context),
                                                width: wXD(334, context),
                                                alignment: Alignment.topLeft,
                                                child: TextFormField(
                                                  scrollPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal:
                                                        wXD(19, context),
                                                    vertical: wXD(16, context),
                                                  ),
                                                  maxLines: 5,
                                                  cursorColor:
                                                      Color(0xff707070),
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color:
                                                            Color(0xff707070),
                                                        width: wXD(3, context),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(7),
                                                      ),
                                                    ),
                                                    hintText:
                                                        'Adicione aqui a informação para justificar ao(s) paciente(s) o motivo do cancelamento da consulta.',
                                                    hintStyle: TextStyle(
                                                      height: 1.3,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff707070)
                                                          .withOpacity(.5),
                                                    ),
                                                  ),
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  validator: (val) {
                                                    if (val.length == 0) {
                                                      height = 140;
                                                      return 'Campo obrigatório (*)';
                                                    } else if (val.length <
                                                        10) {
                                                      height = 140;
                                                      return 'Mínimo: 10 caracteres';
                                                    } else {
                                                      height = 101;
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val) =>
                                                      justification = val,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                21, 0, 0, 14),
                                            child: Text('  * Obrigatório',
                                                style: TextStyle(
                                                    color: Color(0xff4c4c4c)
                                                        .withOpacity(.7))),
                                          ),
                                          Container(
                                            width: maxWidth(context),
                                            child: store.loadCircular
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularProgressIndicator(),
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      WhiteButton(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        width: 140,
                                                        height: 47,
                                                        text: 'Cancelar',
                                                      ),
                                                      WhiteButton(
                                                        borderColorBlue: true,
                                                        onTap: () {
                                                          if (_formKey
                                                              .currentState
                                                              .validate()) {
                                                            store.loadCircular =
                                                                true;
                                                            store.deleteSchedule(
                                                                justification);
                                                          } else {
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Justifique o cancelamento',
                                                                backgroundColor:
                                                                    Colors.red[
                                                                        400]);
                                                          }
                                                        },
                                                        width: 140,
                                                        height: 47,
                                                        text: 'Excluir',
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ],
                                      );
                              },
                            );
                          },
                        ),
                      ],
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

  pickTime(BuildContext context, bool end) async {
    final initialTime = TimeOfDay(hour: 8, minute: 0);
    final newTime = await showTimePicker(
      context: context,
      initialTime:
          end ? timeOfDayEnd ?? initialTime : timeOfDayBegin ?? initialTime,
    );

    if (newTime == null) return;

    setState(() => end ? timeOfDayEnd : timeOfDayBegin = newTime);
  }
}

class QueryType extends StatefulWidget {
  final bool hasFocus;

  const QueryType({Key key, this.hasFocus}) : super(key: key);
  @override
  _QueryTypeState createState() => _QueryTypeState();
}

class _QueryTypeState extends State<QueryType> {
  final FocusNode focusNode = FocusNode();

  OverlayEntry _overlayEntry;

  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        this._overlayEntry = this._createOverlayEntry();
        Overlay.of(context).insert(this._overlayEntry);
      } else {
        this._overlayEntry.remove();
      }
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(0, size.height),
          link: this._layerLink,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: wXD(14, context), vertical: wXD(9, context)),
              width: wXD(250, context),
              height: wXD(75, context),
              decoration: BoxDecoration(
                color: Color(0xfffafafa),
                borderRadius: BorderRadius.circular(17),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x30000000),
                    blurRadius: 4,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Hora marcada',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Ordem de chegada',
                    style: TextStyle(
                      color: Color(0xff707070),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool hasFocus = widget.hasFocus;
    return CompositedTransformTarget(
      link: this._layerLink,
      child: Focus(
        focusNode: focusNode,
        child: InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            // print('focusNode tem focus? ${focusNode.hasFocus}');
            if (!hasFocus) {
              hasFocus = true;
              focusNode.requestFocus();
            } else {
              hasFocus = false;
              focusNode.unfocus();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: wXD(10, context)),
            height: wXD(32, context),
            width: wXD(250, context),
            decoration: BoxDecoration(
              border: Border.all(
                color: Color(0xff707070),
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  'Selecione o tipo da consulta',
                  style: TextStyle(
                    color: Color(0xff707070).withOpacity(.4),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Color(0xff707070).withOpacity(.4),
                  size: wXD(20, context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
