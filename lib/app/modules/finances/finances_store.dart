import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/transaction_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'package:mobx/mobx.dart';

part 'finances_store.g.dart';

class FinancesStore = _FinancesStoreBase with _$FinancesStore;

abstract class _FinancesStoreBase with Store {
  _FinancesStoreBase() {
    print('finances store');
    mainStore.getTansactions();
  }

  @observable
  MainStore mainStore = Modular.get();
  @observable
  String avatar;

  @observable
  FinancialModel transaction;

  @action
  setTransaction(DocumentSnapshot trsc) =>
      transaction = FinancialModel.fromDocument(trsc.data());

  String getDate(Timestamp date) {
    List monthList = [
      '',
      'Janeiro',
      'Feverreiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro'
    ];
    if (date != null) {
      DateTime dateTime = date.toDate();

      String day = dateTime.day.toString().padLeft(2, '0');

      String month = monthList[dateTime.month];

      if (month.length > 5) {
        month = month.substring(0, 3);
      }
      return '$day de $month';
    } else {
      return '';
    }
  }

  @action
  Future approveReversal(
      {String transactionId, String patientId, String doctorId}) async {
    print('id: $transactionId,  ptId: $patientId,  drId: $doctorId, ');

    DocumentSnapshot transactionDoc = await FirebaseFirestore.instance
        .collection('transactions')
        .doc(transactionId)
        .get();

    transactionDoc.reference.update({'status': 'PENDING_REFUND'});

    DocumentSnapshot patientDoc = await FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId)
        .get();

    avatar = patientDoc['avatar'];

    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    DocumentSnapshot patientTransactionDoc = await patientDoc.reference
        .collection('transactions')
        .doc(transactionId)
        .get();

    DocumentSnapshot doctorTransactionDoc = await doctorDoc.reference
        .collection('transactions')
        .doc(transactionId)
        .get();

    await patientTransactionDoc.reference.update({
      'status': 'PENDING_REFUND',
    });

    await doctorTransactionDoc.reference.update({
      'status': 'PENDING_REFUND',
    });

    DocumentSnapshot appointmentDoc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(transactionDoc['appointment_id'])
        .get();

    await appointmentDoc.reference.update({
      'status': 'CANCELED',
    });

    await patientDoc.reference
        .collection('appointments')
        .doc(transactionDoc['appointment_id'])
        .update({
      'status': 'CANCELED',
    });

    DocumentSnapshot scheduleDoctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(appointmentDoc['doctor_id'])
        .collection('schedules')
        .doc(appointmentDoc['schedule_id'])
        .get();

    DocumentSnapshot scheduleDoc = await FirebaseFirestore.instance
        .collection('schedules')
        .doc(appointmentDoc['schedule_id'])
        .get();

    await scheduleDoctorDoc.reference.update({
      'occupied_vacancies': (scheduleDoctorDoc['occupied_vacancies'] - 1),
    });

    await scheduleDoc.reference.update({
      'occupied_vacancies': (scheduleDoc['occupied_vacancies'] - 1),
    });

    if (appointmentDoc['type'] != 'FIT') {
      await scheduleDoctorDoc.reference.update({
        'available_vacancies': (scheduleDoctorDoc['available_vacancies'] + 1),
      });
      await scheduleDoc.reference.update({
        'available_vacancies': (scheduleDoc['available_vacancies'] + 1),
      });
    }
  }
}
