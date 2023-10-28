import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/appointment_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/schedule_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
part 'schedule_store.g.dart';

class ScheduleStore = _ScheduleStoreBase with _$ScheduleStore;

abstract class _ScheduleStoreBase with Store {
  final MainStore mainStore = Modular.get();
  @observable
  double searchAddPatientHeight = 0;
  @observable
  double height = 101;
  @observable
  String appointmentType = '';
  @observable
  String year = DateTime.now().year.toString();
  @observable
  String patientSearchKey = '';
  @observable
  String notificationTextStore = '';
  @observable
  bool checkCalender = false;
  @observable
  bool hasFocus = true;
  @observable
  bool checkShowModalAppointment = false;
  @observable
  bool circularIndicator = false;
  @observable
  bool snapCircular = false;
  @observable
  PatientModel patientSelected;
  @observable
  ObservableList<PatientModel> patients = <PatientModel>[].asObservable();
  @observable
  ObservableList patientsSearched = [].asObservable();
  @observable
  ObservableList dayWeek = [].asObservable();
  @observable
  DateTime dateSelected;
  @observable
  TimeOfDay timeBegin;
  @observable
  TimeOfDay timeEnd;
  @observable
  CalendarController calendarMonthController = CalendarController();
  @observable
  CalendarController calendarDayController = CalendarController();
  @observable
  ScrollController snapScrollController = ScrollController();
  @observable
  Map<String, dynamic> schedule;
  @observable
  bool schAllowed = false;
  @observable
  bool preAllowed = false;
  @observable
  bool setProfile = false;
  @observable
  TextEditingController textEditingController = TextEditingController();
  @observable
  bool needJustification = false, loadCircular = false;

  @action
  void setDateSelected(DateTime _dateSelected) {
    dateSelected = _dateSelected;
  }

  @action
  void setProfileDialog(bool _p) => setProfile = _p;
  @action
  void setYear(String _year) => year = _year;
  @action
  void setCheckCalender(_checkCalender) => checkCalender = _checkCalender;
  @action
  void setShowModalAppointment(_checkShowModalAppointment) =>
      checkShowModalAppointment = _checkShowModalAppointment;
  @action
  setCircularIndicator(bool _circularIndicator) =>
      circularIndicator = _circularIndicator;
  @action
  void setHeight(double _height) => height = _height;
  @action
  void setPatients(ObservableList<PatientModel> _patients) =>
      patients = _patients;
  @action
  setPatientSelected(PatientModel _patientSelected) =>
      patientSelected = _patientSelected;
  @action
  setSnapCircular(_snapCircular) => snapCircular = _snapCircular;

  @action
  void setSearchAddPatientHeight() {
    patientSearchKey == ''
        ? searchAddPatientHeight = 0
        : patientsSearched.length >= 3
            ? searchAddPatientHeight = 140
            : searchAddPatientHeight = patientsSearched.length.toDouble() * 57;

    if (searchAddPatientHeight == 0 && patientSearchKey != '') {
      searchAddPatientHeight = 80;
    }
  }

  void getNeedJustification(QuerySnapshot appointmentsQuery) {
    print(
        'xxxxxxxxxxxxx getNeedJustification ${appointmentsQuery.docs.length}');
    if (appointmentsQuery.docs.length == 0) {
      needJustification = false;
    }

    for (var i = 0; i < appointmentsQuery.docs.length; i++) {
      DocumentSnapshot appointmentDoc = appointmentsQuery.docs[i];
      print('xxxxxxxxxxxxx appointmentDoc status ${appointmentDoc['status']}');
      if (appointmentDoc['status'] == 'SCHEDULED' ||
          appointmentDoc['status'] == 'FIT_REQUESTED') {
        needJustification = true;
        break;
      } else {
        needJustification = false;
      }
    }
  }

