import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
part 'main_store.g.dart';

class MainStore = _MainStoreBase with _$MainStore;

abstract class _MainStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final RootStore rootStore = Modular.get();

  @observable
  int selectedTrunk = 0;
  @observable
  bool showNavigator = true;
  @observable
  String supportId = '';
  @observable
  QuerySnapshot support;
  @observable
  DocumentSnapshot userSnap;
  @observable
  Stream<QuerySnapshot> supportStream;
  @observable
  bool hasSupport = false;
  @observable
  QuerySnapshot info;
  @observable
  bool secretaryEditDoctor = false;
  @observable
  ObservableList transactions = [].asObservable();
  @observable
  num totalAmount = 0;
  @observable
  String trFilter = 'all';
  @observable
  bool notifications = false;
  @observable
  DocumentSnapshot doctorSnap;
  @observable
  bool hasChat = false;
  @observable
  String patientId;
  @observable
  String patAvatar;
  @observable
  DocumentSnapshot profileChat;
  @observable
  String chatName;
  @observable
  bool consultChat = false;
  @observable
  bool emojisShowC = false;
  @observable
  bool allowed;
  @observable
  bool doctorDel = false;
  @observable
  bool premium = false;
  @observable
  QuerySnapshot cardsQuery,
      secretariesQuery,
      feedQuery,
      ratingsQuery,
      schedulesQuery,
      transactionsQuery;
  @observable
  bool signaturePage = false;

  @action
  setFilter(String f) => trFilter = f;
  @action
  setShowNav(bool shw) => showNavigator = shw;
  @action
  setSupportId(String id) => supportId = id;
  @action
  setSelectedTrunk(int value) => selectedTrunk = value;
  _MainStoreBase() {
    setTokenId();
    getUser();
    getInfo();
    getQueries();
  }

  void setTokenId() async {
    if (authStore.user != null) {
      DocumentSnapshot _user = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(authStore.user.uid)
          .get();

      String tokenString = await FirebaseMessaging.instance.getToken();
      print('tokenId: $tokenString');

      // print('xxxxxxxxxxxxxxx _user ${_user.data()} xxxxxxxxxxxxxxxx');
      await _user.reference.update({
        'token_id': FieldValue.arrayUnion([tokenString])
      });

      if (_user['type'] == 'SECRETARY' && _user['doctor_id'] != null) {
        DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(_user['doctor_id'])
            .get();

        // List tokenIdList = doctorDoc['token_id'];

        // if (!tokenIdList.contains(tokenString)) {
        doctorDoc.reference.update({
          'token_id': FieldValue.arrayUnion([tokenString])
        });
        // }
      }
    }
  }

  void logout(String text) async {
    await setTokenLogout();
    await userConnected(false);
    authStore.signout();
    rootStore.selectedTrunk = 1;
    authStore.viewDoctorId = null;
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff21BCCE),
        textColor: Colors.white,
        fontSize: 16.0);
    Modular.to.pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
  }

  Future<void> setTokenLogout() async {
    String token = await FirebaseMessaging.instance.getToken();
    print('user token: $token');
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
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
      DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(_user['doctor_id'])
          .get();

      doctorDoc.reference
          .update({'token_id': FieldValue.arrayRemove(_user['token_id'])});
    }
  }

  getQueries() async {
    getUser();
    if (authStore.type == 'DOCTOR' && userSnap != null) {
      cardsQuery = await userSnap.reference.collection('cards').get();
      secretariesQuery =
          await userSnap.reference.collection('secretaries').get();
      feedQuery = await userSnap.reference.collection('feed').get();
      ratingsQuery = await userSnap.reference.collection('ratings').get();
      schedulesQuery = await userSnap.reference.collection('schedules').get();
      transactionsQuery =
          await userSnap.reference.collection('transactions').get();
    }
  }

  Future<void> clearNotifications() async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();

    _user.reference.update({'new_notifications': 0});

    if (_user['type'] == 'DOCTOR') {
      QuerySnapshot secretariesQuery = await _user.reference
          .collection('secretaries')
          .where('status', isEqualTo: 'ACCEPTED')
          .get();

      secretariesQuery.docs.forEach((secretaryRef) async {
        int count = 0;
        DocumentSnapshot secretaryDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(secretaryRef.id)
            .get();

        QuerySnapshot notificationsSecretary = await secretaryDoc.reference
            .collection('notifications')
            .where('viewed', isEqualTo: false)
            .get();

        count = notificationsSecretary.docs.length;

        secretaryDoc.reference.update({'new_notifications': count});
      });
    } else {
      if (_user['doctor_id'] != null) {
        DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(_user['doctor_id'])
            .get();

        doctorDoc.reference.update({'new_notifications': 0});
      }
    }
  }

  Future<void> userConnected(bool connected) async {
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();

    await _user.reference.update({'connected': connected});

    if (_user['type'] == 'SECRETARY' && _user['doctor_id'] != null) {
      DocumentSnapshot _doctor = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(_user['doctor_id'])
          .get();

      _doctor.reference.update({'connected_secretary': connected});
    }
  }

  @action
  Future<List<num>> getInitialValues() async {
    List<num> listNum = [];
    if (authStore.viewDoctorId != null) {
      DocumentSnapshot _doctor = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(authStore.viewDoctorId)
          .get();

      listNum.add(_doctor['return_period']);
      listNum.add(_doctor['price']);
      return listNum;
    } else {
      return listNum;
    }
  }

  void getPopUps(DocumentSnapshot _userDoc) {
    print(
        'xxxxxxxxxxxxx getPopUps ${_userDoc['type']} ${_userDoc['doctor_id']} xxxxxxxxxxxxxxxxxx');
    if (_userDoc['type'] == null) {
      print('xxxxxxxxxxxxx if ${Modular.to.path} xxxxxxxxxxxxxxxxxx');

      if (Modular.to.path != '/choose-type') {
        Modular.to.pushNamed('/choose-type');
      }
    } else {
      if (_userDoc['type'] == 'DOCTOR') {
        premium = _userDoc['premium'];
        if (!premium) {
          print(
              'xxxxxxxxxxxxx premium false ${Modular.to.path} xxxxxxxxxxxxxxxxxx');

          if (Modular.to.path != '/signature/edit-profile' &&
              Modular.to.path != '/signature' &&
              Modular.to.path != '/signature/add-card' &&
              Modular.to.path != '/signature/' &&
              !signaturePage) {
            signaturePage = true;
            print('xxxxxxxxxxxxx if $signaturePage xxxxxxxxxxxxxxxxxx');
            Fluttertoast.showToast(
                msg: "Você precisa de um plano para navegar pelo aplicativo.",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xff21BCCE),
                textColor: Colors.white,
                fontSize: 16.0);
            Modular.to.pushNamed('/signature');
          }
        }
      } else {
        if (_userDoc['doctor_id'] == null) {
          print('xxxxxxxxxxxxx else>if ${Modular.to.path} xxxxxxxxxxxxxxxxxx');
          authStore.viewDoctorId = null;

          // if (Modular.to.path != '/profile/' &&
          //     Modular.to.path != '/profile' &&
          //     Modular.to.path != '/profile/edit-profile' &&
          //     Modular.to.path != '/settings/preferences' &&
          //     Modular.to.path != '/choose-doctor' &&
          //     Modular.to.path != '/suport' &&
          //     Modular.to.path != '/suport/') {
          if (Modular.to.path == '/main/' || Modular.to.path == '/') {
            Modular.to.pushNamed('/profile');

            Fluttertoast.showToast(
                msg: "Nenhum médico associado",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Color(0xff21BCCE),
                textColor: Colors.white,
                fontSize: 16.0);
          }
        } else {
          if (!_userDoc['doctor_is_premium']) {
            logout('O médico(a) ao qual você está associado, não é premium');
          }
        }
      }
    }
  }

  getTansactions() {
    Stream<QuerySnapshot> trncs = FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.viewDoctorId)
        .collection('transactions')
        .orderBy('updated_at', descending: true)
        .snapshots();

    trncs.listen((event) {
      num aux = 0;
      if (trFilter == 'all') {
        transactions.clear();
        event.docs.forEach((element) {
          transactions.add(element);
        });
        for (var i = 0; i < transactions.length; i++) {
          var transactionDoc = transactions[i];
          if (transactionDoc['type'] != 'SUBSCRIPTION' &&
              transactionDoc['type'] != 'UNSUBSCRIPTION' &&
              transactionDoc['status'] != 'REFUND' &&
              transactionDoc['status'] != 'PENDING_REFUND' &&
              transactionDoc['status'] != 'INCOME') {
            aux += transactionDoc['value'];
          }
        }
        totalAmount = aux;
      }

      if (trFilter == 'credits') {
        transactions.clear();
        event.docs.forEach((element) {
          if ((element.get('status') == 'INCOME' &&
                  element.get('type') != 'PAYOUT') ||
              element.get('status') == 'PENDING_INCOME' ||
              element.get('status') == 'REFUND_REQUESTED_INCOME') {
            transactions.add(element);
          }
        });
      }
      if (trFilter == 'debits') {
        transactions.clear();
        event.docs.forEach((element) {
          if (element.get('status') != 'INCOME' &&
              element.get('status') != 'PENDING_INCOME' &&
              element.get('status') != 'REFUND_REQUESTED_INCOME') {
            transactions.add(element);
          }
          if (element.get('status') == 'INCOME' &&
              element.get('type') == 'PAYOUT') {
            transactions.add(element);
          }
        });
      }
    });
  }

  String formatedCurrency(var value) {
    var numberFormat = new NumberFormat("#,##0.00", "pt_BR");
    var newValue = numberFormat;
    return newValue.format(value);
  }

  getUser() {
    userSnap = null;
    Stream<DocumentSnapshot> userDoc = FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .snapshots();

    userDoc.listen((event) {
      if (event != null) {
        userSnap = event;
        notifications = event.get('notification_disabled');
        print('userSnapshot: ${userSnap.id}');
      }
    });
  }

  bool getSupport() {
    bool aux = false;
    supportStream = FirebaseFirestore.instance
        .collection('support')
        .where('doctor_id', isEqualTo: authStore.user.uid)
        .snapshots();

    supportStream.listen((event) {
      if (event.docs.isNotEmpty) {
        support = event;
        supportId = support.docs.first.id;
        aux = true;
      }
    });
    return aux;
  }

  setSupportChat() async {
    String avatar;

    support = await FirebaseFirestore.instance
        .collection('support')
        .where('doctor_id', isEqualTo: authStore.user.uid)
        .get();

    DocumentSnapshot drSnap = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();

    avatar = drSnap.get('avatar');

    if (avatar == null) {
      avatar =
          'https://firebasestorage.googleapis.com/v0/b/encontrar-cuidado-project.appspot.com/o/settings%2FuserDefaut.png?alt=media&token=4c4aa544-555a-4c1d-bef1-0b61a1e2dc10';
    }

    if (support.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('support').add({
        'created_at': FieldValue.serverTimestamp(),
        'patient_id': null,
        'doctor_id': authStore.user.uid,
        'user_avatar': avatar,
        'support_avatar': avatar,
        'usr_notifications': 0,
        'sp_notifications': 0,
        'updated_at': FieldValue.serverTimestamp(),
      }).then((value1) async {
        await value1.update({
          'id': value1.id,
        });
        supportId = value1.id;
      });
    } else {
      supportId = support.docs.first.id;
    }
  }

  @action
  getInfo() async {
    String type;
    DocumentSnapshot _user = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();
    type = _user['type'];

    if (type == 'SECRETARY') {
      if (allowed == true) {
        await getTansactions();
      }
    } else {
      await getTansactions();
    }

    info = await FirebaseFirestore.instance.collection('info').get();

    Stream<DocumentSnapshot> doctor = FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.viewDoctorId)
        .snapshots();

    doctor.listen((event) {
      doctorSnap = event;
    });
  }

  hasChatWith(String patID) async {
    hasChat = false;
    patientId = patID;
    QuerySnapshot chat = await FirebaseFirestore.instance
        .collection('chats')
        .where('patient_id', isEqualTo: patientId)
        .where('doctor_id', isEqualTo: authStore.viewDoctorId)
        .get();

    DocumentSnapshot pat = await FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId)
        .get();

    patAvatar = pat.get('avatar');
    if (chat.docs.isNotEmpty) {
      profileChat = chat.docs.first;
      chatName = pat.get('username');
      hasChat = true;
    }
    if (!chat.docs.isNotEmpty) {
      hasChat = false;
    }
    consultChat = true;
    setSelectedTrunk(3);
  }

  String getVisitType(String type) {
    switch (type) {
      case "FIT":
        return "Encaixe de paciente";
        break;
      case "SCHEDULE":
        return "Consulta médica";
        break;
      case "RETURN":
        return "Retorno";
        break;
      case "RESQUEDULE":
        return "Reagendamento";
        break;
      default:
        return "Não informado";
    }
  }
}
