import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/appointment_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/hour_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class ScheduleWeekPage extends StatefulWidget {
  @override
  _ScheduleWeekPageState createState() => _ScheduleWeekPageState();
}

class _ScheduleWeekPageState extends State<ScheduleWeekPage> {
  final ScheduleStore store = Modular.get();
  final MainStore mainStore = Modular.get();

  @override
  Widget build(BuildContext context) {
    // print(user);
    return WillPopScope(
      onWillPop: () {
        if (store.checkShowModalAppointment) {
          store.setShowModalAppointment(false);
          return Future(() => false);
        } else {
          Modular.to.pop();

          return Future.delayed(
              Duration(milliseconds: 500), () => mainStore.setShowNav(true));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: StreamBuilder<Object>(
              stream: FirebaseFirestore.instance
                  .collection('doctors')
                  .doc(mainStore.authStore.user != null
                      ? mainStore.authStore.user.uid
                      : '')
                  .collection('permissions')
                  .snapshots(),
              builder: (context, snapermissions) {
                QuerySnapshot permissions;

                if (mainStore.authStore.type == 'SECRETARY') {
                  if (snapermissions.hasData) {
                    permissions = snapermissions.data;
                    permissions.docs.forEach((element) {
                      if (element.get('label') == 'PREFERENCES') {
                        store.preAllowed = element.get('value');
                      }
                      if (element.get('label') == 'SCHEDULINGS') {
                        store.schAllowed = element.get('value');
                      }
                    });
                  }
                }

                return Observer(
                  builder: (_) {
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              EncontrarCuidadoAppBar(
                                title: 'Agenda semanal',
                                onTap: () {
                                  Modular.to.pop();
                                  Future.delayed(Duration(milliseconds: 500),
                                      () {
                                    mainStore.setShowNav(true);
                                  });
                                },
                              ),
                              SizedBox(
                                height: wXD(13, context),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: wXD(26, context)),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '${DateFormat('MMM').format(store.dayWeek.last).toString().toUpperCase()}',
                                          style: TextStyle(
                                            height: 1,
                                            color: Color(0xff41C3B3),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 25,
                                          ))),
                                  Container(
                                      margin: EdgeInsets.only(
                                          left: wXD(10, context),
                                          bottom: wXD(2, context)),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                          '${DateFormat('y').format(store.dayWeek.last).toString().toUpperCase()}',
                                          style: TextStyle(
                                            height: 1,
                                            color: Color(0xff41C3B3),
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15,
                                          ))),
                                ],
                              ),
                              SizedBox(height: wXD(13, context)),
                              StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection('doctors')
                                    .doc(mainStore.authStore.viewDoctorId)
                                    .collection('schedules')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Padding(
                                        padding: EdgeInsets.only(
                                            top: wXD(150, context)),
                                        child: CircularProgressIndicator());
                                  } else {
                                    return Observer(
                                      builder: (context) => Container(
                                        height: maxHeight(context) -
                                            wXD(170, context),
                                        width: wXD(341, context),
                                        decoration: BoxDecoration(
                                          color: Color(0xffffffff),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x20000000),
                                              offset: const Offset(0.0, 0.0),
                                              blurRadius: 5.0,
                                              spreadRadius: 1.0,
                                            ), //BoxShadow
                                          ],
                                          border: Border.all(
                                              color: Color(0xff707070)
                                                  .withOpacity(.2)),
                                          borderRadius:
                                              BorderRadius.circular(17),
                                        ),
                                        padding: EdgeInsets.only(
                                            bottom: wXD(13, context)),
                                        child: Column(
                                          children: [
                                            Container(
                                              height: wXD(74.4, context),
                                              width: maxWidth(context),
                                              decoration: BoxDecoration(
                                                color: Color(0xffffffff),
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: wXD(14, context)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  ArrowPager(
                                                    onTap: () =>
                                                        store.changeWeek(false),
                                                  ),
                                                  Container(
                                                    width: wXD(246, context),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: List.generate(
                                                        store.dayWeek.length,
                                                        (index) {
                                                          print(
                                                              'store weeeeek ###################: ${store.dayWeek}');
                                                          return WeekDay(
                                                            date: store
                                                                .dayWeek[index],
                                                            dateSelected: store
                                                                    .dateSelected
                                                                    .toString()
                                                                    .substring(
                                                                        0,
                                                                        11) ==
                                                                store.dayWeek[
                                                                        index]
                                                                    .toString()
                                                                    .substring(
                                                                        0, 11),
                                                            index: index,
                                                            onTap: () {
                                                              store.calendarDayController
                                                                      .selectedDate =
                                                                  store.dayWeek[
                                                                      index];
                                                              store.calendarDayController
                                                                      .displayDate =
                                                                  store.dayWeek[
                                                                      index];
                                                              store.setDateSelected(
                                                                  store.dayWeek[
                                                                      index]);
                                                            },
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  ArrowPager(
                                                    onTap: () =>
                                                        store.changeWeek(true),
                                                    arrowBack: false,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Flexible(
                                              child: getSfCalendar(
                                                snapshot.data,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        HourManager(
                          visible: store.checkShowModalAppointment,
                          onCancel: () {
                            store.setShowModalAppointment(
                                !store.checkShowModalAppointment);
                          },
                        ),
                        Visibility(
                          visible: store.setProfile,
                          child: AnimatedContainer(
                            height: maxHeight(context),
                            width: maxWidth(context),
                            color: !store.setProfile
                                ? Colors.transparent
                                : Color(0x50000000),
                            duration: Duration(milliseconds: 300),
                            curve: Curves.decelerate,
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.only(top: wXD(15, context)),
                                height: wXD(215, context),
                                width: wXD(324, context),
                                decoration: BoxDecoration(
                                    color: Color(0xfffafafa),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(33))),
                                child: Column(
                                  children: [
                                    Container(
                                      width: wXD(240, context),
                                      margin: EdgeInsets.only(
                                          top: wXD(15, context)),
                                      child: Text(
                                        '''Para realizar seu primeiro agendamento, é necessário definir o valor da consulta em Perfil > Configurações > Preferências. Deseja navegar para esta seção?''',
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
                                    Row(
                                      children: [
                                        Spacer(),
                                        InkWell(
                                          onTap: () {
                                            store.setProfileDialog(
                                                !store.setProfile);
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
                                          onTap: () async {
                                            List<num> listNum = await mainStore
                                                .getInitialValues();
                                            store.setProfileDialog(
                                                !store.setProfile);
                                            Modular.to.pushNamed(
                                                '/settings/preferences',
                                                arguments: listNum);
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
                                    ),
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
                    );
                  },
                );
              }),
        ),
      ),
    );
  }

  Widget getSfCalendar(QuerySnapshot qs) {
    return SfCalendar(
      showCurrentTimeIndicator: false,
      cellEndPadding: 0,
      // timeZone: 'Bahia Standard Time',
      controller: store.calendarDayController,
      dataSource: MeetingDataSource(_getDataWeekSource(qs)),
      monthViewSettings: MonthViewSettings(
        appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
      ),
      backgroundColor: Color(0xffffffff),
      view: CalendarView.day,
      headerHeight: 0,
      initialDisplayDate: store.dateSelected,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeRulerSize: 16,
        timeFormat: 'H',
      ),
      cellBorderColor: Color(0xff707070).withOpacity(.5),
      viewHeaderHeight: 0,
      selectionDecoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: const Color(0xff21bcce), width: 2),
        borderRadius: BorderRadius.all(Radius.circular(4)),
        shape: BoxShape.rectangle,
      ),
      onViewChanged: (viewChangedDetails) {
        if (viewChangedDetails.visibleDates[0] != store.dateSelected) {
          if (!store.dayWeek.contains(viewChangedDetails.visibleDates.first)) {
            store.changeWeek(viewChangedDetails.visibleDates[0].weekday == 7);
          }
          store.setDateSelected(viewChangedDetails.visibleDates[0]);
        }
      },
      onTap: (calendarTapDetails) async {
        await mainStore.getInfo();
        if ((mainStore.authStore.type == 'DOCTOR' ||
                (mainStore.authStore.type == 'SECRETARY' &&
                    store.schAllowed == true)) &&
            mainStore.doctorSnap.get('price') != 0) {
          print('price 1');
          store.timerNavigation(
            calendarTapDetails,
            context,
          );
        } else if (mainStore.authStore.type == 'SECRETARY' &&
            store.schAllowed == false) {
          print('price 2');

          Fluttertoast.showToast(
              msg: "Acesso negado",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff21BCCE),
              textColor: Colors.white,
              fontSize: 16.0);
        } else if ((mainStore.authStore.type == 'DOCTOR' &&
                mainStore.doctorSnap.get('price') == 0) ||
            ((mainStore.authStore.type == 'SECRETARY' &&
                    store.preAllowed == true) &&
                mainStore.doctorSnap.get('price') == 0)) {
          print('price 3');

          store.setProfile = !store.setProfile;
        } else if ((mainStore.authStore.type == 'SECRETARY' &&
                store.preAllowed == false) &&
            mainStore.doctorSnap.get('price') == 0) {
          print('price 4');

          Fluttertoast.showToast(
              msg:
                  "Aguarde o doutor definir o valor da consulta ou solicite permissão para alterá-lo.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Color(0xff21BCCE),
              textColor: Colors.white,
              fontSize: 16.0);
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
      appointmentBuilder: (context, calendarAppointmentDetails) {
        print(
            'calendarAppointmentDetails:  ${calendarAppointmentDetails.appointments}');
        Meeting meeting = calendarAppointmentDetails.appointments.first;

        print('calendarAppointmentDetails2:  ${meeting.id}');

        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where('schedule_id', isEqualTo: meeting.id)
              .orderBy('created_at', descending: false)
              .snapshots(),
          builder: (context, appointmentSnap) {
            if (!appointmentSnap.hasData) {
              return Container(color: Color(0xff41c2b3).withOpacity(.2));
            } else {
              QuerySnapshot _qs = appointmentSnap.data;
              List lista = [];
              print('calendarAppointmentDetails: stream  ${_qs.docs.length}');
              _qs.docs.forEach((element) {
                if (element['status'] != 'FIT_REQUESTED' &&
                    element['status'] != 'CANCELED' &&
                    element['status'] != 'REFUSED') {
                  lista.add(element);
                }
              });
              return Container(
                color: Color(0xff41c2b3).withOpacity(.3),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    TextStyle textStyle =
                        TextStyle(color: Color(0xff21bcce), fontSize: 12);
                    return Column(
                      children: List.generate(
                        lista.length,
                        (index) {
                          return Container(
                            height: constraints.maxHeight / lista.length,
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    lista[index]['patient_name'],
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 5),
                                  Text(' - ', style: textStyle),
                                  SizedBox(width: 5),
                                  Text(
                                    lista[index]['hour']
                                        .toDate()
                                        .toString()
                                        .substring(11, 16),
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 5),
                                  Text(' -  ', style: textStyle),
                                  Text(
                                    lista[index]['end_hour']
                                        .toDate()
                                        .toString()
                                        .substring(11, 16),
                                    style: textStyle,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        );
      },
    );
  }

  List<Meeting> _getDataWeekSource(QuerySnapshot qs) {
    final List<Meeting> meetings = <Meeting>[];
    qs.docs.forEach((DocumentSnapshot element) {
      DateTime endHour = element['end_hour'].toDate();
      DateTime endHour2 = endHour;
      if (endHour.hour == 0) {
        print('endHour: ${endHour.toString()}');
        endHour2 = endHour.subtract(Duration(seconds: 2));
        print('endHour2: ${endHour2.toString()}');
      }
      DateTime startHour = element['start_hour'].toDate();
      DateTime startHour2 = startHour;
      if (startHour.hour == 0) {
        print('startHour: ${startHour.toString()}');
        startHour2 = startHour.add(Duration(seconds: 2));
        print('startHour2: ${startHour2.toString()}');
      }
      if (element['status'] != 'DELETED') {
        bool time = element['type'] == 'DEFAULT';
        Meeting meeting = Meeting(
            totalVacancies: element['total_vacancies'],
            availableVacancies: element['available_vacancies'],
            occupiedVacancies: element['occupied_vacancies'],
            type: element['type'],
            id: element.id,
            eventName: time ? 'Horário cadastrado' : 'Período cadastrado',
            from: startHour2,
            to: endHour2,
            background: Color(0xff41c3b3).withOpacity(.5),
            isAllDay: false);

        meetings.add(meeting);
      }
    });

    return meetings;
  }
}

class ArrowPager extends StatelessWidget {
  final bool arrowBack;
  final Function onTap;
  const ArrowPager({
    Key key,
    this.arrowBack = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: wXD(26, context),
        width: wXD(26, context),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff41c3b3),
        ),
        padding: EdgeInsets.only(
          right: arrowBack ? wXD(2, context) : 0,
          left: arrowBack ? 0 : wXD(1, context),
        ),
        alignment: Alignment.center,
        child: Icon(
          arrowBack
              ? Icons.arrow_back_ios_rounded
              : Icons.arrow_forward_ios_rounded,
          size: wXD(16, context),
          color: Color(0xffffffff),
        ),
      ),
    );
  }
}

class WeekDay extends StatelessWidget {
  final ScheduleStore store = Modular.get();
  final int index;
  final DateTime date;
  final Function onTap;
  final bool dateSelected;

  WeekDay({
    Key key,
    this.index,
    this.date,
    this.dateSelected,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    String monthDay = date.day.toString().padLeft(2, '0');

    Color weekColor = Color(0xff484D54);
    Color dayColor = Color(0xff787C81);
    Color blueColor = Color(0xff2185D0);
    if (index == 0) {
      weekColor = Color(0xffDB2828);
      dayColor = Color(0xffDB2828);
    }

    return InkWell(
      onTap: onTap,
      child: Container(
        height: wXD(37, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${weekDays[index]}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: dateSelected ? blueColor : weekColor,
              ),
            ),
            Text(
              '$monthDay',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: dateSelected ? blueColor : dayColor,
              ),
            ),
          ],
        ),
      ),
    );
    //   },
    // );
  }
}