  @action
  void setDayWeek(DateTime _dateTime) {
    setDateSelected(_dateTime);
    int weekDay = _dateTime.weekday;
    DateTime subtracted =
        _dateTime.subtract(Duration(days: weekDay == 7 ? 0 : weekDay));
    List _dayWeek = [];

    for (var i = 0; i < 7; i++) {
      _dayWeek.add(subtracted.add(Duration(days: i)));
    }
    dayWeek = _dayWeek.asObservable();
  }

  @action
  pickTime(BuildContext context, bool end) async {
    final newTime = await showTimePicker(
      builder: (context, child) {
        return TimePickerTheme(
          data: TimePickerThemeData(
            hourMinuteTextColor: Color(0xff41c3b3),
            hourMinuteColor: Color(0xff21bcce).withOpacity(.1),
            dialHandColor: Color(0xff41c3b3),
            dialBackgroundColor: Color(0xff21bcce).withOpacity(.1),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child,
          ),
        );
      },
      context: context,
      initialTime: end ? timeEnd : timeBegin,
    );

    if (newTime == null) return;
    DateTime dt = dateSelected;

    DateTime ndt =
        DateTime(dt.year, dt.month, dt.day, newTime.hour, newTime.minute);
    DateTime sdt =
        DateTime(dt.year, dt.month, dt.day, timeBegin.hour, timeBegin.minute);

    DateTime edt =
        DateTime(dt.year, dt.month, dt.day, timeEnd.hour, timeEnd.minute);

    if (!end && ndt.isAfter(edt)) {
      Fluttertoast.showToast(
          msg: 'A data inicial não pode ser posterior à final',
          backgroundColor: Colors.red[400]);
      print('A data inicial não pode ser posterior à final');
      return;
    }

    if (end && ndt.isBefore(sdt)) {
      Fluttertoast.showToast(
          msg: 'A data final não pode ser anterior à inicial',
          backgroundColor: Colors.red[400]);
      print('A data final não pode ser anterior à inicial');
      return;
    }

    end ? timeEnd = newTime : timeBegin = newTime;

    if (!end) {
      setDateSelected(DateTime(
          dt.year, dt.month, dt.day, timeBegin.hour, timeBegin.minute));
    }
  }

  @action
  void changeWeek(bool forward) {
    List nextWeek = [];
    DateTime firstDay = dayWeek.last.add(Duration(days: 1));
    DateTime lastDay = dayWeek.first.subtract(Duration(days: 7));
    for (var i = 0; i < 7; i++) {
      forward
          ? nextWeek.add(firstDay.add(Duration(days: i)))
          : nextWeek.add(lastDay.add(Duration(days: i)));
    }
    dayWeek = nextWeek.asObservable();
  }

  @action
  void timerNavigation(CalendarTapDetails _details, BuildContext _context) {
    setDateSelected(_details.date);
    if (_details.targetElement == CalendarElement.appointment) {
      schedule = Meeting().toJson(_details.appointments.first);
      schedule['type'] == 'HOUR'
          ? appointmentType = 'Hora marcada'
          : appointmentType = 'Ordem de chegada';
      // print('$appointment \n ');
      timeBegin = TimeOfDay(
        hour: schedule['from'].hour,
        minute: schedule['from'].minute,
      );
      timeEnd = TimeOfDay(
        hour: schedule['to'].hour,
        minute: schedule['to'].minute,
      );
      print('ddddddddddddddd appointment to ${schedule['to']}');
      print('ddddddddddddddd dateTime now ${DateTime.now()}');

      DateTime dateEnd = schedule['to'];
      DateTime dateNow = DateTime.now();

      print('ddddddddddddddd compare ${dateEnd.difference(dateNow)}');
      print('ddddddddddddddd compare ${dateEnd.isBefore(dateNow)}');

      if (dateEnd.isAfter(dateNow)) {
        checkShowModalAppointment = !checkShowModalAppointment;
      }
    } else {
      timeBegin = TimeOfDay(
        hour: _details.date.hour,
        minute: _details.date.minute,
      );
      timeEnd = TimeOfDay(
        hour: _details.date.hour + 1,
        minute: _details.date.minute,
      );
      Modular.to.pushNamed('/schedule/time-register');
    }
  }

