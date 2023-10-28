import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
part 'profile_store.g.dart';

class ProfileStore = _ProfileStoreBase with _$ProfileStore;

abstract class _ProfileStoreBase with Store {
  final MainStore mainStore = Modular.get();
  @observable
  bool visibleProfileManager = false;
  @observable
  String doctorName = '';
  @observable
  bool logout = false,
      boolChooseDoctor = false,
      deleteProfileDialog = false,
      haveDeleteProfile = false;
  @observable
  DocumentSnapshot supportDoc;
  @observable
  QuerySnapshot messagesDocs;
  @observable
  ObservableList chat = [].asObservable();
  @observable
  bool editProfileAllowed = false;
  @observable
  bool secretariesAllowed = false;
  @observable
  bool preferencesAllowed = false;

  @observable
  String newNotifications = '', newRatings = '', supportNotifications = '';
  @observable
  QuerySnapshot cardsQuery,
      secretariesQuery,
      feedQuery,
      ratingsQuery,
      schedulesQuery,
      transactionsQuery;
  @observable
  ObservableList notificationNotVisualized = [].asObservable();
  @observable
  ObservableList notificationVisualized = [].asObservable();
  @observable
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>> listenSecretaryDoc;

  Future<void> viewedNotifications() async {
    if (mainStore.authStore.viewDoctorId != null) {
      QuerySnapshot notifications = await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiver_id', isEqualTo: mainStore.authStore.user.uid)
          .where('status', isEqualTo: 'SENDED')
          .get();

      notifications.docs.forEach((DocumentSnapshot notificationDoc) {
        if (!notificationDoc['viewed']) {
          notificationDoc.reference.update({'viewed': true});
        }
      });

      QuerySnapshot userNotifications = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(mainStore.authStore.viewDoctorId)
          .collection('notifications')
          .where('status', isEqualTo: 'SENDED')
          .get();

      userNotifications.docs.forEach((DocumentSnapshot notificationDoc) {
        if (!notificationDoc['viewed']) {
          notificationDoc.reference.update({'viewed': true});
        }
      });
    } else {
      QuerySnapshot notifications = await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiver_id', isEqualTo: mainStore.authStore.user.uid)
          .where('status', isEqualTo: 'SENDED')
          .get();

      notifications.docs.forEach((DocumentSnapshot notificationDoc) {
        if (!notificationDoc['viewed']) {
          notificationDoc.reference.update({'viewed': true});
        }
      });

      QuerySnapshot userNotifications = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(mainStore.authStore.user.uid)
          .collection('notifications')
          .where('status', isEqualTo: 'SENDED')
          .get();

      userNotifications.docs.forEach((DocumentSnapshot notificationDoc) {
        if (!notificationDoc['viewed']) {
          notificationDoc.reference.update({'viewed': true});
        }
      });
    }

    notificationNotVisualized.clear();
    notificationVisualized.clear();
  }

  void getNotifications(QuerySnapshot secretaryNotifications,
      QuerySnapshot doctorNotifications) async {
    notificationNotVisualized.clear();
    notificationVisualized.clear();
    print(
        'xxxxxxxx getNotifications ${secretaryNotifications.docs.length} xxxxxxxxx');
    List visualized = [];
    List notVisualized = [];
    if (mainStore.authStore.viewDoctorId != mainStore.authStore.user.uid) {
      for (var i = 0; i < secretaryNotifications.docs.length; i++) {
        DocumentSnapshot notificationDoc = secretaryNotifications.docs[i];
        print(
            'xxxxxxxx for ${notificationDoc['viewed']} - ${notificationDoc.id} xxxxxxxxx');

        if (notificationDoc['viewed']) {
          print('xxxxxxxx addd 1 xxxxxxxxx');

          visualized.add(notificationDoc);
          // notificationVisualized.add(notificationDoc);
        } else {
          print('xxxxxxxx addd 2 xxxxxxxxx');

          notVisualized.add(notificationDoc);
          // notificationNotVisualized.add(notificationDoc);
        }
      }
    }

    for (var i = 0; i < doctorNotifications.docs.length; i++) {
      DocumentSnapshot notificationDoc = doctorNotifications.docs[i];
      print(
          'xxxxxxxx for ${notificationDoc['viewed']} - ${notificationDoc.id} xxxxxxxxx');

      if (notificationDoc['viewed']) {
        print('xxxxxxxx addd 1 xxxxxxxxx');

        visualized.add(notificationDoc);
        // notificationVisualized.add(notificationDoc);
      } else {
        print('xxxxxxxx addd 2 xxxxxxxxx');

        notVisualized.add(notificationDoc);
        // notificationNotVisualized.add(notificationDoc);
      }
    }
    visualized.sort((a, b) {
      return b['dispatched_at'].compareTo(a['dispatched_at']);
    });
    notVisualized.sort((a, b) {
      return b['dispatched_at'].compareTo(a['dispatched_at']);
    });
    notificationVisualized = visualized.asObservable();
    notificationNotVisualized = notVisualized.asObservable();
  }

