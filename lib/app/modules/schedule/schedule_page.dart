import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/appointment_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/drprofile/drprofile_page.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/schedule/schedule_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/color_theme.dart';
import 'package:encontrar_cuidadodoctor/app/shared/utilities.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/encontrar_cuidado._app_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SchedulePage extends StatefulWidget {
  final String title;
  const SchedulePage({Key key, this.title = 'Agenda mensal'}) : super(key: key);
  @override
  SchedulePageState createState() => SchedulePageState();
}

class SchedulePageState extends State<SchedulePage> {
  final ScheduleStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  CalendarController calendarController = CalendarController();
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      store.year = DateTime.now().year.toString();
    });
    mainStore.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('pt'),
      ],
      locale: const Locale('pt'),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            EncontrarCuidadoAppBar(title: 'Agenda mensal'),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(
                            left: wXD(26, context), top: wXD(23, context)),
                        alignment: Alignment.centerLeft,
                        child: Text('Calendário',
                            style: TextStyle(
                              color: Color(0xff41C3B3),
                              fontWeight: FontWeight.w700,
                              fontSize: wXD(24, context),
                            ))),
                    Separator(
                      vertical: wXD(15, context),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: wXD(26, context), bottom: wXD(15, context)),
                      child: Text(
                          'Selecione as datas e horários desejados para permitir agendamentos de consultas',
                          style: TextStyle(
                            color: ColorTheme.textGrey,
                            fontWeight: FontWeight.w500,
                            fontSize: wXD(16, context),
                          )),
                    ),
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.only(
                              top: wXD(54, context), bottom: wXD(10, context)),
                          decoration: BoxDecoration(
                            color: Color(0xfffafafa),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x30000000),
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 5.0,
                                spreadRadius: 1.0,
                              ), //BoxShadow
                            ],
                            borderRadius: BorderRadius.circular(14),
                          ),
                          height: wXD(370, context),
                          margin: EdgeInsets.symmetric(
                              horizontal: wXD(40, context)),
                          child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('doctors')
                                .doc(mainStore.authStore.viewDoctorId)
                                .collection('schedules')
                                .snapshots(),
                            builder: (context, snapshot) {
                              return snapshot.hasData
                                  ? SfCalendar(
                                      selectionDecoration: BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(
                                            color: const Color(0xff21bcce),
                                            width: 2),
                                        shape: BoxShape.circle,
                                      ),
                                      initialDisplayDate: DateTime.now()
                                          .subtract(Duration(hours: 3)),
                                      controller: calendarController,
                                      headerDateFormat: 'MMMM',
                                      backgroundColor: Color(0xfffafafa),
                                      showNavigationArrow: true,
                                      headerStyle: CalendarHeaderStyle(
                                        textAlign: TextAlign.center,
                                        textStyle: TextStyle(
                                          color: Color(0xff41C3B3),
                                          fontSize: 17,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      headerHeight: wXD(54, context),
                                      cellBorderColor: Colors.transparent,
                                      view: CalendarView.month,
                                      todayHighlightColor: Color(0xff41C3B3),
                                      onViewChanged: (viewChangedDetails) {
                                        // print(viewChangedDetails
                                        //     .visibleDates[21].year);
                                        String _year = viewChangedDetails
                                            .visibleDates[21].year
                                            .toString();
                                        if (store.year != _year) {
                                          store.setYear(_year);
                                        }
                                      },
                                      onTap: (calendarTapDetails) {
                                        store.setDayWeek(
                                            calendarTapDetails.date);
                                        store.setDateSelected(
                                            calendarTapDetails.date);
                                        store.calendarDayController
                                                .selectedDate =
                                            calendarTapDetails.date;
                                        store.calendarDayController
                                                .displayDate =
                                            calendarTapDetails.date;
                                        mainStore.setShowNav(false);
                                        Modular.to
                                            .pushNamed('/schedule/week-page');
                                      },
                                      dataSource: MeetingDataSource(
                                          _getDataSource(snapshot.data)),
                                      monthCellBuilder: (context, details) {
                                        // print(details.appointments);
                                        double size = 3;
                                        bool hasAppointment =
                                            details.appointments.isNotEmpty;
                                        if (hasAppointment) {
                                          // print(
                                          //     '${details.appointments}  ${details.date}');
                                        }

                                        return Container(
                                          margin: EdgeInsets.all(
                                              wXD(size, context)),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: hasAppointment
                                                ? Color(0xff41c3b3)
                                                : Colors.transparent,
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            details.date.day.toString(),
                                            style: TextStyle(
                                              color: hasAppointment
                                                  ? Color(0XFFFAFAFA)
                                                  : Color(0xff41c3b3),
                                              fontSize: 15,
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      padding: EdgeInsets.only(
                                          top: wXD(50, context)),
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(),
                                    );
                            },
                          ),
                        ),
                        Observer(
                          builder: (context) {
                            return Container(
                              padding: EdgeInsets.only(left: wXD(18, context)),
                              height: wXD(56, context),
                              margin: EdgeInsets.symmetric(
                                  horizontal: wXD(40, context)),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Color(0xff41c3b3),
                                        Color(0xff21bcce),
                                      ]),
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(14))),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                store.year,
                                style: TextStyle(
                                  color: Color(0xfffafafa),
                                  fontSize: 30,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: wXD(50, context)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Meeting> _getDataSource(QuerySnapshot qs) {
    final List<Meeting> meetings = <Meeting>[];
    qs.docs.forEach((DocumentSnapshot element) {
      if (element['status'] != 'DELETED') {
        bool time = element['type'] == 'DEFAULT';
        Meeting meeting = Meeting(
            totalVacancies: element['total_vacancies'],
            availableVacancies: element['available_vacancies'],
            occupiedVacancies: element['occupied_vacancies'],
            type: element['type'],
            id: element.id,
            eventName: time ? 'Horário cadastrado' : 'Período cadastrado',
            from: element['start_hour'].toDate(),
            to: element['end_hour'].toDate(),
            background: Color(0xff41c3b3).withOpacity(.5),
            isAllDay: false);
        // print(Meeting().toJson(meeting));
        meetings.add(meeting);
      }
    });
    return meetings;
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}
