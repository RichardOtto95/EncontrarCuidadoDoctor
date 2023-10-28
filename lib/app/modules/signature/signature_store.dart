import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:encontrar_cuidadodoctor/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';

import 'widgets/confirm_card.dart';
import 'widgets/email_dialog.dart';
part 'signature_store.g.dart';

class SignatureStore = _SignatureStoreBase with _$SignatureStore;

abstract class _SignatureStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final MainStore mainStore = Modular.get();
  @observable
  List cardsList;
  @observable
  List cardsList2;
  @observable
  ObservableMap focusNodeMap = ObservableMap();
  @observable
  Map<String, dynamic> cardMap = Map();
  @observable
  bool input = false, inputState = false, inputCity = false;
  @observable
  List listCitys = [], listStates = [];
  @observable
  List newListCitys = [], newListStates = [];
  @observable
  TextEditingController textEditingControllerState = TextEditingController();
  @observable
  TextEditingController textEditingControllerCity = TextEditingController();
  @observable
  int hexDec = (Random().nextDouble() * 0xffffffff).toInt() << 0,
      hexDec2 = (Random().nextDouble() * 0xffffffff).toInt() << 0;
  @observable
  bool removingCard = false,
      signing = false,
      haveSubscribe = false,
      cancelDialog = false;
  @observable
  bool loadCircularEmailDialog = false, hasValidEmail = false;
  @observable
  Timer _timer;
  @observable
  bool loadCircularButton = false;
  @observable
  String futureInvoice;
  @observable
  OverlayEntry emailOverlay;
  @observable
  OverlayEntry addCardOverlay;
  @observable
  bool renew = false, renewDialog = false;

  Future<bool> removeType() async {
    print('rrrrrrrrrrremoveType');
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();

    if (!doctorDoc['premium']) {
      QuerySnapshot _cards =
          await doctorDoc.reference.collection('cards').get();
      QuerySnapshot _feed = await doctorDoc.reference.collection('feed').get();
      QuerySnapshot _ratings =
          await doctorDoc.reference.collection('ratings').get();
      QuerySnapshot _schedules =
          await doctorDoc.reference.collection('schedules').get();
      QuerySnapshot _transactions =
          await doctorDoc.reference.collection('transactions').get();
      QuerySnapshot _secretaries =
          await doctorDoc.reference.collection('secretaries').get();

      bool dontHaveCards = _cards.docs.isEmpty;
      bool dontHaveFeed = _feed.docs.isEmpty;
      bool dontHaveRatings = _ratings.docs.isEmpty;
      bool dontHaveSchedules = _schedules.docs.isEmpty;
      bool dontHaveTransactions = _transactions.docs.isEmpty;
      bool dontHaveSecretaries = _secretaries.docs.isEmpty;

      bool heCanDeleteTheProfile = dontHaveCards &&
          dontHaveFeed &&
          dontHaveRatings &&
          dontHaveSchedules &&
          dontHaveTransactions &&
          dontHaveSecretaries;

      if (heCanDeleteTheProfile) {
        await doctorDoc.reference.update({'type': null});
      }
      return heCanDeleteTheProfile;
    } else {
      mainStore.premium = true;
      return true;
    }
  }

  void getDate() async {
    DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .get();

    if (doctorDoc['subscription_id'] != null) {
      FirebaseFunctions functions = FirebaseFunctions.instance;
      // functions.useFunctionsEmulator('localhost', 5001);
      HttpsCallable callable = functions.httpsCallable('futureInvoice');

      try {
        HttpsCallableResult<String> nextInvoice = await callable.call({
          "subscriptionId": doctorDoc['subscription_id'],
        });

        if (doctorDoc['subscription_status'] == 'PENDING_CANCELLATION') {
          futureInvoice =
              'Sua assinatura será cancelada em ${nextInvoice.data}.';
        } else {
          futureInvoice =
              'Sua próxima data de cobrança será em ${nextInvoice.data}.';
        }
      } catch (e) {
        print('xxxxxxxxxx ERRO: $e');
      }
    } else {
      if (doctorDoc['subscription_status'] == 'FREE_DAYS' ||
          doctorDoc['subscription_status'] == 'FREE_DAYS_CANCELED') {
        DateTime subscriptionCreatedAt =
            doctorDoc['subscription_created_at'].toDate();

        QuerySnapshot infoQuery =
            await FirebaseFirestore.instance.collection('info').get();

        DocumentReference infoRef = infoQuery.docs.first.reference;

        await infoRef.update({'timestamp': FieldValue.serverTimestamp()});

        DocumentSnapshot infoDoc = await infoRef.get();

        DateTime dateTimeNow = infoDoc.get('timestamp').toDate();

        int differenceInDays =
            dateTimeNow.difference(subscriptionCreatedAt).inDays;

        int freedays = infoDoc['free_days'];

        int daysRemaining = freedays - differenceInDays;

        print('dddddddddddddddd datas $dateTimeNow - $subscriptionCreatedAt');

        print(
            'dddddddddddddddd datas2 ${dateTimeNow.difference(subscriptionCreatedAt).inDays}');

        print('dddddddddddddddd datas3 $daysRemaining');

        futureInvoice =
            'Você ainda tem $daysRemaining dia(s) grátis restante(s).';
      }
    }
  }

  void getColors() {
    hexDec = (Random().nextDouble() * 0xffffffff).toInt() << 0;
    hexDec2 = (Random().nextDouble() * 0xffffffff).toInt() << 0;
  }

  Future<void> cancelSignature() async {
    print('xxxxxxxxxxxx cancelSignature xxxxxxxxxxxxxxx');

    FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);
    HttpsCallable callable = functions.httpsCallable('removeSignature');
    try {
      await callable.call({
        "userId": authStore.user.uid,
      });
    } on FirebaseFunctionsException catch (e) {
      print('xxxxxxxxxxxx Não deu certo xxxxxxxxxxxxxxx');
      print('ERROR: $e');
    }
  }

  Future<String> signat() async {
    print('xxxxxxxxxxxx signat xxxxxxxxxxxxxxx');

    FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);
    HttpsCallable callable = functions.httpsCallable('signing');
    print('xxxxxxxxxxxx try xxxxxxxxxxxxxxx');

    HttpsCallableResult<String> errorCode = await callable.call({
      "userId": authStore.user.uid,
    });

    if (errorCode.data != null) {
      print('Não foi possível contratar o plano EncontrarCuidado.');
      return errorCode.data;
    } else {
      getDate();
      return null;
    }
  }

  void changedMain(String cardId, bool value) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);
    HttpsCallable callable = functions.httpsCallable('changingCardToMain');
    try {
      await callable.call({
        "cardId": cardId,
        "userId": authStore.user.uid,
        "main": value,
        "userCollection": "doctors",
      });
    } on FirebaseFunctionsException catch (e) {
      print('xxxxxxxxxxxx Não deu certo xxxxxxxxxxxxxxx');
      print('ERROR: $e');
    }
  }

  Future removeCard(String cardId) async {
    FirebaseFunctions functions = FirebaseFunctions.instance;
    // functions.useFunctionsEmulator('localhost', 5001);
    HttpsCallable callable = functions.httpsCallable('deleteCard');
    try {
      await callable.call({
        "cardId": cardId,
        "userId": authStore.user.uid,
        "userCollection": "doctors",
      });
    } on FirebaseFunctionsException catch (e) {
      print('xxxxxxxxxxxx Não deu certo xxxxxxxxxxxxxxx');
      print('ERROR: $e');
    }

    removingCard = false;

    Modular.to.pop();
  }

  Future<bool> isSingleCard() async {
    QuerySnapshot cardsQuery = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(authStore.user.uid)
        .collection('cards')
        .where('status', isEqualTo: 'ACTIVE')
        .get();

    return cardsQuery.docs.length > 1;
  }

  Future<void> pushProfile() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection("doctors")
        .doc(mainStore.authStore.user.uid)
        .get();
    loadCircularEmailDialog = false;
    if (emailOverlay != null && emailOverlay.mounted) {
      emailOverlay.remove();
    }
    DoctorModel doctorModel = DoctorModel.fromDocument(userDoc);
    Modular.to.pushNamed('/signature/edit-profile', arguments: doctorModel);
  }

  Future<void> getValidEmail() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      User _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        await _user.reload();

        if (_user.emailVerified) {
          flutterToast('O seu e-mail foi validado!');
          if (emailOverlay != null && emailOverlay.mounted) {
            emailOverlay.remove();
          }
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
    return null;
  }

  Future<void> validateEmail() async {
    print('xxxxxxxxxxxxxx validateEmail ${authStore.user}');
    User _user = FirebaseAuth.instance.currentUser;

    await _user.reload();

    if (_user.emailVerified) {
      flutterToast('E-mail já validado!');
      loadCircularEmailDialog = false;
    } else {
      try {
        await authStore.user.sendEmailVerification();
        if (_timer == null || !_timer.isActive) {
          getValidEmail();
        }
        flutterToast('Link enviado com sucesso!');
        loadCircularEmailDialog = false;
      } catch (e) {
        print('$e');

        flutterToast(
            'Espere alguns minutos para poder enviar outro email de verificação');
        loadCircularEmailDialog = false;
      }
    }
  }

  Future<int> hasEmail() async {
    User _user = FirebaseAuth.instance.currentUser;
    bool emailVerified = false;
    int returnIndex = 0;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(_user.uid)
        .get();

    print('xxxxxxxxxxxx hasEmail ${userDoc['email']} xxxxxxxxxxxxxxx');

    if (userDoc['email'] != null) {
      emailVerified = _user.emailVerified;
      print('xxxxxxxxxxxx hasEmail $emailVerified xxxxxxxxxxxxxxx');

      if (!emailVerified) {
        returnIndex = 1;
        // Tem email, mas não foi validado.
      }
    } else {
      returnIndex = 2;
      // ainda não tem email.
    }
    return returnIndex;
  }

  Future saveCard(context) async {
    print('xxxxxxxxxxxxxxxxxxx cadMap $cardMap');

    loadCircularButton = true;
    int index = await hasEmail();
    if (index == 0) {
      loadCircularButton = false;

      addCardOverlay = OverlayEntry(
        builder: (context) => ConfirmCard(
          svgWay: 'assets/svg/confirmaddcard.svg',
          text: 'Tem certeza que deseja adicionar \nesse cartão?',
          onBack: () {
            addCardOverlay.remove();
          },
          onConfirm: () async {
            OverlayEntry loadOverlay;
            loadOverlay =
                OverlayEntry(builder: (context) => LoadCircularOverlay());
            Overlay.of(context).insert(loadOverlay);
            // user create stripe customer, after create card in stripe.
            User _user = FirebaseAuth.instance.currentUser;
            FirebaseFunctions functions = FirebaseFunctions.instance;
            // functions.useFunctionsEmulator('localhost', 5001);
            HttpsCallable callable =
                functions.httpsCallable('createStripeCustomer');

            print('main ${cardMap['main']}');
            if (cardMap['main'] == null) {
              cardMap['main'] = false;
            }

            print('xxxxxxxxxxxxxxxxxx card_number $cardMap');

            HttpsCallableResult<String> hasError = await callable.call({
              "uid": _user.uid,
              "email": _user.email,
              "card": cardMap,
              "userCollection": "doctors",
            });

            print(
                'xxxxxxxxxxxxxxxxxxxxx hasError ${hasError.data} xxxxxxxxxxxxxxxxxxxxxxxx');

            if (hasError.data != '') {
              String text;
              switch (hasError.data) {
                case 'incorrect_number':
                  text = 'Número de cartão inválido!';
                  break;

                case 'card_declined':
                  text = 'Cartão recusado!';
                  break;

                case 'expired_card':
                  text = 'Cartão expirado!';
                  break;

                case 'invalid_expiry_year':
                  text = 'Cartão expirado!';
                  break;

                case 'incorrect_cvc':
                  text = 'Código de segurança inválido!';
                  break;

                case 'processing_error':
                  text = 'Erro ao criar cartão!';
                  break;

                default:
                  text = 'Erro ao criar cartão!';
                  break;
              }
              flutterToast(text, true);
              loadOverlay.remove();
              addCardOverlay.remove();
            } else {
              cardMap = Map();

              textEditingControllerCity.clear();
              textEditingControllerState.clear();

              listCitys = [];
              newListCitys = [];
              newListStates = [];

              input = false;

              Modular.to.pop();
              loadOverlay.remove();
              addCardOverlay.remove();
            }
          },
        ),
      );
      Overlay.of(context).insert(addCardOverlay);
    } else {
      print('xxxxxxxxxxxx Não tem email xxxxxxxxxxxxxxx');
      loadCircularButton = false;
      hasValidEmail = index == 1 ? true : false;

      emailOverlay = OverlayEntry(
        builder: (context) => EmailDialog(
          onCancel: () {
            emailOverlay.remove();
          },
          title: 'Você não possui um e-mail válido ainda.',
        ),
      );

      Overlay.of(context).insert(emailOverlay);
    }
  }

  void getCitys() async {
    QuerySnapshot info =
        await FirebaseFirestore.instance.collection('info').get();

    DocumentSnapshot docInfo = info.docs.first;
    QuerySnapshot states = await docInfo.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      if (state['name'] == cardMap['billing_state']) {
        listCitys = state['citys'];
      }
    });
  }

  void filterListCity(String text) {
    List newList = [];

    if (text != '') {
      listCitys.forEach((city) {
        if (!newList.contains(city) && city.toLowerCase().contains(text)) {
          newList.add(city);
        }
      });

      newListCitys = newList;
    } else {
      newListCitys = [];
    }
  }

  void filterListState(String textState) {
    List newList = [];
    if (textState != '') {
      listStates.forEach((state) {
        if (!newList.contains(state) &&
            state.toLowerCase().contains(textState)) {
          newList.add(state);
        }
      });
      newListStates = newList;
    } else {
      newListStates = [];
    }
  }

  void getStates() async {
    List list = [];
    QuerySnapshot info =
        await FirebaseFirestore.instance.collection('info').get();

    DocumentSnapshot docInfo = info.docs.first;
    QuerySnapshot states = await docInfo.reference.collection('states').get();

    states.docs.forEach((DocumentSnapshot state) {
      list.add(state['name'] + ' - ' + state['acronyms']);
    });
    listStates = list;
  }

  void getCards(QuerySnapshot cardsQuery) {
    if (cardsQuery.docs.isNotEmpty) {
      cardsList = cardsQuery.docs.toList();
    } else {
      cardsList = [];
    }
  }

  void flutterToast(String text, [bool alert = false]) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: alert ? Colors.red : Color(0xff41C3B3),
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
