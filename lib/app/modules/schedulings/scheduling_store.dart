import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/patient_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/appointment_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'scheduling_store.g.dart';

class SchedulingStore = _SchedulingStoreBase with _$SchedulingStore;

abstract class _SchedulingStoreBase with Store {
  final MainStore mainStore = Modular.get();
  @observable
  bool showMenuFilter = false, concludedBuild = false;

  @observable
  int appointmentPage = 1;

  @observable
  List listAppointments;

  void viewConsulationDetail(DocumentSnapshot doc) {
    AppointmentModel appointmentModel =
        AppointmentModel.fromDocumentSnapshot(doc);

    Modular.to.pushNamed('/consulation-detail', arguments: appointmentModel);
  }

  void viewPatientProfile(String patientId) async {
    print('patientModel==============: $patientId');

    DocumentSnapshot docPatient = await FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId)
        .get();

    PatientModel patientModel = PatientModel.fromDocument(docPatient);
    print('patientModel: $patientModel');
    Modular.to.pushNamed('/patient-profile', arguments: patientModel);
  }

  void getListAppointments(QuerySnapshot qs) {
    // int documentsLength = 0;
    List<DocumentSnapshot> awaitingList = [];

    for (var i = 0; i < qs.docs.length; i++) {
      DocumentSnapshot ds = qs.docs[i];
      if (ds['status'] == 'AWAITING') {
        // documentsLength += 1;
        awaitingList.add(ds);
        // print('fooooooooooooor inicial $documentsLength');
      }
    }

    List newList = [];
    switch (appointmentPage) {
      case 1:
        qs.docs.forEach((DocumentSnapshot ds) {
          if (ds['status'] == 'SCHEDULED') {
            newList.add(ds);
          }
        });

        // newList.sort((a, b) {
        //   return a['hour'].compareTo(b['hour']);
        // });
        break;

      case 2:
        // print('caaaaaaaaaaaaase 2');
        String scheduleID;
        List<DocumentSnapshot> appointmentsQueue;
        for (var index1 = 0; index1 < awaitingList.length; index1++) {
          DocumentSnapshot appointmentDoc = awaitingList[index1];
          if (appointmentDoc['status'] == 'AWAITING') {
            // print(
            //     '%%%%%%%%%%% qs forEach ${appointmentDoc['schedule_id']} == $scheduleID');
            if (scheduleID == appointmentDoc['schedule_id']) {
              // print('%%%%%%%%%%%%%%%% if');
              appointmentsQueue.add(appointmentDoc);

              // print('%%%%%%%%%%%%%%%% if $index1 - ${awaitingList.length}');

              if (index1 == awaitingList.length - 1) {
                appointmentsQueue.sort((a, b) {
                  return a['date'].compareTo(b['date']);
                });

                for (var index2 = 0;
                    index2 < appointmentsQueue.length;
                    index2++) {
                  // print('%%%%%%%%%%%%%%%% for $index2');

                  DocumentSnapshot ds = appointmentsQueue[index2];

                  // print(
                  //     '%%%%%%%%%%%%%%%% newList.contains(ds) ${newList.contains(ds)}');

                  if (newList.contains(ds)) {
                    newList.remove(ds);
                  }

                  newList.add(ds);
                }
              }
            } else {
              // print('%%%%%%%%%%%%%%%% else $appointmentsQueue');

              // if (appointmentsQueue != null) {
              // print('%%%%%%%%%%%%%%%% else ${appointmentsQueue.length}');
              // }

              if (appointmentsQueue != null && appointmentsQueue.length > 1) {
                appointmentsQueue.sort((a, b) {
                  return a['date'].compareTo(b['date']);
                });

                for (var i = 0; i < appointmentsQueue.length; i++) {
                  // print('%%%%%%%%%%%%%%%% for $i');

                  DocumentSnapshot ds = appointmentsQueue[i];

                  // print(
                  //     '%%%%%%%%%%%%%%%% newList.contains(ds) ${newList.contains(ds)}');

                  if (newList.contains(ds)) {
                    newList.remove(ds);
                  }

                  newList.add(ds);
                }
              }

              appointmentsQueue = null;
              scheduleID = appointmentDoc['schedule_id'];
              appointmentsQueue = [appointmentDoc];
              newList.add(appointmentDoc);
            }

            // newList.add(ds);
          }
        }

        break;

      case 3:
        qs.docs.forEach((DocumentSnapshot ds) {
          if (ds['status'] != 'AWAITING' &&
              ds['status'] != 'SCHEDULED' &&
              ds['status'] != 'FIT_REQUESTED') {
            newList.add(ds);
          }
        });

        // newList.sort((a, b) {
        //   return a['hour'].compareTo(b['hour']);
        // });
        break;

      case 4:
        qs.docs.forEach((DocumentSnapshot ds) {
          if (ds['status'] == 'CANCELED' || ds['status'] == 'REFUSED') {
            newList.add(ds);
          }
        });

        // newList.sort((a, b) {
        //   return a['hour'].compareTo(b['hour']);
        // });
        break;

      default:
        break;
    }

    print('FIM');
    listAppointments = newList;
    // functionInProgress = false;
    // }
  }

  @action
  String getDate(Timestamp date) {
    List<String> listDay = [
      '',
      'Segunda',
      'Terça',
      'Quarta',
      'Quinta',
      'Sexta',
      'Sábado',
      'Domingo'
    ];

    List<String> listMonth = [
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
      'Dezembro',
    ];

    String day = listDay[date.toDate().weekday];
    String month = listMonth[date.toDate().month];

    return '$day, ${date.toDate().day} de $month de ${date.toDate().year}';
  }
}