  void getNotificationsSecretary(QuerySnapshot notifications) async {
    notificationNotVisualized.clear();
    notificationVisualized.clear();
    print('xxxxxxxx getNotifications ${notifications.docs.length} xxxxxxxxx');

    for (var i = 0; i < notifications.docs.length; i++) {
      DocumentSnapshot notificationDoc = notifications.docs[i];
      print(
          'xxxxxxxx for ${notificationDoc['viewed']} - ${notificationDoc.id} xxxxxxxxx');

      if (notificationDoc['viewed']) {
        print('xxxxxxxx addd 1 xxxxxxxxx');

        notificationVisualized.add(notificationDoc);
      } else {
        print('xxxxxxxx addd 2 xxxxxxxxx');

        notificationNotVisualized.add(notificationDoc);
      }
    }
  }

  void getRatingNotifications(DocumentSnapshot doctorDoc) {
    print("doctorDoc['new_ratings']: ${doctorDoc['new_ratings']}");
    if (doctorDoc['new_ratings'] != null && doctorDoc['new_ratings'] != 0) {
      print("Rating não é nulo nem zero");
      newRatings = doctorDoc['new_ratings'] <= 9
          ? doctorDoc['new_ratings'].toString()
          : '+9';
    } else {
      print("Rating  é nulo ou zero");
      newRatings = '';
    }
    print("newRatings: $newRatings");
  }

  setUserNotifications(DocumentSnapshot ds) {
    supportNotifications =
        ds['support_notifications'] != null && ds['support_notifications'] != 0
            ? ds['support_notifications'] <= 9
                ? ds['support_notifications'].toString()
                : '+9'
            : '';

    newNotifications =
        ds['new_notifications'] != null && ds['new_notifications'] != 0
            ? ds['new_notifications'] <= 9
                ? ds['new_notifications'].toString()
                : '+9'
            : '';
  }

  getPermissions(AsyncSnapshot snapermissions) {
    QuerySnapshot permissions;
    if (snapermissions.hasData) {
      permissions = snapermissions.data;
      permissions.docs.forEach((element) {
        if (element.get('label') == 'SECRETARIES' &&
            element.get('value') == true) {
          secretariesAllowed = true;
        } else if (element.get('label') == 'SECRETARIES' &&
            element.get('value') == false) {
          secretariesAllowed = false;
        }
        if (element.get('label') == 'PROFILE' && element.get('value') == true) {
          editProfileAllowed = true;
        } else if (element.get('label') == 'PROFILE' &&
            element.get('value') == false) {
          editProfileAllowed = false;
        }
        if (element.get('label') == 'PREFERENCES' &&
            element.get('value') == true) {
          preferencesAllowed = true;
        } else if (element.get('label') == 'PREFERENCES' &&
            element.get('value') == false) {
          preferencesAllowed = false;
        }
      });
    }
  }

  void getDeleteProfile() async {
    Timer.periodic(Duration(seconds: 2), (Timer timer) async {
      if (mainStore.authStore.user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(mainStore.authStore.user.uid)
            .get();

        if (userDoc != null) {
          if (userDoc['type'] == 'DOCTOR') {
            QuerySnapshot _cards =
                await userDoc.reference.collection('cards').get();
            QuerySnapshot _feed =
                await userDoc.reference.collection('feed').get();
            QuerySnapshot _ratings =
                await userDoc.reference.collection('ratings').get();
            QuerySnapshot _schedules =
                await userDoc.reference.collection('schedules').get();
            QuerySnapshot _transactions =
                await userDoc.reference.collection('transactions').get();
            QuerySnapshot _secretaries =
                await userDoc.reference.collection('secretaries').get();

            bool haveCards = _cards.docs.isEmpty;
            bool haveFeed = _feed.docs.isEmpty;
            bool haveRatings = _ratings.docs.isEmpty;
            bool haveSchedules = _schedules.docs.isEmpty;
            bool haveTransactions = _transactions.docs.isEmpty;
            bool haveSecretaries = _secretaries.docs.isEmpty;

            haveDeleteProfile = haveCards &&
                haveFeed &&
                haveRatings &&
                haveSchedules &&
                haveTransactions &&
                haveSecretaries;
          } else {
            haveDeleteProfile = userDoc['doctor_id'] == null;
          }
        }
      }
    });
  }

  void deletingProfile() async {
    DocumentSnapshot user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();

    await user.reference.update({
      'about_me': null,
      'academic_education': null,
      'address': null,
      'address_keys': null,
      'attendance': null,
      'avatar': null,
      'birthday': null,
      'cep': null,
      'city': null,
      'clinic_name': null,
      'complement_address': null,
      'connected': true,
      'country': 'Brasil',
      'cpf': null,
      'crm': null,
      'doctor_id': null,
      'doctor_is_premium': false,
      'email': null,
      'experience': null,
      'fullname': null,
      'gender': null,
      'invitation_to_position': null,
      'landline': null,
      'language': null,
      'medical_conditions': null,
      'neighborhood': null,
      'nre_notifications': null,
      'new_ratings': 0,
      'notification_disabled': false,
      'number_address': null,
      'phone': mainStore.authStore.user.phoneNumber,
      'price': 0.0,
      'return_period': 30,
      'rqe': null,
      'social': null,
      'speciality': null,
      'speciality_name': null,
      'state': null,
      'type': null,
      'username': mainStore.authStore.user.phoneNumber.toString(),
    });

    await mainStore.authStore.getUserType();
    deleteProfileDialog = false;
    Modular.to.pop();
  }

