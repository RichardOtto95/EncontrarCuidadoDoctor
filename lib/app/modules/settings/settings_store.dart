import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/modules/main/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';
part 'settings_store.g.dart';

class SettingsStore = _SettingsStoreBase with _$SettingsStore;

abstract class _SettingsStoreBase with Store {
  final MainStore mainStore = Modular.get();

  @observable
  num returnPeriod, price;
  @observable
  bool allowed = false;
  @observable
  bool loadCircular = false;

  Future<void> savePreferences() async {
    DocumentSnapshot _doctor = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.viewDoctorId)
        .get();
    if (price != null) {
      _doctor.reference.update({'price': price});
    }
    if (returnPeriod != null) {
      _doctor.reference.update({'return_period': returnPeriod});
    }
    Modular.to.pop();
  }

  void canSave() async {
    loadCircular = true;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();

    num doctorPrice = userDoc['price'];

    if ((price != null && price >= 5) || doctorPrice >= 5) {
      await savePreferences();
      requireToast("Alterações salvas com sucesso");
    } else {
      requireToast("Defina um preço de pelo menos 5 reais.");
    }
    loadCircular = false;
  }

  Future<bool> canBack(BuildContext context) async {
    String viewDoctorId = mainStore.authStore.viewDoctorId;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(mainStore.authStore.user.uid)
        .get();
    String userType = userDoc['type'];

    if (userType == 'SECRETARY') {
      if (viewDoctorId != null && allowed == true) {
        DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(viewDoctorId)
            .get();

        num price = doctorDoc['price'];

        if (price < 5) {
          requireToast("Defina um preço de pelo menos 5 reais!");
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } else {
      num price = userDoc['price'];

      if (price < 5) {
        requireToast("Defina um preço de pelo menos 5 reais!");
        return false;
      } else {
        return true;
      }
    }
  }

  void requireToast(String txt) {
    Fluttertoast.showToast(
        msg: txt,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xff21BCCE),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @action
  swiftNot(DocumentSnapshot user, bool value) async {
    await user.reference.update({'notification_disabled': value});
  }
}
