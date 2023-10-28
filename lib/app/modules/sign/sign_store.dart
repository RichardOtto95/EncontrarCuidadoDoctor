import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encontrar_cuidadodoctor/app/core/models/doctor_model.dart';
import 'package:encontrar_cuidadodoctor/app/core/modules/root/root_store.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_service_interface.dart';
import 'package:encontrar_cuidadodoctor/app/core/services/auth/auth_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobx/mobx.dart';

part 'sign_store.g.dart';

class SignStore = _SignStoreBase with _$SignStore;

abstract class _SignStoreBase with Store {
  final AuthStore authStore = Modular.get();
  final RootStore rootStore = Modular.get();
  final DoctorModel doctor;
  AuthServiceInterface authService = Modular.get();
  @observable
  User valueUser;
  @observable
  User valueUser1;
  @observable
  User sadasda;
  @observable
  bool loadCircularPhone = false;
  @observable
  String phone = '';
  @observable
  String code = '';
  @observable
  Timer timer;
  @observable
  int start = 60;
  @observable
  bool loadCircularVerify = false;
  @observable
  TextEditingController textEditingController = TextEditingController();

  _SignStoreBase(this.doctor);
  @action
  setUserPhone(String telephone) => phone = telephone;

  @action
  verifyNumber() async {
    print('verify numberrrrrrrrrrrrrrrrr');
    print('phone: $phone');
    String userPhone = '+55' + phone;
    print('userPhone: $userPhone');
    QuerySnapshot _patients = await FirebaseFirestore.instance
        .collection('patients')
        .where('phone', isEqualTo: userPhone)
        .get();
    QuerySnapshot _admins = await FirebaseFirestore.instance
        .collection('admins')
        .where('mobile_full_number', isEqualTo: userPhone)
        .get();
    QuerySnapshot _doctors = await FirebaseFirestore.instance
        .collection('doctors')
        .where('phone', isEqualTo: userPhone)
        .get();

    if (_patients.docs.isNotEmpty || _admins.docs.isNotEmpty) {
      Fluttertoast.showToast(
        msg:
            "Esse número de usuário não tem permissão para acessar este aplicativo",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red[700],
        textColor: Colors.white,
        fontSize: 16.0,
      );
      loadCircularPhone = false;
    } else {
      if (_doctors.docs.isNotEmpty &&
          _doctors.docs.first.get("status") == "BLOCKED") {
        loadCircularPhone = false;
        Fluttertoast.showToast(msg: "Este usuário está bloqueado!");
      } else {
        if (_doctors.docs.isNotEmpty &&
            _doctors.docs.first.get("type") == 'SECRETARY' &&
            _doctors.docs.first.get("doctor_is_premium") == false &&
            _doctors.docs.first.get("doctor_id") != null) {
          loadCircularPhone = false;
          Fluttertoast.showToast(
              msg: "O doutor(a) ao qual você está associado, não é premium.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              // backgroundColor: Color(0xff21BCCE),
              backgroundColor: Colors.red[700],
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          // Modular.to.pushNamed('/phone-verify');

          await authStore.verifyNumber(phone, (String errorCode) {
            loadCircularPhone = false;

            if (errorCode == 'invalid-phone-number') {
              Fluttertoast.showToast(
                  msg: "Número inválido.",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  // backgroundColor: Color(0xff21BCCE),
                  backgroundColor: Colors.red[700],
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          });
        }
      }
    }
  }

  @action
  setUserCode(String _userd) => code = _userd;
  @action
  signinPhone(String _code, String verifyId, BuildContext context) async {
    authStore.handleSmsSignin(_code, verifyId).then((value) async {
      print('%%%%%%%%%% signinPhone $value %%%%%%%%%%');

      if (value != null) {
        valueUser = value;
        var _user = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(value.uid)
            .get();

        // if (authStore.user == null) {
        //   print('authhhh user nulllll');
        //   authStore.authServiceHandleGetUser();
        // }

        // String token = await FirebaseMessaging.instance.getToken();
        // print('tokenId: $token');
        // print('xxxxxxxxxxxxxxx _user ${_user.data()} xxxxxxxxxxxxxxxx');
        // await _user.reference.update({
        //   'token_id': FieldValue.arrayUnion([token])
        // });

        print('xxxxxxxxxxxxxxx _user.exists ${_user.exists} xxxxxxxxxxxxxxxx');

        textEditingController.clear();
        phone = '';

        if (_user.exists) {
          loadCircularVerify = false;
          await Modular.to.pushNamed('/main');

          // rootStore.setSelectedTrunk(2);
        } else {
          doctor.phone = value.phoneNumber;
          await authService.handleSignup(doctor);
          loadCircularVerify = false;

          await Modular.to.pushNamed('/sign/boarding');
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context) => ChooseType()));
          // rootStore.setSelectedTrunk(2);
        }
        authStore.getUserType();
      } else {
        loadCircularVerify = false;
      }
    });
  }

  Future<bool> loginSuccess(UserCredential userCredential) async {
    print('lllllllllllll loginSuccess $userCredential');
    print('lllllllllllll loginSuccess1 ${userCredential.user}');
    print('lllllllllllll loginSuccess2 ${userCredential.user.uid}');
    print('lllllllllllll loginSuccess3 ${userCredential.credential}');

    try {
      String userUid = userCredential.user.uid;

      authStore.user = userCredential.user;

      // _auth.signInWithCredential(userCredential.credential);

      var _user = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(userUid)
          .get();

      print('xxxxxxxxxxxxxxx _user.exists ${_user.exists} xxxxxxxxxxxxxxxx');

      if (_user.exists) {
        await Modular.to.pushNamed('/main');
      } else {
        doctor.phone = '+55' + phone;
        await authService.handleSignup(doctor);
        await Modular.to.pushNamed('/sign/boarding');
      }
      authStore.getUserType();

      return false;
    } catch (e) {
      print(e);
      return true;
    }
  }
}
