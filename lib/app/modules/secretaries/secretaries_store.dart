import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'secretaries_store.g.dart';

class SecretariesStore = _SecretariesStoreBase with _$SecretariesStore;

abstract class _SecretariesStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  String textSearch = '';
  @observable
  List searchSecretaries = [];
  @observable
  bool haveDialog = false;
  @observable
  TextEditingController textEditingController = TextEditingController();
  @observable
  OverlayEntry overlayEntry;
  @observable
  QuerySnapshot secretariesQuery;
  @observable
  bool canShowToast = true;

  @action
  String getTooltip(String txt) {
    Map permissions = {
      'PROFILE': 'Permite alterar informações do perfil do doutor',
      'FEED': 'Permite a publicação, edição e exclusão postagens',
      'SCHEDULINGS':
          'Permite a criação, edição e exclusão de horários na agenda do doutor',
      'CARE': 'Permite a realização check-in e cancelamento de consultas',
      'MESSAGES':
          'Permite, além de ver as conversas, enviar mensagens aos pacientes',
      'PAYMENTS': 'Permite visualizar transações e estornar pagamentos',
      'SECRETARIES': 'Permite gerenciar as permissões dos secretários',
      'PREFERENCES': 'Permite alterar o valor da consulta e o prazo de retorno'
    };

    return permissions[txt];
  }

  @action
  changedSwitch({String index, bool value, String secretaryId}) async {
    QuerySnapshot permissions = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(secretaryId)
        .collection('permissions')
        .get();

    permissions.docs.forEach((permission) {
      if (permission['label'] == index) {
        permission.reference.update({'value': value});
      }
    });
  }

  @action
  confirmAddSecretary({
    dynamic secretary,
  }) async {
    textEditingController.text = '';

    DocumentSnapshot _doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.viewDoctorId)
        .get();

    await _doctor.reference
        .collection('secretaries')
        .doc(secretary['id'])
        .set({'status': 'AWAITING_CONFIRMATION'});

    FirebaseFirestore.instance
        .collection('doctors')
        .doc(secretary['id'])
        .update({'invitation_to_position': mainStore.authStore.viewDoctorId});

    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('notifyUser');
    // let = [text, senderId, receiverId, collection]

    print('NotifyUser: $callable');

    try {
      callable.call(
        <String, dynamic>{
          'text':
              'O doutor ${_doctor.get("username")} está te convidando para ser seu secretário!',
          'senderId': _doctor.id,
          'receiverId': secretary['id'],
          'collection': 'doctors',
        },
      );
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
  }

  void filterSecretaries() {
    if (textSearch == '') {
      searchSecretaries = [];
    } else {
      List<DocumentSnapshot> usersFitered = [];
      secretariesQuery.docs.forEach((DocumentSnapshot _user) {
        print(
            '_user["invitation_to_position"]: ${_user["invitation_to_position"]}');
        print('_user["doctor_id"]: ${_user['doctor_id']}');
        if (_user['invitation_to_position'] == null &&
            _user['doctor_id'] == null) {
          if (_user['phone'].contains(textSearch)) {
            usersFitered.add(_user);
          } else {
            if (_user['cpf'] != null) {
              if (_user['cpf'].contains(textSearch)) {
                usersFitered.add(_user);
              }
            }
          }
        }
      });

      usersFitered.sort((a, b) =>
          a['username'].toLowerCase().compareTo(b['username'].toLowerCase()));
      searchSecretaries = usersFitered;
    }
  }

  @action
  getSecretaries(QuerySnapshot secretaries) async {
    print(
        'xxxxxxxxxxxxxxxx getSecretaries ${secretaries.docs.length} $textSearch xxxxxxxxxxxxxxxx');
    searchSecretaries.clear();
    secretariesQuery = secretaries;
  }

  @action
  String getMask(String text, String type) {
    String newText;
    if (text != null) {
      if (type == 'cpf') {
        newText = text.substring(0, 3) +
            '.' +
            text.substring(3, 6) +
            '.' +
            text.substring(6, 9) +
            '-' +
            text.substring(9, 11);
        return newText;
      } else {
        newText = text.substring(0, 3) +
            ' (' +
            text.substring(3, 5) +
            ') ' +
            text.substring(5, 10) +
            '-' +
            text.substring(10, 14);
        return newText;
      }
    } else {
      return 'vazio';
    }
  }

  @action
  confirmRemoveSecretary({String secretaryId}) async {
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.viewDoctorId)
        .get();

    DocumentSnapshot secretary = await doctorDoc.reference
        .collection('secretaries')
        .doc(secretaryId)
        .get();

    DocumentSnapshot _secretary = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(secretaryId)
        .get();

    doctorDoc.reference
        .update({'token_id': FieldValue.arrayRemove(_secretary['token_id'])});

    QuerySnapshot permissions =
        await _secretary.reference.collection('permissions').get();

    permissions.docs.forEach((permission) {
      permission.reference.update({'value': false});
    });

    int newNotifications;

    if (_secretary['new_notifications'] > doctorDoc['new_notifications']) {
      newNotifications =
          _secretary['new_notifications'] - doctorDoc['new_notifications'];
    } else {
      newNotifications = 0;
    }

    if (secretary['status'] == 'ACCEPTED') {
      _secretary.reference.update({
        'doctor_id': null,
        'doctor_is_premium': false,
        'new_notifications': newNotifications,
        'new_ratings': 0,
      });
      secretary.reference.delete();

      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('notifyUser');

      print('NotifyUser: $callable');

      try {
        callable.call(
          <String, dynamic>{
            'text':
                'O doutor ${doctorDoc.get("username")} te removeu de seus secretários!',
            'senderId': doctorDoc.id,
            'receiverId': secretary.id,
            'collection': 'doctors',
          },
        );
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
    } else {
      _secretary.reference.update({'invitation_to_position': null});
      secretary.reference.delete();
    }
  }
}
