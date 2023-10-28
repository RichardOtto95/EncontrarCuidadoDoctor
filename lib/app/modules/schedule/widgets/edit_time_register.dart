import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/finances/title_widget.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/widgets/card_patient.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/widgets/schedule_type.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/widgets/seachAddPatient.dart';
import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class EditTimeRegister extends StatefulWidget {
  @override
  _EditTimeRegister createState() => _EditTimeRegister();
}

class _EditTimeRegister extends State<EditTimeRegister> {
  ScheduleStore store = Modular.get();

  bool showclick = false;

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

  @override
  void initState() {
    store.patientSelected = null;
    store.patients.clear();
    store.patientsSearched.clear();
    store.patientSearchKey = '';
    store.searchAddPatientHeight = 0;
    super.initState();
  }

  @override
  void dispose() {
    store.patients.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        store.patients.clear();
        store.needJustification = false;

        return true;
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
                  child: Observer(builder: (_) {
                    return SingleChildScrollView(
                      controller: store.snapScrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EncontrarCuidadoAppBar(
                              title: 'Encaixe',
                              onTap: () {
                                store.patients.clear();
                                store.needJustification = false;

                                Modular.to.pop();
                              }),
                          TitleWidget(
                            left: 21,
                            title: 'Detalhes dos horários agendados',
                            style: bigTextStyle,
                          ),
                          Separator(horizontal: 21),
                          InkWell(
                            hoverColor: Color(0xff707070).withOpacity(.1),
                            splashColor: Color(0xff707070).withOpacity(.3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TitleWidget(
                                  top: 20,
                                  left: 21,
                                  bottom: 15,
                                  title: 'Início',
                                  style: textStyle,
                                ),
                                TitleWidget(
                                  left: 0,
                                  top: 0,
                                  bottom: 0,
                                  right: 21,
                                  title:
                                      '${DateFormat('EEEE').format(store.dateSelected).substring(0, 1).toUpperCase()}${DateFormat('EEEE').format(store.dateSelected).substring(1, 3)}, ${DateFormat('d').format(store.dateSelected)} de ${DateFormat('MMMM').format(store.dateSelected).substring(0, 3)} • ${store.timeBegin.hour.toString().padLeft(2, '0')}:${store.timeBegin.minute.toString().padLeft(2, '0')}',
                                  style: textStyle,
                                )
                              ],
                            ),
                          ),
                          InkWell(
                            hoverColor: Color(0xff707070).withOpacity(.1),
                            splashColor: Color(0xff707070).withOpacity(.3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  style: textStyle,
                                )
                              ],
                            ),
                          ),
                          Separator(horizontal: 21),
                          SizedBox(height: wXD(14, context)),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('doctors')
                                  .doc(mainStore.authStore.viewDoctorId)
                                  .collection('schedules')
                                  .doc(store.schedule['id'])
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container();
                                } else {
                                  print(
                                      'snapshot.data kkk:${snapshot.data['type']}');
                                  return Row(
                                    children: [
                                      TitleWidget(left: 21, title: 'Tipo:'),
                                      SizedBox(width: wXD(20, context)),
                                      AppointmentType(
                                        enabled: false,
                                        type: store.schedule['event_name'],
                                      ),
                                    ],
                                  );
                                }
                              }),
                          StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('doctors')
                                .doc(mainStore.authStore.viewDoctorId)
                                .collection('schedules')
                                .doc(store.schedule['id'])
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: TextFormField(
                                              enabled: false,
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xff707070),
                                                    width: 1,
                                                  ),
                                                ),
                                                hintText: '0',
                                                hintStyle: TextStyle(
                                                  color: Color(0xff707070),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: wXD(45, context)),
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
                                            enabled: false,
                                            textAlign: TextAlign.center,
                                            decoration:
                                                InputDecoration.collapsed(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff707070),
                                                  width: 1,
                                                ),
                                              ),
                                              hintText: '0',
                                              hintStyle: TextStyle(
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: wXD(45, context)),
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
                                            enabled: false,
                                            textAlign: TextAlign.center,
                                            decoration:
                                                InputDecoration.collapsed(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff707070),
                                                  width: 1,
                                                ),
                                              ),
                                              hintText: '0',
                                              hintStyle: TextStyle(
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: wXD(45, context)),
                                      ],
                                    ),
                                  ],
                                );
                              } else {
                                DocumentSnapshot doc = snapshot.data;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                            child: TextFormField(
                                              enabled: false,
                                              textAlign: TextAlign.center,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xff707070),
                                                    width: 1,
                                                  ),
                                                ),
                                                hintText: doc['total_vacancies']
                                                    .toString(),
                                                hintStyle: TextStyle(
                                                  color: Color(0xff707070),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: wXD(45, context)),
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
                                            enabled: false,
                                            textAlign: TextAlign.center,
                                            decoration:
                                                InputDecoration.collapsed(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff707070),
                                                  width: 1,
                                                ),
                                              ),
                                              hintText:
                                                  doc['available_vacancies']
                                                      .toString(),
                                              hintStyle: TextStyle(
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: wXD(45, context)),
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
                                            enabled: false,
                                            textAlign: TextAlign.center,
                                            decoration:
                                                InputDecoration.collapsed(
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xff707070),
                                                  width: 1,
                                                ),
                                              ),
                                              hintText:
                                                  doc['occupied_vacancies']
                                                      .toString(),
                                              hintStyle: TextStyle(
                                                color: Color(0xff707070),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: wXD(45, context)),
                                      ],
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                          Observer(
                            builder: (context) => store.patientSelected == null
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Separator(
                                        vertical: wXD(13, context),
                                      ),
                                      TitleWidget(
                                        title:
                                            'Selecione o paciente a encaixar',
                                        top: 0,
                                        bottom: wXD(13, context),
                                        style: bigTextStyle,
                                      )
                                    ],
                                  )
                                : Container(
                                    height: wXD(13, context),
                                  ),
                          ),
                          SearchAddPatient(),
                          Observer(
                            builder: (_) {
                              return store.patientSelected != null
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TitleWidget(
                                          top: 27,
                                          bottom: 21,
                                          title: 'Paciente selecionado:',
                                          style: textStyle,
                                        ),
                                        CardPatient(
                                            patient: store.patientSelected),
                                        SizedBox(height: wXD(20, context))
                                      ],
                                    )
                                  : SizedBox(height: wXD(60, context));
                            },
                          ),
                          Center(
                            child: store.snapCircular
                                ? Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(
                                        height: wXD(30, context),
                                      )
                                    ],
                                  )
                                : InkWell(
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    onTap: () async {
                                      store.setSnapCircular(true);
                                      bool _concluded =
                                          await store.fitPatient(context);
                                      if (_concluded) {
                                        Fluttertoast.showToast(
                                          msg: 'Solicitação de encaixe enviada',
                                          backgroundColor: Colors.blue[400],
                                        );
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: maxWidth * .025,
                                        bottom: maxWidth * .07,
                                      ),
                                      height: maxWidth * .1493,
                                      width: maxWidth * .1493,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(90),
                                          gradient: store.patientSelected !=
                                                  null
                                              ? LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    Color(0xff41C3B3),
                                                    Color(0xff21BCCE),
                                                  ],
                                                )
                                              : LinearGradient(
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter,
                                                  colors: [
                                                    ColorTheme.textGrey,
                                                    ColorTheme.textGrey
                                                  ],
                                                ),
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 6,
                                              offset: Offset(0, 3),
                                              color: Color(0x30000000),
                                            )
                                          ]),
                                      child: Icon(
                                        Icons.check,
                                        color: Color(0xfffafafa),
                                        size: maxWidth * .1,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
