import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/appointment_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/consultations/widgets/confirm_schedule.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/messages/chat.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/confirm_popup.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._navbar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/information_tile.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/title_widget.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:encontrar_cuidadodoctor/app/modules/consultations/consultations_store.dart';
import 'package:flutter/material.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/separator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConsultationsPage extends StatefulWidget {
  final AppointmentModel appointmentModel;
  const ConsultationsPage({
    Key key,
    this.appointmentModel,
  }) : super(key: key);
  @override
  ConsultationsPageState createState() => ConsultationsPageState();
}

class ConsultationsPageState extends State<ConsultationsPage> {
  final ConsultationsStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    store.cancelConsultation = false;
    store.checkIn = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (mainStore.consultChat == true) {
          mainStore.consultChat = false;
        }
        mainStore.hasChat = false;
        if (store.checkIn ||
            store.confirmOverlay != null && store.confirmOverlay.mounted) {
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              StreamBuilder<Object>(
                  stream: FirebaseFirestore.instance
                      .collection('doctors')
                      .doc(mainStore.authStore.user != null
                          ? mainStore.authStore.user.uid
                          : '')
                      .collection('permissions')
                      .where('label', isEqualTo: 'CARE')
                      .snapshots(),
                  builder: (context, snapermissions) {
                    QuerySnapshot permissions;

                    if (mainStore.authStore.type == 'SECRETARY') {
                      if (snapermissions.hasData) {
                        permissions = snapermissions.data;
                        store.allowed = permissions.docs.first.get('value');
                      }
                    }
                    return Column(
                      children: [
                        EncontrarCuidadoAppBar(
                          onTap: () {
                            if (mainStore.consultChat == true) {
                              mainStore.consultChat = false;
                            }
                            mainStore.hasChat = false;
                            if (!store.checkIn &&
                                    store.confirmOverlay == null ||
                                !store.confirmOverlay.mounted) {
                              Modular.to.pop();
                            }
                          },
                          title: 'Detalhes da Consulta',
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitleWidget(
                                  title: 'Paciente',
                                  top: wXD(14, context),
                                  left: wXD(18, context),
                                  bottom: wXD(7, context),
                                ),
                                DoctorAppointment(
                                  status: widget.appointmentModel.status,
                                  store: store,
                                  checkIn: () {
                                    if (mainStore.authStore.type == 'DOCTOR' ||
                                        (mainStore.authStore.type ==
                                                'SECRETARY' &&
                                            store.allowed == true)) {
                                      store.checkIn = true;
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Acesso negado",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Color(0xff21BCCE),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  sendMessage: () async {
                                    // if (mainStore.profileChat == null) {
                                    if (widget.appointmentModel.patientId !=
                                        null) {
                                      mainStore.patientId =
                                          widget.appointmentModel.patientId;
                                      await store.mainStore.hasChatWith(
                                          widget.appointmentModel.patientId);
                                    }

                                    // }

                                    mainStore.consultChat = true;
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Chat()));
                                    // Modular.to.pushNamed('/messages/chat');
                                  },
                                  name: widget.appointmentModel.patientName,
                                  userId: widget.appointmentModel.dependentId !=
                                          null
                                      ? widget.appointmentModel.dependentId
                                      : widget.appointmentModel.patientId,
                                ),
                                TitleWidget(
                                  title: 'Contato',
                                  top: wXD(9, context),
                                  left: wXD(18, context),
                                  bottom: wXD(14, context),
                                ),
                                InformationTitle(
                                  icon: Icons.phone,
                                  title: store
                                      .getMask(widget.appointmentModel.contact),
                                  color: Color(0xff484D54),
                                  left: wXD(25, context),
                                ),
                                Separator(vertical: wXD(7, context)),
                                TitleWidget(
                                  title: 'Detalhes',
                                  top: wXD(9, context),
                                  left: wXD(18, context),
                                  bottom: wXD(14, context),
                                ),
                                ScheduleTitle(
                                  icon: Icons.calendar_today,
                                  from: store
                                      .getDate(widget.appointmentModel.hour),
                                  until: store
                                      .getDate(widget.appointmentModel.endHour),
                                  color: Color(0xff484D54),
                                  left: wXD(25, context),
                                ),
                                Separator(vertical: wXD(7, context)),
                                SizedBox(
                                  height: wXD(13, context),
                                ),
                                InformationTitle(
                                  icon: Icons.medical_services,
                                  title: mainStore.getVisitType(
                                      widget.appointmentModel.type),
                                  color: Color(0xff484D54),
                                  left: wXD(25, context),
                                ),
                                Separator(vertical: wXD(7, context)),
                                TitleWidget(
                                  title: 'Preço',
                                  top: wXD(9, context),
                                  left: wXD(18, context),
                                  bottom: wXD(14, context),
                                ),
                                InformationTitle(
                                  icon: Icons.money,
                                  title:
                                      'R\$${formatedCurrency(widget.appointmentModel.price)}',
                                  color: Color(0xff484D54),
                                  left: wXD(25, context),
                                ),
                                Separator(vertical: wXD(7, context)),
                                TitleWidget(
                                  title: 'Informações Adicionais',
                                  top: wXD(9, context),
                                  left: wXD(18, context),
                                  bottom: wXD(14, context),
                                ),
                                widget.appointmentModel.note != null &&
                                        widget.appointmentModel.note != ''
                                    ? AdicionalInformationTitle(
                                        info: widget.appointmentModel.note,
                                        color: Color(0xff484D54),
                                        left: wXD(25, context),
                                      )
                                    : Container(),
                                AdicionalInformationTitle(
                                  info: widget.appointmentModel.covidSymptoms
                                      ? 'Teve contato ou sintoma de febres, tosses ou dificuldade de respirar.'
                                      : 'Não teve contato ou sintoma de febres, tosses ou dificuldade de respirar.',
                                  color: Color(0xff484D54),
                                  left: wXD(25, context),
                                ),
                                AdicionalInformationTitle(
                                  info: widget.appointmentModel.firstVisit
                                      ? 'É a primeira consulta desse paciente.'
                                      : 'Não é a primeira consulta desse paciente.',
                                  color: Color(0xff484D54),
                                  left: wXD(25, context),
                                ),
                                widget.appointmentModel.status == 'SCHEDULED' ||
                                        widget.appointmentModel.status ==
                                            'AWAITING'
                                    ? Center(
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            if (mainStore.authStore.type ==
                                                    'DOCTOR' ||
                                                (mainStore.authStore.type ==
                                                        'SECRETARY' &&
                                                    store.allowed == true)) {
                                              // store.cancelConsultation = true;
                                              store.confirmOverlay =
                                                  OverlayEntry(
                                                      builder: (context) =>
                                                          ConfirmAppointment(
                                                            onConfirm:
                                                                () async {
                                                              await store
                                                                  .changeStatus(
                                                                      widget
                                                                          .appointmentModel,
                                                                      'CANCELED',
                                                                      context);
                                                            },
                                                            onBack: () {
                                                              store
                                                                  .confirmOverlay
                                                                  .remove();
                                                            },
                                                            svgWay:
                                                                "./assets/svg/calendarcancel.svg",
                                                            text:
                                                                "Tem certeza que deseja cancelar\na consulta?",
                                                          ));
                                              Overlay.of(context)
                                                  .insert(store.confirmOverlay);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Acesso negado",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Color(0xff21BCCE),
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: wXD(25, context),
                                              bottom: wXD(47, context),
                                            ),
                                            height: wXD(47, context),
                                            width: wXD(240, context),
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(18)),
                                                border: Border.all(
                                                  color: Color(0xff707070)
                                                      .withOpacity(.40),
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
                                              'Cancelar Consulta',
                                              style: TextStyle(
                                                color: Color(0xffFF4444),
                                                fontWeight: FontWeight.w500,
                                                fontSize: wXD(18, context),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  }),
              Observer(builder: (context) {
                return ConfirmPopUp(
                    visible: store.checkIn,
                    text:
                        'Tem certeza que deseja realizar o check in deste paciente?',
                    onCancel: () {
                      store.checkIn = false;
                    },
                    onConfirm: () async {
                      Duration diference = widget.appointmentModel.hour
                          .toDate()
                          .difference(DateTime.now());

                      if (diference.inDays < 1) {
                        await store.checkingIn(
                            widget.appointmentModel, context);
                      } else {
                        Fluttertoast.showToast(
                            msg:
                                'O check in só pode ser realizado no dia da consulta!');
                      }
                      store.checkIn = false;
                    });
              }),
              Observer(builder: (context) {
                return ConfirmPopUp(
                    visible: store.cancelConsultation,
                    text: 'Tem certeza que deseja cancelar a consulta?',
                    onCancel: () {
                      store.cancelConsultation = false;
                    },
                    onConfirm: () {
                      store.changeStatus(
                          widget.appointmentModel, 'CANCELED', context);
                    });
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorAppointment extends StatelessWidget {
  final String userId, name, status;
  final Function sendMessage;
  final Function checkIn;
  final ConsultationsStore store;

  const DoctorAppointment({
    Key key,
    this.sendMessage,
    this.checkIn,
    this.userId,
    this.name,
    this.store,
    this.status,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          bottom: wXD(15, context),
          right: wXD(15, context),
          left: wXD(15, context),
        ),
        padding: EdgeInsets.symmetric(vertical: wXD(10, context)),
        height: status == 'SCHEDULED' ? wXD(131, context) : wXD(100, context),
        width: wXD(306, context),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              offset: Offset(3, 3),
              color: Color(0x30000000),
            ),
          ],
          color: Color(0xfffafafa),
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: wXD(7, context),
          ),
          width: wXD(300, context),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: wXD(6, context),
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('patients')
                      .doc(userId)
                      .snapshots(),
                  builder: (context, snapshotUser) {
                    if (!snapshotUser.hasData) {
                      return Container(
                        height: wXD(60, context),
                        width: wXD(60, context),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    }

                    DocumentSnapshot docUser = snapshotUser.data;
                    return InkWell(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => store.viewPatientProfile(userId),
                      child: CircleAvatar(
                        radius: wXD(30, context),
                        backgroundImage: docUser['avatar'] == null
                            ? AssetImage('assets/img/defaultUser.png')
                            : NetworkImage(docUser['avatar']),
                      ),
                    );
                  }),
              SizedBox(
                width: wXD(8, context),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: wXD(220, context),
                    padding: EdgeInsets.only(
                      top: wXD(2, context),
                      bottom: wXD(3, context),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        name != null ? name : 'Não informado',
                        style: TextStyle(
                          color: Color(0xff484D54),
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: sendMessage,
                    child: Container(
                      margin: EdgeInsets.only(top: wXD(10, context)),
                      height: wXD(30, context),
                      width: wXD(217, context),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Color(0xff41c3b3),
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'Enviar Mensagem',
                        style: TextStyle(
                            color: Color(0xff41c3b3),
                            fontWeight: FontWeight.w500,
                            fontSize: 13),
                      ),
                    ),
                  ),
                  status == 'SCHEDULED'
                      ? InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: checkIn,
                          child: Container(
                            margin: EdgeInsets.only(top: wXD(10, context)),
                            height: wXD(30, context),
                            width: wXD(217, context),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 2,
                                color: Color(0xff41c3b3),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(25),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Check in',
                                  style: TextStyle(
                                      color: Color(0xff41c3b3),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13),
                                ),
                                Icon(Icons.check, color: Colors.green),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleTitle extends StatelessWidget {
  final IconData icon;
  final String from;
  final String until;
  final double left;
  final Color color;

  const ScheduleTitle({
    Key key,
    this.icon,
    this.from,
    this.color,
    this.left,
    this.until,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getLeft(BuildContext context) {
    double _left;
    if (left == null) {
      _left = wXD(30, context);
    } else {
      _left = left;
    }
    return _left;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: getLeft(context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: wXD(22, context),
            color: Color(0xff707070).withOpacity(.8),
          ),
          SizedBox(
            width: wXD(10, context),
          ),
          Container(
            width: wXD(294, context),
            padding: EdgeInsets.only(top: wXD(2, context)),
            child: Column(
              children: [
                Row(children: [
                  Text(
                    'Início',
                    style: TextStyle(
                      color: getColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: wXD(15, context),
                    ),
                  ),
                  Spacer(),
                  Text(
                    '$from',
                    style: TextStyle(
                      color: getColor(),
                      fontWeight: FontWeight.w500,
                      fontSize: wXD(15, context),
                    ),
                  ),
                ]),
                Container(
                  width: wXD(294, context),
                  padding: EdgeInsets.only(top: wXD(2, context)),
                  child: Row(children: [
                    Text(
                      'Até',
                      style: TextStyle(
                        color: getColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: wXD(15, context),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '$until',
                      style: TextStyle(
                        color: getColor(),
                        fontWeight: FontWeight.w500,
                        fontSize: wXD(15, context),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdicionalInformationTitle extends StatelessWidget {
  final IconData icon;
  final String info;
  final double left;
  final Color color;

  const AdicionalInformationTitle({
    Key key,
    this.icon,
    this.info,
    this.color,
    this.left,
  }) : super(key: key);

  getColor() {
    Color _color;
    if (color == null) {
      _color = Color(0xff707070);
    } else {
      _color = color;
    }
    return _color;
  }

  getLeft(BuildContext context) {
    double _left;
    if (left == null) {
      _left = wXD(30, context);
    } else {
      _left = left;
    }
    return _left;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: getLeft(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: wXD(300, context),
            padding: EdgeInsets.symmetric(vertical: wXD(8, context)),
            child: Text(
              '$info',
              style: TextStyle(
                color: getColor(),
                fontWeight: FontWeight.w500,
                fontSize: wXD(15, context),
              ),
            ),
          ),
          Container(
            width: wXD(325, context),
            height: wXD(1, context),
            margin: EdgeInsets.symmetric(vertical: wXD(5, context)),
            color: Color(0xff707070).withOpacity(.26),
          )
        ],
      ),
    );
  }
}