  void saveSchedule({
    BuildContext context,
    int totalVacancies,
    availableVacancies,
    occupiedVacancies,
  }) async {
    circularIndicator = true;
    DocumentSnapshot _doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.viewDoctorId)
        .get();
    ScheduleModel _schedule = ScheduleModel(
      date: Timestamp.fromDate(DateTime(
        dateSelected.year,
        dateSelected.month,
        dateSelected.day,
        timeBegin.hour,
        timeBegin.minute,
      )),
      doctorId: _doctor.id,
      endHour: Timestamp.fromDate(DateTime(
        dateSelected.year,
        dateSelected.month,
        dateSelected.day,
        timeEnd.hour,
        timeEnd.minute,
      )),
      startHour: Timestamp.fromDate(DateTime(
        dateSelected.year,
        dateSelected.month,
        dateSelected.day,
        timeBegin.hour,
        timeBegin.minute,
      )),
      status: 'CREATED',
      type: appointmentType == 'Hora marcada' ? 'DEFAULT' : 'QUEUE',
      totalVacancies: totalVacancies,
      avaliableVacancies: availableVacancies,
      occupiedVacancies: occupiedVacancies,
    );
    // var val;
    await FirebaseFirestore.instance
        .collection('doctors')
        .doc(_schedule.doctorId)
        .collection('schedules')
        .add(ScheduleModel().toJson(_schedule))
        .then((value) {
      _schedule.id = value.id;
      value.update({
        'created_at': FieldValue.serverTimestamp(),
        'id': value.id,
      });
      // val = value.get();
    });
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(_schedule.id)
        .set(ScheduleModel().toJson(_schedule));
    await FirebaseFirestore.instance
        .collection('schedules')
        .doc(_schedule.id)
        .update({"created_at": FieldValue.serverTimestamp()});
    circularIndicator = false;
    Modular.to.pop();
  }

  void deleteSchedule(String justification) async {
    HttpsCallable cancelSchedulesNotify =
        FirebaseFunctions.instance.httpsCallable('cancelSchedulesNotify');
    try {
      print('no try');
      await cancelSchedulesNotify.call({
        'scheduleId': schedule['id'],
        'justification': justification,
      });
      print('Notificação enviada');
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e);
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
    loadCircular = false;
    Modular.to.pop();
  }

  @action
  Future<bool> fitPatient(BuildContext context) async {
    bool isDependent = patientSelected.type == 'DEPENDENT';
    QuerySnapshot appointmentVerify;
    bool hasFitRequested = false;
    bool hasAppointment = false;
    snapCircular = true;
    String _dependentId;
    String _titularId;

    if (isDependent) {
      print('é dependente');
      _dependentId = patientSelected.id;
      _titularId = patientSelected.responsibleId;
    } else {
      _titularId = patientSelected.id;
    }

    print('_titularId id: $_titularId');

    DocumentSnapshot _titular = await FirebaseFirestore.instance
        .collection('patients')
        .doc(_titularId)
        .get();

    appointmentVerify = isDependent
        ? await _titular.reference
            .collection('appointments')
            .where('schedule_id', isEqualTo: schedule['id'])
            .where('dependent_id', isEqualTo: _dependentId)
            .get()
        : await _titular.reference
            .collection('appointments')
            .where('schedule_id', isEqualTo: schedule['id'])
            .where('patient_id', isEqualTo: _titularId)
            .get();

    for (var i = 0; i < appointmentVerify.docs.length; i++) {
      DocumentSnapshot appointmentDoc = appointmentVerify.docs[i];
      if ((!isDependent && appointmentDoc['dependent_id'] == null) ||
          isDependent) {
        if (appointmentDoc['status'] == 'SCHEDULED') {
          hasAppointment = true;
          break;
        }

        if (appointmentDoc['status'] == 'FIT_REQUESTED') {
          hasFitRequested = true;
          break;
        }
      }
    }

    if (patientSelected == null) {
      Fluttertoast.showToast(
          msg: 'Selecione um paciente', backgroundColor: Colors.red[400]);
      print('Selecione um paciente');
      snapCircular = false;
      return false;
    } else if (hasAppointment) {
      print('Tem agendamentooooooooooooooooo');
      Fluttertoast.showToast(
        msg: 'Este paciente já está cadastrado neste horário.',
      );
      snapCircular = false;
      return false;
    } else if (hasFitRequested) {
      print('Tem fitttttttttttttttttttttttt');
      Fluttertoast.showToast(
        msg: 'Esse paciente já está convidado para este horário.',
      );
      snapCircular = false;
      return false;
    } else {
      DocumentSnapshot _doctor = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(mainStore.authStore.viewDoctorId)
          .get();
      AppointmentModel _appointment = AppointmentModel(
        createdAt: Timestamp.now(),
        date: Timestamp.fromDate(dateSelected),
        doctorId: _doctor.id,
        endHour: Timestamp.fromDate(DateTime(
          dateSelected.year,
          dateSelected.month,
          dateSelected.day,
          timeEnd.hour,
          timeEnd.minute,
        )),
        hour: Timestamp.fromDate(DateTime(
          dateSelected.year,
          dateSelected.month,
          dateSelected.day,
          timeBegin.hour,
          timeBegin.minute,
        )),
        patientId: patientSelected.type == 'DEPENDENT'
            ? patientSelected.responsibleId
            : patientSelected.id,
        price: _doctor['price'].toDouble(),
        scheduleId: schedule['id'],
        status: 'FIT_REQUESTED',
        type: 'FIT',
        dependentId:
            patientSelected.type == 'DEPENDENT' ? patientSelected.id : null,
        contact: patientSelected.phone,
        firstVisit: false,
        covidSymptoms: false,
        note: null,
        patientName: patientSelected.username,
        rated: false,
        canceledByDoctor: false,
        rescheduled: false,
      );

      await _titular.reference
          .collection('appointments')
          .add(AppointmentModel().toJson(_appointment))
          .then((value) {
        value.update({
          'id': value.id,
        });
        _appointment.id = value.id;
      });

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(_appointment.id)
          .set(AppointmentModel().toJson(_appointment));

      print(
          'mainStore.authStore.viewDoctorId: ${mainStore.authStore.viewDoctorId}');
      print('_titular.id: ${_titular.id}');

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('fitNotification');
      try {
        callable.call(<String, dynamic>{
          'receiverCollection': 'patients',
          'senderId': mainStore.authStore.viewDoctorId,
          'receiverId': _titular.id,
          'appointmentId': _appointment.id,
        });
      } on FirebaseFunctionsException catch (e) {
        print('caught firebase functions exception');
        print(e);
        print(e.code);
        print(e.message);
        print(e.details);
      } catch (e) {
        print('caught generic exception');
        print(e);
      }
      snapCircular = false;
      patients.clear();
      Modular.to.pop();
      return true;
    }
  }

  void searchPatient(String text) {
    patientSearchKey = text;
    patientsSearched.clear();
    patients.forEach((_patient) {
      if ((_patient.phone != null &&
              _patient.phone.toLowerCase().contains(text.toLowerCase())) ||
          (_patient.cpf != null &&
              _patient.cpf.toLowerCase().contains(text.toLowerCase()))) {
        // print('aaaaaaaaaaaaaaaa ');
        patientsSearched.add(_patient);
      }
    });
    patients.sort((a, b) {
      String aUserName = a.username ?? a.fullname;
      String bUserName = b.username ?? b.fullname;
      return aUserName.toLowerCase().compareTo(bUserName.toLowerCase());
    });
    // print(patientsSearched.length);
    setSearchAddPatientHeight();
  }
}