  @action
  getSuportChat(String id) async {
    supportDoc =
        await FirebaseFirestore.instance.collection('support').doc(id).get();

    messagesDocs = await supportDoc.reference.collection('messages').get();

    Stream<QuerySnapshot> msgs = FirebaseFirestore.instance
        .collection('support')
        .doc(id)
        .collection('messages')
        .orderBy('created_at', descending: false)
        .snapshots();
    msgs.listen((event) {
      event.docs.forEach((element) {
        chat.add(element);
      });
    });
  }

  Future<void> setTokenLogout() async {
    String token = await FirebaseMessaging.instance.getToken();
    print('user token: $token');
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();

    List tokens = _user['token_id'];
    print('tokens length: ${tokens.length}');

    for (var i = 0; i < tokens.length; i++) {
      if (tokens[i] == token) {
        print('has $token');
        tokens.removeAt(i);
        print('tokens: $tokens');
      }
    }
    print('tokens2: $tokens');
    _user.reference.update({'token_id': tokens});

    if (_user['type'] == 'SECRETARY') {
      if (_user['doctor_id'] != null) {
        DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(_user['doctor_id'])
            .get();

        doctorDoc.reference
            .update({'token_id': FieldValue.arrayRemove(_user['token_id'])});
      }
    }
  }

  @action
  confirmDoctor({String doctorId, bool accept}) async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();

    DocumentSnapshot doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    DocumentSnapshot secretary = await doctor.reference
        .collection('secretaries')
        .doc(mainStore.authStore.user.uid)
        .get();

    if (accept) {
      String token = await FirebaseMessaging.instance.getToken();

      print('tokenId secretary: $token');

      doctor.reference.update({
        'token_id': FieldValue.arrayUnion([token])
      });

      boolChooseDoctor = false;

      int newNotifications =
          doctor['new_notifications'] != null ? doctor['new_notifications'] : 0;

      int newRatings =
          doctor['new_ratings'] != null ? doctor['new_ratings'] : 0;

      await _user.reference.update({
        'doctor_id': doctorId,
        'invitation_to_position': null,
        'doctor_is_premium': doctor['premium'],
        'new_notifications': FieldValue.increment(newNotifications),
        'new_ratings': FieldValue.increment(newRatings),
      });

      await secretary.reference.update({'status': 'ACCEPTED'});

      mainStore.authStore.viewDoctorId = doctorId;

      print('chegou aqui 1');

      Modular.to.pop();
    } else {
      boolChooseDoctor = false;

      await _user.reference.update({'invitation_to_position': null});

      await secretary.reference.delete();
      // await Future.delayed(Duration(microseconds: 500));

      print('chegou aqui 2');

      Modular.to.pop();
    }
    HttpsCallable callable =
        FirebaseFunctions.instance.httpsCallable('notifyUser');
    // let = [text, senderId, receiverId, collection]

    print('NotifyUser: $callable');

    try {
      print(
        accept
            ? 'O secretário ${_user.get('username')} aceitou o convite para ser seu secretário!'
            : 'O secretário ${_user.get('username')} recusou o convite para ser seu secretário!',
      );
      callable.call(
        <String, dynamic>{
          'text': accept
              ? 'O secretário ${_user.get('username')} aceitou o convite para ser seu secretário!'
              : 'O secretário ${_user.get('username')} recusou o convite para ser seu secretário!',
          'senderId': _user.id,
          'receiverId': doctorId,
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

  getChooseDoctor({String secretaryId}) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> streamSecretary =
        FirebaseFirestore.instance
            .collection('doctors')
            .doc(secretaryId)
            .snapshots();

    listenSecretaryDoc =
        streamSecretary.listen((DocumentSnapshot secretaryDoc) async {
      print('event: inicio${secretaryDoc.get('invitation_to_position')}');
      if (secretaryDoc.get('invitation_to_position') != null &&
          !boolChooseDoctor) {
        boolChooseDoctor = true;

        DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(secretaryDoc['invitation_to_position'])
            .get();

        doctorName = await doctorDoc['username'];

        Modular.to.pushNamed('/choose-doctor',
            arguments: secretaryDoc['invitation_to_position']);
      } else if (secretaryDoc['invitation_to_position'] == null &&
          boolChooseDoctor) {
        Modular.to.pop();
        boolChooseDoctor = false;
      }
    });
  }

  @action
  Future<DoctorModel> getDoctorModel() async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();

    DocumentSnapshot doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(_user['doctor_id'])
        .get();

    DoctorModel doctorModel = DoctorModel.fromDocument(doctor);
    return doctorModel;
  }
}
