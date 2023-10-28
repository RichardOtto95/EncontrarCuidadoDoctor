import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/appointment_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/load_circular_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
part 'consultations_store.g.dart';

class ConsultationsStore = _ConsultationsStoreBase with _$ConsultationsStore;

abstract class _ConsultationsStoreBase with Store {
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  @observable
  bool cancelConsultation = false;
  @observable
  bool checkIn = false;
  @observable
  bool allowed = false;
  @observable
  OverlayEntry confirmOverlay;

  @action
  Future<void> checkingIn(
      AppointmentModel appointmentModel, BuildContext context) async {
    num percent = appointmentModel.price * 0.7;

    FirebaseFunctions functions = FirebaseFunctions.instance;

    HttpsCallable callableSecurityDeposit =
        functions.httpsCallable('securityDeposit');

    HttpsCallableResult<String> error = await callableSecurityDeposit.call({
      'patientId': appointmentModel.patientId,
      'doctorId': mainStore.authStore.viewDoctorId,
      'appointmentId': appointmentModel.id,
      'price': percent,
      'remaining': true,
    });

    if (error.data != null) {
      String text = 'Não foi possível efetuar o pagamento.';

      flutterToast(text);
    } else {
      await changeStatus(appointmentModel, 'AWAITING', context);
    }
  }

  void viewPatientProfile(String userId) async {
    DocumentSnapshot docPatient = await FirebaseFirestore.instance
        .collection('patients')
        .doc(userId)
        .get();

    PatientModel patientModel = PatientModel.fromDocument(docPatient);
    Modular.to.pushNamed('/patient-profile', arguments: patientModel);
  }

  Future changeStatus(
    AppointmentModel _appointment,
    String status,
    BuildContext context,
  ) async {
    OverlayEntry loadOverlay;
    loadOverlay = OverlayEntry(builder: (context) => LoadCircularOverlay());
    Overlay.of(context).insert(loadOverlay);
    DocumentSnapshot docAppointment = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(_appointment.id)
        .get();

    DocumentSnapshot docPatientAppointment = await FirebaseFirestore.instance
        .collection('patients')
        .doc(docAppointment['patient_id'])
        .collection('appointments')
        .doc(_appointment.id)
        .get();

    if (status == 'CANCELED') {
      DocumentSnapshot scheduleDoctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(docAppointment['doctor_id'])
          .collection('schedules')
          .doc(docAppointment['schedule_id'])
          .get();

      DocumentSnapshot scheduleDoc = await FirebaseFirestore.instance
          .collection('schedules')
          .doc(docAppointment['schedule_id'])
          .get();

      await scheduleDoctorDoc.reference.update({
        'occupied_vacancies': (scheduleDoctorDoc['occupied_vacancies'] - 1),
      });

      await scheduleDoc.reference.update({
        'occupied_vacancies': (scheduleDoc['occupied_vacancies'] - 1),
      });

      if (_appointment.type != 'FIT') {
        await scheduleDoctorDoc.reference.update({
          'available_vacancies': (scheduleDoctorDoc['available_vacancies'] + 1),
        });
        await scheduleDoc.reference.update({
          'available_vacancies': (scheduleDoc['available_vacancies'] + 1),
        });
      }
    }

    await docPatientAppointment.reference.update({
      'status': status,
      'date': FieldValue.serverTimestamp(),
      'canceled_by_doctor': status == "CANCELED",
    });

    await docAppointment.reference.update({
      'status': status,
      'date': FieldValue.serverTimestamp(),
      'canceled_by_doctor': status == "CANCELED",
    });

    // FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);

    HttpsCallable callableCheckin =
        FirebaseFunctions.instance.httpsCallable('checkinNotification');

    try {
      Timestamp endHour = docAppointment['end_hour'];
      int seconds = endHour.seconds;
      int nanoseconds = endHour.nanoseconds;
      print(seconds);
      print(nanoseconds);
      print('no try');
      // String text = status == 'waiting'
      //     ? 'Checkin realizado!'
      //     : 'Consulta cancelada pelo médico!';
      callableCheckin.call({
        'senderId': authStore.viewDoctorId,
        'receiverId': _appointment.patientId,
        'status': status,
        'endHour': {
          'seconds': seconds,
          'nanoseconds': nanoseconds,
        }
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
    if (loadOverlay != null) {
      loadOverlay.remove();
    }
    if (confirmOverlay != null) {
      confirmOverlay.remove();
    }
    checkIn = false;
    Modular.to.pop();
  }

  @action
  String getMask(String value) {
    String text = value.substring(0, 3) +
        ' (${value.substring(3, 5)}) ' +
        '${value.substring(5, 10)}-' +
        value.substring(10, 14);

    return text;
  }

  @action
  String getDate(Timestamp timestamp) {
    DateTime _hour = timestamp.toDate();

    String hourAndMinute = _hour.hour.toString().padLeft(2, '0') +
        ':' +
        _hour.minute.toString().padLeft(2, '0');

    String date = _hour.day.toString().padLeft(2, '0') +
        '/' +
        _hour.month.toString().padLeft(2, '0') +
        '/' +
        _hour.year.toString();

    return hourAndMinute + ' • ' + date;
  }
}

void flutterToast(String text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff41C3B3),
      textColor: Colors.black,
      fontSize: 16.0);
}
